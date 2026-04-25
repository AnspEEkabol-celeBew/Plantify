import 'package:flutter/material.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/account/accessibility.dart';
import 'package:plantify/screen/account/appearance.dart';
import 'package:plantify/screen/authentication/get_started.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/util/image.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/miscellaneous.dart';
import 'package:plantify/util/navigation.dart';
import 'package:plantify/util/text.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    setState(() {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final user = await loadPreferencesOnMap('userData', {});
    setState(() {
      _userData = user;
    });
  }



  @override
  Widget build(BuildContext context) {
    final String username  = _userData['username'] as String? ?? '';
    final String email = _userData['email'] as String? ?? '';
    final int age = _userData['age'] as int? ?? 0;

    return ReactiveBuilder(
      builder: () => SingleChildScrollView(
        child: UtilFlexBox(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          gap: 10,
          children: [
            //account header
            UtilFlexBox(
              cross: CrossAxisAlignment.center,
              direction: Axis.horizontal,
              width: double.maxFinite,
              gap: 10,
              height: 100,
              children: [
                UtilFitImage(
                  'assets/images/misc/profile_sample.jpeg',
                  borderRadius: BorderRadius.circular(500),
                  height: 80,
                  width: 80,
                ),
                Expanded(
                  child: UtilFlexBox(
                    direction: Axis.vertical,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    gap: 2,
                    children: [
                      UtilText(
                        username,
                        family: Fonts.defaultFontSemiBold,
                        color: colorAccent.primaryText,
                        size: 28,
                      ),
                      UtilText(
                        email,
                        family: Fonts.defaultFontThin,
                        color: colorAccent.secondaryText,
                        size: 12,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.navigate_next_rounded,
                  size: 50,
                  color: colorAccent.primaryText,
                ),
              ],
            ),

            //settings list
            UtilFlexBox(
              margin: EdgeInsets.symmetric(vertical: 10),
              direction: Axis.vertical,
              gap: 10,
              children: [
                SettingList(
                  icon: Icons.notifications_none_rounded,
                  name: 'Notifications',
                ),
                SettingList(
                  icon: Icons.bookmark_border_rounded,
                  name: 'Bookmarks',
                ),
                SettingList(
                  icon: Icons.lock_outline_rounded,
                  name: 'Security & Privacy',
                ),
                SettingList(
                  icon: Icons.color_lens_outlined,
                  name: 'Appearance & Personalization',
                  onTap: () => navigateTo(
                    context,
                    animationType: NavAnimation.slideLeft,
                    duration: preferredAnimations.getDuration(),
                    page: AppearanceScreen(),
                  ),
                ),
                SettingList(
                  icon: Icons.accessibility_new_outlined,
                  name: 'Ease & Accessibility',
                  onTap: () => navigateTo(
                    context,
                    animationType: NavAnimation.slideLeft,
                    duration: preferredAnimations.getDuration(),
                    page: AccessibilityScreen(),
                  ),
                ),
                SettingList(
                  icon: Icons.help_outline_rounded,
                  name: 'Help & Support',
                ),
                SettingList(
                  icon: Icons.logout,
                  name: 'Logout',
                  color: colorAccent.error,
                  onTap: () {
                    deletePreferences('userData');
                    savePreferencesOnBool('isLogin', false);

                    navigateTo(
                      context,
                      animationType: NavAnimation.slideLeft,
                      duration: preferredAnimations.getDuration(),
                      page: GetStartedScreen(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingList extends StatelessWidget {
  const SettingList({
    super.key,
    required this.icon,
    required this.name,
    this.color,
    this.onTap,
  });

  final String name;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return UtilFlexBox(
      direction: Axis.horizontal,
      onTap: onTap,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      gap: 10,
      cross: CrossAxisAlignment.center,
      children: [
        Icon(
          icon as IconData?,
          size: 30,
          color: color ?? colorAccent.primaryText,
        ),
        Expanded(
          child: UtilText(
            name,
            size: 20,
            family: Fonts.defaultFontRegular,
            color: color ?? colorAccent.primaryText,
          ),
        ),
      ],
    );
  }
}
