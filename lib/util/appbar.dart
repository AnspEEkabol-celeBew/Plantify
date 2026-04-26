import 'package:flutter/material.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/util/text.dart';

import '../theme/fonts.dart';
import 'container.dart';
import 'layout.dart';

AppBar homeAppbar({required String title}) {
  return AppBar(
    backgroundColor: colorAccent.background,
    automaticallyImplyLeading: false,
    title: UtilFlexBox(
      gap: 10,
      cross: CrossAxisAlignment.center,
      direction: Axis.horizontal,
      children: [
        UtilContainer(
          alignment: Alignment.center,
          width: 50,
          height: 50,
          child: Image.asset('assets/images/icons/img/plantify_icon.png'),
        ),
        Expanded(
          child: UtilContainer(
            child: UtilText(title, size: 28, family: Fonts.defaultFontBold, color: colorAccent.primaryText),
          ),
        ),
        // UtilContainer(
        //   width: 50,
        //   height: 50,
        //   borderRadius: BorderRadius.circular(UtilContainer.intCircular),
        //   child: Icon(Icons.notifications_active_outlined, size: 32, color: colorAccent.primaryText),
        //   onTap: () => debugPrint("notif"),
        // ),
        // UtilContainer(
        //   width: 50,
        //   height: 50,
        //   borderRadius: BorderRadius.circular(UtilContainer.intCircular),
        //   child: Icon(Icons.search, size: 32, color: colorAccent.primaryText),
        //   onTap: () => debugPrint("search"),
        // ),
      ],
    ),
  );
}

AppBar subAppbar({required String title, List<Widget> addonChildren = const []}) {
  return AppBar(
    backgroundColor: colorAccent.background,
    iconTheme: IconThemeData(
      color: colorAccent.primaryText
    ),
    title: UtilFlexBox(
      gap: 10,
      cross: CrossAxisAlignment.center,
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: UtilContainer(
            child: UtilText(title, size: 28, family: Fonts.defaultFontMedium, color: colorAccent.primaryText),
          ),
        ),
      ] + addonChildren,
    ),
  );
}

AppBar subAppbarModifyLeading({required String title, required Widget leading, List<Widget> addonChildren = const []}) {
  return AppBar(
    backgroundColor: colorAccent.background,
    iconTheme: IconThemeData(
      color: colorAccent.primaryText
    ),
    leading: leading,
    title: UtilFlexBox(
      gap: 10,
      cross: CrossAxisAlignment.center,
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          child: UtilContainer(
            child: UtilText(title, size: 28, family: Fonts.defaultFontMedium, color: colorAccent.primaryText),
          ),
        ),
      ] + addonChildren,
    ),
  );
}