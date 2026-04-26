import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/authentication/login.dart';
import 'package:plantify/screen/authentication/register.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/image.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/navigation.dart';
import 'package:plantify/util/text.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      body: UtilFlexBox(
        direction: Axis.vertical,
        main: MainAxisAlignment.center,
        cross: CrossAxisAlignment.stretch,
        gap: 50,
        margin: EdgeInsets.all(30),
        children: [
          //header
          UtilFlexBox(
            cross: CrossAxisAlignment.center,
            gap: 5,
            children: [
              UtilFitImage(
                'assets/images/icons/img/plantify_icon.png',
                width: 200,
              ),
              UtilText(
                "Let's get started!",
                align: TextAlign.center,
                family: Fonts.defaultFontSemiBold,
                color: colorAccent.primaryText,
                size: 30,
              ),
              UtilText(
                "Let's jump right into your account",
                family: Fonts.defaultFontRegular,
                color: colorAccent.secondaryText,
                size: 20,
              ),
            ],
          ),

          UtilFlexBox(
            gap: 20,
            children: [
              //google
              UtilContainer(
                height: 60,
                width: double.maxFinite,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: colorAccent.cardDark, width: 1.3),
                alignment: Alignment.center,
                child: UtilText(
                  "Continue with Google",
                  prefix: UtilContainer(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 35,
                    width: 35,
                    child: SvgPicture.asset(
                      'assets/images/icons/svg/google.svg',
                    ),
                  ),
                  family: Fonts.defaultFontThin,
                  color: colorAccent.primaryText,
                  size: 18,
                ),
              ),

              UtilFlexBox(
                width: double.maxFinite,
                height: 25,
                direction: Axis.horizontal,
                cross: CrossAxisAlignment.center,
                gap: 8,
                children: [
                  Expanded(
                    child: UtilContainer(
                      height: 3,
                      borderRadius: BorderRadius.circular(10),
                      color: colorAccent.secondaryText,
                    ),
                  ),
                  UtilText(
                    "or",
                    family: Fonts.defaultFontThin,
                    color: colorAccent.secondaryText,
                  ),
                  Expanded(
                    child: UtilContainer(
                      height: 3,
                      borderRadius: BorderRadius.circular(10),
                      color: colorAccent.secondaryText,
                    ),
                  ),
                ],
              ),

              UtilContainer(
                onTap: () => navigateTo(
                  context,
                  animationType: NavAnimation.slideLeft,
                  duration: preferredAnimations.getDuration(),
                  replace: true,
                  page: LoginScreen(),
                ),
                height: 60,
                width: double.maxFinite,
                borderRadius: BorderRadius.circular(100),
                color: colorAccent.tertiary,
                alignment: Alignment.center,
                child: UtilText(
                  "Log In",
                  family: Fonts.defaultFontThin,
                  size: 18,
                  color: colorAccent.white,
                ),
              ),

              UtilContainer(
                onTap: () => navigateTo(
                  context,
                  animationType: NavAnimation.slideLeft,
                  duration: preferredAnimations.getDuration(),
                  replace: true,
                  page: RegisterScreen(),
                ),
                height: 60,
                width: double.maxFinite,
                borderRadius: BorderRadius.circular(100),
                color: colorAccent.secondary,
                alignment: Alignment.center,
                child: UtilText(
                  "Sign Up",
                  family: Fonts.defaultFontThin,
                  size: 18,
                  color: colorAccent.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
