import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import 'assets.dart';

class FirstIntro extends StatefulWidget {
  const FirstIntro({super.key});

  @override
  State<FirstIntro> createState() => _FirstIntroState();
}

class _FirstIntroState extends State<FirstIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.primary,
      body: IntroductionPreset(
        context,
        title: "Welcome to Plantify",
        subtitle: "Identify plants around you instantly and discover how to care for them.",
        index: 0
      ),
    );
  }
}