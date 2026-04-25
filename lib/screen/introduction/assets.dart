import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/authentication/get_started.dart';
import 'package:plantify/screen/introduction/second.dart';
import 'package:plantify/screen/introduction/third.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/util/navigation.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/container.dart';
import '../../util/image.dart';
import '../../util/layout.dart';
import '../../util/mediaquery.dart';
import '../../util/text.dart';

class IntroductionPreset extends StatelessWidget {
  const IntroductionPreset(
    BuildContext context, {
    super.key,
    required this.title,
    required this.subtitle,
    required this.index,
  });

  final String title;
  final String subtitle;
  final int index;

  StatefulWidget getNext(int index) {
    switch (index) {
      case 0:
        return SecondIntro();
      case 1:
        return ThirdIntro();
      case 2:
        return GetStartedScreen();
    }
    return GetStartedScreen();
  }

  void skipIntroduction() {
    savePreferencesOnBool('doneIntro', true);
    preferredLoginUser.doneIntro = true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 55,
          left: utilMediaQuery.getHorizontalMedian(context, 350, true),
          child: UtilFitImage(
            'assets/images/misc/intro_image${index + 1}.png',
            width: 350,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 0, sigmaY: 13),
            child: ClipPath(
              clipper: CurvedClipper(),
              clipBehavior: Clip.antiAlias, // Makes the curve smooth
              child: Container(
                width: utilMediaQuery.getScreenWidth(context),
                height: 420,
                color: Color.fromRGBO(0, 0, 0, 0.5),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: ClipPath(
            clipper: CurvedClipper(),
            clipBehavior: Clip.antiAlias, // Makes the curve smooth
            child: UtilContainer(
              width: utilMediaQuery.getScreenWidth(context),
              height: 420,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: UtilFlexBox(
                direction: Axis.vertical,
                cross: CrossAxisAlignment.center,
                padding: EdgeInsets.symmetric(horizontal: 30),
                gap: 10,
                children: [
                  SizedBox(height: 100),
                  UtilText(
                    title,
                    size: 27,
                    color: colorAccent.primaryText,
                    family: Fonts.defaultFontSemiBold,
                  ),
                  UtilText(
                    subtitle,
                    size: 17,
                    align: TextAlign.center,
                    color: colorAccent.primaryText,
                    family: Fonts.defaultFontRegular,
                  ),
                  UtilFlexBox(
                    main: MainAxisAlignment.center,
                    margin: EdgeInsets.symmetric(vertical: 18),
                    direction: Axis.horizontal,
                    gap: 15,
                    children: [
                      UtilContainer(
                        height: 10,
                        width: 10,
                        borderRadius: BorderRadius.circular(100),
                        color: index == 0
                            ? colorAccent.secondary
                            : colorAccent.cardLight,
                      ),
                      UtilContainer(
                        height: 10,
                        width: 10,
                        borderRadius: BorderRadius.circular(100),
                        color: index == 1
                            ? colorAccent.secondary
                            : colorAccent.cardLight,
                      ),
                      UtilContainer(
                        height: 10,
                        width: 10,
                        borderRadius: BorderRadius.circular(100),
                        color: index == 2
                            ? colorAccent.secondary
                            : colorAccent.cardLight,
                      ),
                    ],
                  ),
                  UtilFlexBox(
                    direction: Axis.horizontal,
                    gap: 20,
                    children: [
                      if (index != 2)
                        Expanded(
                          child: UtilContainer(
                            onTap: () {
                              skipIntroduction();
                              navigateTo(
                                context,
                                animationType: NavAnimation.pushLeft,
                                duration: preferredAnimations.getDuration(),
                                page: GetStartedScreen(),
                                replace: true,
                              );
                            },
                            height: 60,
                            color: colorAccent.cardDark,
                            borderRadius: BorderRadius.circular(100),
                            alignment: Alignment.center,
                            child: UtilText(
                              "Skip",
                              size: 20,
                              align: TextAlign.center,
                              color: colorAccent.white,
                              family: Fonts.defaultFontRegular,
                            ),
                          ),
                        ),
                      Expanded(
                        child: UtilContainer(
                          onTap: () {
                            if (index == 2) {
                              skipIntroduction();
                            }
                            navigateTo(
                              context,
                              animationType: NavAnimation.pushLeft,
                              duration: preferredAnimations.getDuration(),
                              replace: true,
                              page: getNext(index),
                            );
                          },
                          height: 60,
                          color: colorAccent.secondary,
                          borderRadius: BorderRadius.circular(100),
                          alignment: Alignment.center,
                          child: UtilText(
                            "Next",
                            size: 20,
                            align: TextAlign.center,
                            color: colorAccent.white,
                            family: Fonts.defaultFontRegular,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at the top left
    path.lineTo(0, 0);

    // Change 0.2 to a higher number (like 0.5) for a deeper scoop
    var controlPoint = Offset(size.width / 2, size.height * 0.3);

    var endPoint = Offset(size.width, 0);

    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      endPoint.dx,
      endPoint.dy,
    );

    // Complete the rest of the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
