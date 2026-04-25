import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import 'assets.dart';

class SecondIntro extends StatefulWidget {
  const SecondIntro({super.key});

  @override
  State<SecondIntro> createState() => _SecondIntroState();
}

class _SecondIntroState extends State<SecondIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.primary,
      body: IntroductionPreset(
        context,
        title: "Scan & Care",
        subtitle: "Scan plants to learn about them and get reminders for watering and care.",
        index: 1,
      ),
    );
  }
}
