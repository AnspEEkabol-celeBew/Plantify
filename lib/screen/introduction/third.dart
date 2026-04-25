import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import 'assets.dart';

class ThirdIntro extends StatefulWidget {
  const ThirdIntro({super.key});

  @override
  State<ThirdIntro> createState() => _ThirdIntroState();
}

class _ThirdIntroState extends State<ThirdIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.primary,
      body: IntroductionPreset(
        context,
        title: "Grow Your Plant Knowledge",
        subtitle: "Save your plants, track their growth, and become a better plant parent.",
        index: 2,
      ),
    );
  }
}
