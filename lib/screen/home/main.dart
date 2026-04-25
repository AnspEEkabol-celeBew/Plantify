import 'package:flutter/material.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/camera/camera.dart';
import 'package:plantify/screen/home/assets.dart';
import 'package:plantify/storage/getter.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/navigation.dart';

import '../../util/appbar.dart';

double bottomSpacing = 150;

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      appBar: homeAppbar(title: currentHomeScreenHeaderName),
      body: UtilFlexBox(
        children: [
          Expanded(child: currentHomeScreenNavigation),
          UtilFlexBox(
            direction: Axis.horizontal,
            main: MainAxisAlignment.spaceEvenly,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            height: 130,
            width: MediaQuery.of(context).size.width,
            color: colorAccent.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            children: [
              NavBarList(
                icon: Icons.person,
                name: "Home",
                isActive: homeIsActive,
                onTap: () {
                  setState(() {
                    toggleHomeNavigation('home');
                  });
                },
              ),
              NavBarList(
                icon: Icons.local_florist_rounded,
                name: "Garden",
                isActive: gardenIsActive,
                onTap: () {
                  setState(() {
                    toggleHomeNavigation('garden');
                  });
                },
              ),
              UtilContainer(
                width: 80,
                height: 80,
                borderRadius: BorderRadius.circular(100),
                color: colorAccent.primary,
                border: Border.all(color: colorAccent.secondary),
                onTap: () => navigateTo(
                  context,
                  animationType: NavAnimation.zoomFade,
                  duration: preferredAnimations.getDuration(),
                  page: CameraScreen(),
                  curve: Cubic(0,0,0,1)
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: colorAccent.white,
                  size: 35,
                ),
              ),
              NavBarList(
                icon: Icons.calendar_month_rounded,
                name: "Reminder",
                isActive: reminderIsActive,
                onTap: () {
                  setState(() {
                    toggleHomeNavigation('reminder');
                  });
                },
              ),
              NavBarList(
                icon: Icons.person,
                name: "Account",
                isActive: accountIsActive,
                onTap: () {
                  setState(() {
                    toggleHomeNavigation('account');
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
