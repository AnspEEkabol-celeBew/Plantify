import 'package:flutter/material.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/introduction/first.dart';
import 'package:plantify/util/navigation.dart';
import 'package:video_player/video_player.dart';

import '../home/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool playVideo = true;
  bool hasNavigated = false;
  bool isLogin = preferredLoginUser.isLogin;

  @override
  void initState() {
    super.initState();

    if (!playVideo) {
      _goToNextScreen();
      return;
    }

    // 🎥 Initialize video
    _controller =
        VideoPlayerController.asset('assets/videos/splash/splash_screen.mp4')
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });

    // 👀 Listen for video end
    _controller.addListener(() {
      if (_controller.value.isInitialized &&
          _controller.value.position >= _controller.value.duration &&
          !_controller.value.isPlaying) {
        _goToNextScreen();
      }
    });
  }

  void _goToNextScreen() {
    if (!mounted || hasNavigated) return;

    hasNavigated = true;

    navigateTo(
      context,
      animationType: NavAnimation.fade,
      duration: 500,
      replace: true,
      page: isLogin? MainHomeScreen() : FirstIntro(),
    );
  }

  @override
  void dispose() {
    if (playVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!playVideo) {
      return isLogin? MainHomeScreen() : FirstIntro();
    }

    return Scaffold(
      backgroundColor: Colors.white, // 👈 white background
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const SizedBox(),
      ),
    );
  }
}
