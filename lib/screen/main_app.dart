import 'package:flutter/material.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/authentication/get_started.dart';
import 'package:plantify/screen/home/main.dart';
import 'package:plantify/screen/introduction/first.dart';
import 'package:plantify/screen/splashscreen/splashscreen.dart';

class HeadApp extends StatelessWidget {
  const HeadApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (preferredLoginUser.isLogin) {
      return preferredSplashScreen.skipVideo
          ? const MainHomeScreen()
          : const SplashScreen();
    }

    return preferredSplashScreen.skipVideo
        ? preferredLoginUser.doneIntro
              ? const GetStartedScreen()
              : const FirstIntro()
        : const SplashScreen();
  }
}
