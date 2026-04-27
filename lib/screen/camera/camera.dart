import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantify/screen/camera/results.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/camera.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/mediaquery.dart';
import 'package:plantify/util/navigation.dart';
import 'package:plantify/util/text.dart';
import '../../backend/tflite/tflite.dart';
import '../../main.dart';
import '../../theme/fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<UtilCameraState> utilCameraKey = GlobalKey<UtilCameraState>();

  // ── TFLite ──────────────────────────────────────────────────────────────────
  final TfliteService _tfliteService = TfliteService();
  bool _serviceReady = false;

  // ── Focus ───────────────────────────────────────────────────────────────────
  Offset? focusPoint;
  bool showFocus = false;
  Timer? _focusTimer;

  // ── Scan overlay ────────────────────────────────────────────────────────────
  bool _showScanOverlay = false;
  String? _frozenImagePath;
  String? _pickedImagePath;
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _initService();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tfliteService.dispose();
    _focusTimer?.cancel();
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _initService() async {
    await _tfliteService.init();
    if (mounted) setState(() => _serviceReady = true);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Future<String> _getFixedPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/temp_capture.jpg';
  }

  Future<String> _saveToFixedPath(String sourcePath) async {
    final fixedPath = await _getFixedPath();
    await FileImage(File(fixedPath)).evict();
    final existing = File(fixedPath);
    if (await existing.exists()) await existing.delete();
    await File(sourcePath).copy(fixedPath);
    return fixedPath;
  }

  // ── Core: scan animation + TFLite + navigate ─────────────────────────────────

  Future<void> _runScanAndNavigate(String imagePath) async {
    if (!mounted) return;
    setState(() => _showScanOverlay = true);

    // Run scan animation and TFLite inference in parallel
    final results = await Future.wait([
      // Scan line animation (2 passes)
      Future(() async {
        for (int i = 0; i < 2; i++) {
          await _scanController.forward();
          await _scanController.reverse();
        }
      }),
      // TFLite inference
      _tfliteService.recognize(File(imagePath), topK: 5),
    ]);

    if (!mounted) return;
    setState(() {
      _showScanOverlay = false;
      _frozenImagePath = null;
      _pickedImagePath = null;
    });

    // results[1] is the List<Map<String, dynamic>> from recognize()
    final predictions = results[1] as List<Map<String, dynamic>>;

    navigateTo(
      context,
      animationType: NavAnimation.slideUp,
      duration: preferredAnimations.getDuration(),
      page: ResultScreen(imagePath: imagePath, results: predictions[0]),
    );
  }

  // ── Take picture ─────────────────────────────────────────────────────────────

  Future<void> _onCapture() async {
    if (!_serviceReady) {
      debugPrint("qqqq");
      return;
    };

    final file = await utilCameraKey.currentState?.takePicture();
    if (file == null) return;

    final fixedPath = await _saveToFixedPath(file.path);
    try { await File(file.path).delete(); } catch (_) {}

    setState(() => _frozenImagePath = fixedPath);
    await Future.delayed(const Duration(milliseconds: 80));

    await _runScanAndNavigate(fixedPath);
  }

  // ── Pick image ───────────────────────────────────────────────────────────────

  Future<void> _onPickImage() async {
    if (!_serviceReady) return;

    final status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final fixedPath = await _saveToFixedPath(picked.path);

    setState(() => _pickedImagePath = fixedPath);
    await Future.delayed(const Duration(milliseconds: 80));

    await _runScanAndNavigate(fixedPath);
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── CAMERA ───────────────────────────────────────────────────────────
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) async {
                if (!(utilCameraKey.currentState?.isBackCamera() ?? true)) return;
                final renderBox = context.findRenderObject() as RenderBox;
                final local = renderBox.globalToLocal(details.globalPosition);
                final size = renderBox.size;
                final normalized = Offset(local.dx / size.width, local.dy / size.height);

                setState(() { focusPoint = local; showFocus = true; });
                _focusTimer?.cancel();
                utilCameraKey.currentState?.focusAt(normalized);
                _focusTimer = Timer(const Duration(milliseconds: 600), () {
                  if (!mounted) return;
                  setState(() => showFocus = false);
                });
              },
              child: UtilCamera(key: utilCameraKey),
            ),
          ),

          // ── FROZEN FRAME ──────────────────────────────────────────────────────
          if (_frozenImagePath != null)
            Positioned.fill(
              key: ValueKey(_frozenImagePath),
              child: Container(
                color: Colors.black,
                child: Image.file(
                  File(_frozenImagePath!),
                  fit: BoxFit.cover,
                  gaplessPlayback: false,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Container(color: Colors.black);
                  },
                ),
              ),
            ),

          // ── PICKED IMAGE OVERLAY ──────────────────────────────────────────────
          if (_pickedImagePath != null)
            Positioned.fill(
              key: ValueKey(_pickedImagePath),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(color: const Color.fromRGBO(0, 0, 0, 0.4)),
                  ),
                  Image.file(
                    File(_pickedImagePath!),
                    fit: BoxFit.contain,
                    gaplessPlayback: false,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) return child;
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

          // ── SCAN OVERLAY ──────────────────────────────────────────────────────
          if (_showScanOverlay)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, _) {
                  return Stack(
                    children: [
                      Opacity(
                        opacity: _scanAnimation.value * 0.55,
                        child: Container(color: Colors.white),
                      ),
                      Positioned(
                        top: _scanAnimation.value * MediaQuery.of(context).size.height,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                colorAccent.secondary,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // ── FOCUS INDICATOR ───────────────────────────────────────────────────
          if (showFocus && focusPoint != null)
            Positioned(
              left: focusPoint!.dx - 40,
              top: focusPoint!.dy - 40,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showFocus ? 1 : 0,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.8, end: 1.2),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: colorAccent.secondary, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ),

          // ── CLOSE ─────────────────────────────────────────────────────────────
          Positioned(
            top: 60,
            left: 30,
            child: UtilContainer(
              color: colorAccent.cameraMaskBlack,
              width: 65,
              height: 65,
              borderRadius: BorderRadius.circular(100),
              alignment: Alignment.center,
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, color: colorAccent.white, size: 26),
            ),
          ),

          // ── FLASHLIGHT ────────────────────────────────────────────────────────
          Positioned(
            top: 60,
            right: 30,
            child: UtilContainer(
              color: colorAccent.cameraMaskBlack,
              width: 65,
              height: 65,
              borderRadius: BorderRadius.circular(100),
              alignment: Alignment.center,
              onTap: () async {
                await utilCameraKey.currentState?.switchFlash();
                setState(() {});
              },
              child: Icon(
                (utilCameraKey.currentState?.currentFlashMode ?? FlashMode.off) == FlashMode.off
                    ? Icons.flashlight_off_rounded
                    : Icons.flashlight_on_rounded,
                color: (utilCameraKey.currentState?.currentEnableFlash ?? true)
                    ? colorAccent.white
                    : colorAccent.cardDark,
                size: 26,
              ),
            ),
          ),

          // ── HINT ──────────────────────────────────────────────────────────────
          Positioned(
            top: 200,
            left: (utilMediaQuery.getScreenWidth(context) / 2) - 150,
            child: UtilContainer(
              width: 300,
              height: 40,
              alignment: Alignment.center,
              child: UtilText(
                "Align the plant inside the frame",
                color: colorAccent.white,
                size: 16,
                family: Fonts.defaultFontExtraLight,
              ),
            ),
          ),

          // ── BOTTOM CONTROLS ───────────────────────────────────────────────────
          Positioned(
            bottom: 30,
            left: 0,
            child: UtilFlexBox(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              direction: Axis.horizontal,
              main: MainAxisAlignment.spaceEvenly,
              cross: CrossAxisAlignment.center,
              height: 200,
              width: utilMediaQuery.getScreenWidth(context),
              children: [
                UtilContainer(
                  height: 80,
                  width: 80,
                  color: colorAccent.white,
                  borderRadius: BorderRadius.circular(13.0),
                  alignment: Alignment.center,
                  onTap: _onPickImage,
                  child: Icon(Icons.insert_photo_outlined, color: colorAccent.cardDark, size: 35),
                ),

                UtilContainer(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: colorAccent.tertiary, width: 4),
                  onTap: _onCapture,
                  child: UtilContainer(
                    height: 108,
                    width: 108,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.primary,
                    child: Icon(Icons.camera_alt_rounded, color: colorAccent.white, size: 50),
                  ),
                ),

                UtilContainer(height: 80, width: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Preview screen ────────────────────────────────────────────────────────────

class PreviewScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> results;

  const PreviewScreen({
    super.key,
    required this.imagePath,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: Column(
          children: [
            Image.file(File(imagePath), gaplessPlayback: false),
            Text(results['name'].toString()),
            Text((results['confidence']*100).toString()),
          ],
        ),
      ),
    );
  }
}