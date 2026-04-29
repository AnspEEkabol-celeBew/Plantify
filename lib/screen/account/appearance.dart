import 'package:flutter/material.dart';
import 'package:plantify/main.dart';
import 'package:plantify/screen/home/main.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/appbar.dart';
import 'package:plantify/util/components.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/miscellaneous.dart';
import 'package:plantify/util/navigation.dart';

import '../../theme/fonts.dart';
import '../../util/list.dart';
import '../../util/snackbar.dart';
import '../../util/text.dart';

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  @override
  Widget build(BuildContext context) {
    return ReactiveBuilder(
      builder: () => Scaffold(
        backgroundColor: colorAccent.background,
        appBar: subAppbarModifyLeading(
          title: "Appearance",
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
                  "Dark Mode",
                  size: 20,
                  family: Fonts.defaultFontRegular,
                  color: colorAccent.primaryText,
                ),
                suffix: UtilSwitch(
                  value: darkMode.value,
                  activeColor: colorAccent.primary,
                  inactiveColor: colorAccent.cardDark,
                  knobColor: colorAccent.white,
                  onChanged: (val) {
                    darkMode.value = val;
                    savePreferencesOnBool("isDarkMode", darkMode.value);
                    _showSnackBar("Restart to take changes");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    showUtilSnackBar(
      context,
      duration: 2000,
      animationDuration: 200,
      color: colorAccent.cardDark,
      boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 5),
      ],
      width: 300,
      content: UtilText(
        message,
        align: TextAlign.center,
        family: Fonts.defaultFontRegular,
        color: colorAccent.primaryText,
        size: 15,
      ),
    );
  }
}
