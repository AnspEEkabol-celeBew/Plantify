import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:plantify/screen/authentication/setup.dart';
import 'package:plantify/screen/home/main.dart';
import 'package:plantify/screen/introduction/first.dart';
import 'package:plantify/screen/main_app.dart';
import 'package:plantify/screen/splashscreen/splashscreen.dart';
import 'package:plantify/storage/getter.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';

late List<CameraDescription> cameras;
PreferredAnimations preferredAnimations = PreferredAnimations();
PreferredSplashScreen preferredSplashScreen = PreferredSplashScreen();
PreferredLoginUser preferredLoginUser = PreferredLoginUser();

//plantifyapp780@gmail.com
//plantifyapplication12345!?!

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  darkMode.value = await loadPreferencesOnBool("isDarkMode", false);
  preferredSplashScreen.skipVideo = await loadPreferencesOnBool('skipSplash', false);
  preferredLoginUser.isLogin = await loadPreferencesOnBool('isLogin', false);
  preferredLoginUser.doneIntro = await loadPreferencesOnBool('doneIntro', false);
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkMode,
      builder: (context, isDark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HeadApp(),
        );
      },
    );
  }
}