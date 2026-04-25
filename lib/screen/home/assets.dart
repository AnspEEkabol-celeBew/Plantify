import 'package:flutter/material.dart';
import 'package:plantify/screen/home/account.dart';
import 'package:plantify/screen/home/home.dart';
import 'package:plantify/screen/home/garden.dart';
import 'package:plantify/screen/home/reminder.dart';
import 'package:plantify/util/string.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/layout.dart';
import '../../util/text.dart';

Widget currentHomeScreenNavigation = HomeScreen();
String currentHomeScreenHeaderName = 'Plantify';

bool homeIsActive = true;
bool gardenIsActive = false;
bool reminderIsActive = false;
bool accountIsActive = false;

Map<String, Widget> homeScreenNavigation = {
  'home':HomeScreen(),
  'garden':GardenScreen(),
  'reminder':ReminderScreen(),
  'account':AccountScreen()
};

void toggleHomeNavigation(String screen) {
  if (homeScreenNavigation[screen] == currentHomeScreenNavigation) return;

  currentHomeScreenNavigation = homeScreenNavigation[screen]!;
  currentHomeScreenHeaderName = toUpperFirst(screen == 'home'? 'plantify':screen);

  homeIsActive = false;
  gardenIsActive = false;
  reminderIsActive = false;
  accountIsActive = false;

  switch (screen) {
    case 'home':
      homeIsActive = true;
    case 'garden':
      gardenIsActive = true;
    case 'reminder':
      reminderIsActive = true;
    case 'account':
      accountIsActive = true;
  }
}

class NavBarList extends StatelessWidget {
  const NavBarList({
    super.key,
    required this.icon,
    required this.name,
    required this.isActive,
    required this.onTap
  });

  final IconData icon;
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      borderRadius: BorderRadius.circular(100),
      onTap: onTap,
      width: 70,
      cross: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: isActive? colorAccent.secondary : colorAccent.cardDark, size: 30),
        UtilText(
          name,
          family: Fonts.defaultFontRegular,
          color: isActive? colorAccent.secondary : colorAccent.cardDark,
          size: 12,
        )
      ],
    );
  }
}
