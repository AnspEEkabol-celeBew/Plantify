import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/camera.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/mediaquery.dart';
import 'package:plantify/util/text.dart';

import '../../theme/fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final GlobalKey<UtilCameraState> utilCameraKey = GlobalKey<UtilCameraState>();
  Offset? focusPoint;
  bool showFocus = false;
  Timer? _focusTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          //camera screen
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) async {
                if (!(utilCameraKey.currentState?.isBackCamera()?? true)) return;
                final renderBox = context.findRenderObject() as RenderBox;
                final local = renderBox.globalToLocal(details.globalPosition);

                final size = renderBox.size;

                final normalized = Offset(
                  local.dx / size.width,
                  local.dy / size.height,
                );

                // ⚡ INSTANT UI FEEDBACK (no waiting for camera)
                setState(() {
                  focusPoint = local;
                  showFocus = true;
                });

                // 🔥 cancel previous timer (IMPORTANT FIX)
                _focusTimer?.cancel();

                // camera focus (async but DOES NOT block UI)
                utilCameraKey.currentState?.focusAt(normalized);

                // new timer
                _focusTimer = Timer(const Duration(milliseconds: 600), () {
                  if (!mounted) return;
                  setState(() {
                    showFocus = false;
                  });
                });
              },
              child: UtilCamera(key: utilCameraKey),
            ),
          ),

          //focus indicator
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
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorAccent.secondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),

          //close
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

          //flashlight
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
                (utilCameraKey.currentState?.currentFlashMode?? FlashMode.off) ==
                        FlashMode.off
                    ? Icons.flashlight_off_rounded
                    : Icons.flashlight_on_rounded,
                color: (utilCameraKey.currentState?.currentEnableFlash?? true) == true? colorAccent.white : colorAccent.cardDark,
                size: 26,
              ),
            ),
          ),

          //camera hint
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

          //bottom
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

                //photo
                UtilContainer(
                  height: 80,
                  width: 80,
                  color: colorAccent.white,
                  borderRadius: BorderRadius.circular(13.0),
                  alignment: Alignment.center,
                  child: Icon(Icons.insert_photo_outlined, color: colorAccent.cardDark, size: 35),
                ),

                //capture
                UtilContainer(
                  height: 120,
                  width: 120,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: colorAccent.tertiary,
                    width: 4
                  ),
                  onTap: () async {
                    final file = await utilCameraKey.currentState?.takePicture();

                    if (file == null) return;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PreviewScreen(imagePath: file.path),
                      ),
                    );
                  },
                  child: UtilContainer(
                    height: 108,
                    width: 108,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(100),
                    color: colorAccent.primary,
                    child: Icon(Icons.camera_alt_rounded, color: colorAccent.white, size: 50),
                  ),
                ),

                //switch camera
                // UtilContainer(
                //   height: 80,
                //   width: 80,
                //   color: colorAccent.cameraMaskBlack,
                //   borderRadius: BorderRadius.circular(100.0),
                //   alignment: Alignment.center,
                //   onTap: () async {
                //     await utilCameraKey.currentState?.switchCamera();
                //     setState(() {});
                //   },
                //   child: Icon(Icons.switch_camera_rounded, color: colorAccent.white, size: 26),
                // ),
                UtilContainer(
                  height: 80,
                  width: 80,
                )
              ],
            ),
          )
        ],
      )
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