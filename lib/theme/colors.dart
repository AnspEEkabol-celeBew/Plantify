import 'package:flutter/material.dart';

ValueNotifier<bool> darkMode = ValueNotifier(false);

Color darken(Color color, double value) {
  final hsl = HSLColor.fromColor(color);
  final darker = hsl.withLightness((hsl.lightness - value).clamp(0.0, 1.0));
  return darker.toColor();
}

Color lighten(Color color, double value) {
  final hsl = HSLColor.fromColor(color);
  final darker = hsl.withLightness((hsl.lightness + value).clamp(0.0, 1.0));
  return darker.toColor();
}

Color invertLightness(Color color) {
  final hsl = HSLColor.fromColor(color);
  final invert = hsl.withLightness(1.0 - hsl.lightness);
  return invert.toColor();
}

class ColorAccent {
  Color get primary => darkMode.value? darken(Color(0xff36C778), 0.1) : Color(0xff36C778);
  Color get secondary => darkMode.value? darken(Color(0xff2FAF69), 0.1) : Color(0xff2FAF69);
  Color get tertiary => darkMode.value? darken(Color(0xff27965A), 0.1) : Color(0xff27965A);
  Color get error => darkMode.value? darken(Color(0xffE53935), 0.1) : Color(0xffE53935);
  Color get warning => darkMode.value? darken(Color(0xffF4C430), 0.1) : Color(0xffF4C430);
  Color get info => darkMode.value? darken(Color(0xff3B82F6), 0.1) : Color(0xff3B82F6);
  Color get background => darkMode.value? lighten(invertLightness(Color(0xffffffff)), 0.1) : Color(0xffffffff);
  Color get primaryText => darkMode.value? invertLightness(Color(0xff000000)) : Color(0xff000000);
  Color get secondaryText => darkMode.value? invertLightness(Color(0xff4A4A4A)) : Color(0xff4A4A4A);
  Color get cardDark => darkMode.value? invertLightness(Color(0xffB6B6B6)) : Color(0xffB6B6B6);
  Color get cardLight => darkMode.value? invertLightness(Color(0xffeeeeee)) : Color(0xffeeeeee);

  Color get white => const Color(0xffffffff);
  Color get black => const Color(0xff000000);

  Color get colorHealthy => darkMode.value? darken(Color(0xff4CAF50), 0.1) : Color(0xff4CAF50);
  Color get colorNeedsWater => darkMode.value? darken(Color(0xffFFA726), 0.1) : Color(0xffFFA726);
  Color get colorOverdue => darkMode.value? darken(Color(0xffEF5350), 0.1) : Color(0xffEF5350);

  Color get sunday => darkMode.value? darken(Color(0xffdd4340), 0.1) : Color(0xffdd4340);

  Color get customReminder => darkMode.value? darken(Color(0xff4475c4), 0.1) : Color(0xff4475c4);
  Color get myGardenReminder => darkMode.value? darken(Color(0xff39b975), 0.1) : Color(0xff39b975);

  Color get cameraMaskBlack => Color.fromRGBO(0, 0, 0, 0.5);
}

ColorAccent colorAccent = ColorAccent();