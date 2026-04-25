import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:plantify/util/container.dart';

import '../main.dart';

class UtilCamera extends StatefulWidget {
  const UtilCamera({super.key});

  @override
  State<UtilCamera> createState() => UtilCameraState();
}

class UtilCameraState extends State<UtilCamera> {
  CameraController? controller;
  bool isReady = false;
  int cameraIndex = 0;
  FlashMode flashMode = FlashMode.off;
  FlashMode get currentFlashMode => flashMode;
  bool enableFlash = true;
  bool get currentEnableFlash => enableFlash;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    controller = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.medium,
    );

    await controller!.initialize();

    await controller!.setFlashMode(flashMode);

    if (!mounted) return;

    setState(() {
      isReady = true;
    });
  }

  bool isBackCamera() {
    return cameras[cameraIndex].lensDirection == CameraLensDirection.back;
  }

  //switch camera
  Future<void> switchCamera() async {
    cameraIndex = (cameraIndex + 1) % cameras.length;

    await controller?.dispose();

    controller = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.medium,
    );

    await controller!.initialize();

    enableFlash = isBackCamera();
    flashMode = FlashMode.off;
    await controller!.setFlashMode(flashMode);

    if (!mounted) return;

    setState(() {});
  }

  //flash
  Future<void> switchFlash() async {
    if (!enableFlash) return;
    flashMode = flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await controller!.setFlashMode(flashMode);

    setState(() {});
  }

  //focus
  Future<void> focusAt(Offset point) async {
    if (controller == null || !controller!.value.isInitialized) return;

    await controller!.setFocusMode(FocusMode.auto);
    await controller!.setFocusPoint(point);
    await controller!.setExposurePoint(point);
  }

  //take picture
  Future<XFile?> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return null;

    try {
      final XFile file = await controller!.takePicture();
      return file;
    } catch (e) {
      debugPrint("Error taking picture: $e");
      return null;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady || controller == null) {
      return UtilContainer(
        color: Colors.black,
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller!.value.previewSize!.height,
          height: controller!.value.previewSize!.width,
          child: CameraPreview(controller!),
        ),
      ),
    );
  }
}