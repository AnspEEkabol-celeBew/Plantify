import 'package:flutter/material.dart';

import '../../main.dart';
import '../../storage/preferences.dart';
import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../../util/appbar.dart';
import '../../util/components.dart';
import '../../util/container.dart';
import '../../util/layout.dart';
import '../../util/list.dart';
import '../../util/navigation.dart';
import '../../util/text.dart';
import '../home/main.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool skipSplash = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      appBar: subAppbarModifyLeading(
        title: "Ease & Accessibility",
        leading: UtilContainer(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: UtilFlexBox(
          direction: Axis.vertical,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          gap: 10,
          children: [
            UtilListTile(
              title: UtilText(
                "Skip Splash Screen",
                size: 20,
                family: Fonts.defaultFontRegular,
                color: colorAccent.primaryText,
              ),
              suffix: UtilSwitch(
                value: preferredSplashScreen.skipVideo,
                activeColor: colorAccent.primary,
                inactiveColor: colorAccent.cardDark,
                knobColor: colorAccent.white,
                onChanged: (val) {
                  setState(() {
                    preferredSplashScreen.skipVideo = !preferredSplashScreen.skipVideo;
                    savePreferencesOnBool('skipSplash', preferredSplashScreen.skipVideo);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
