import 'package:plantify/storage/preferences.dart';

class PreferredAnimations {
  final duration = 150;

  int getDuration() {
    return duration;
  }
}

class PreferredSplashScreen {
  bool skipVideo = true;
}

class PreferredLoginUser {
  bool doneIntro = false;
  bool isLogin = false;
}
