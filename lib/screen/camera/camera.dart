import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/camera.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/mediaquery.dart';
import 'package:plantify/util/text.dart';

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
  Offset? focusPoint;
  bool showFocus = false;
  Timer? _focusTimer;

  // --- scan overlay state ---
  bool _showScanOverlay = false;
  String? _frozenImagePath;      // frozen frame after capture
  String? _pickedImagePath;      // picked image from gallery
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
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
    _focusTimer?.cancel();
    _scanController.dispose();
    super.dispose();
  }

  // ── FIXED PATH: overwrites old captures, no bloat ──────────────────────────
  Future<String> _getTempPath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/temp_capture.jpg';
  }

  // ── SHARED: run the scan flash then navigate ────────────────────────────────
  Future<void> _runScanAndNavigate(String imagePath) async {
    if (!mounted) return;
    setState(() => _showScanOverlay = true);

    // pulse flash: in → out → in → out (≈1 s total)
    for (int i = 0; i < 2; i++) {
      await _scanController.forward();
      await _scanController.reverse();
    }

    if (!mounted) return;
    setState(() {
      _showScanOverlay = false;
      _frozenImagePath = null;
      _pickedImagePath = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewScreen(imagePath: imagePath),
      ),
    );
  }

  // ── TAKE PICTURE ────────────────────────────────────────────
  Future<void> _onCapture() async {
    final file = await utilCameraKey.currentState?.takePicture();
    if (file == null) return;

    final fixedPath = await _getTempPath();
    await File(file.path).copy(fixedPath);
    try { await File(file.path).delete(); } catch (_) {}

    // ✅ set frozen image FIRST, wait one frame for Image.file to load
    setState(() => _frozenImagePath = fixedPath);
    await Future.delayed(const Duration(milliseconds: 80)); // let Image.file render

    await _runScanAndNavigate(fixedPath);
  }

  // ── PICK IMAGE ───────────────────────────────────────────────
  Future<void> _onPickImage() async {
    // ✅ request permission explicitly before picker
    final status = await Permission.photos.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      // optionally show a snackbar/dialog
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final fixedPath = await _getTempPath();
    await File(picked.path).copy(fixedPath);

    setState(() => _pickedImagePath = fixedPath);
    await Future.delayed(const Duration(milliseconds: 80));
    await _runScanAndNavigate(fixedPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // ── CAMERA ─────────────────────────────────────────────────────────
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) async {
                if (!(utilCameraKey.currentState?.isBackCamera() ?? true)) return;
                final renderBox = context.findRenderObject() as RenderBox;
                final local = renderBox.globalToLocal(details.globalPosition);
                final size = renderBox.size;
                final normalized = Offset(local.dx / size.width, local.dy / size.height);

                setState(() {
                  focusPoint = local;
                  showFocus = true;
                });

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

          // ── FROZEN FRAME (after capture) — covers camera fully ──────
          if (_frozenImagePath != null)
            Positioned.fill(
              child: Container(
                color: Colors.black, // ✅ black base prevents any camera bleed
                child: Image.file(
                  File(_frozenImagePath!),
                  fit: BoxFit.cover,
                  // ✅ frameBuilder prevents the "flash of nothing" while decoding
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Container(color: Colors.black); // placeholder while loading
                  },
                ),
              ),
            ),

          // ── PICKED IMAGE OVERLAY ─────────────────────────────────────
          if (_pickedImagePath != null)
            Positioned.fill(
              child: Container(
                color: Colors.black,
                child: Image.file(
                  File(_pickedImagePath!),
                  fit: BoxFit.contain,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded || frame != null) return child;
                    return Container(color: Colors.black);
                  },
                ),
              ),
            ),

          // ── SCAN FLASH OVERLAY ─────────────────────────────────────────────
          if (_showScanOverlay)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, _) {
                  return Stack(
                    children: [
                      // white pulse flash
                      Opacity(
                        opacity: _scanAnimation.value * 0.55,
                        child: Container(color: Colors.white),
                      ),
                      // scanning line sweeping down
                      Positioned(
                        top: _scanAnimation.value *
                            MediaQuery.of(context).size.height,
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

          // ── CLOSE ──────────────────────────────────────────────────────────
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

          // ── FLASHLIGHT ─────────────────────────────────────────────────────
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
                (utilCameraKey.currentState?.currentFlashMode ?? FlashMode.off) ==
                        FlashMode.off
                    ? Icons.flashlight_off_rounded
                    : Icons.flashlight_on_rounded,
                color: (utilCameraKey.currentState?.currentEnableFlash ?? true) == true
                    ? colorAccent.white
                    : colorAccent.cardDark,
                size: 26,
              ),
            ),
          ),

          // ── HINT ───────────────────────────────────────────────────────────
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

          // ── BOTTOM CONTROLS ────────────────────────────────────────────────
          Positioned(
            bottom: 30,
            left: 0,
            child: UtilFlexBox(
              padding: EdgeInsets.symmetric(horizontal: 10),
              direction: Axis.horizontal,
              main: MainAxisAlignment.spaceEvenly,
              cross: CrossAxisAlignment.center,
              height: 200,
              width: utilMediaQuery.getScreenWidth(context),
              children: [

                // PICK IMAGE button
                UtilContainer(
                  height: 80,
                  width: 80,
                  color: colorAccent.white,
                  borderRadius: BorderRadius.circular(13.0),
                  alignment: Alignment.center,
                  onTap: _onPickImage,  // ✅ wired up
                  child: Icon(Icons.insert_photo_outlined,
                      color: colorAccent.cardDark, size: 35),
                ),

                // CAPTURE button
                UtilContainer(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: colorAccent.tertiary, width: 4),
                  onTap: _onCapture,  // ✅ wired up
                  child: UtilContainer(
                    height: 108,
                    width: 108,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.primary,
                    child: Icon(Icons.camera_alt_rounded,
                        color: colorAccent.white, size: 50),
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

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  const PreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}