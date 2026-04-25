import 'package:flutter/material.dart';

class UtilMediaQuery {
  double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getVerticalMedian(BuildContext context, double mainHeight, bool byTop) {
    double val = getScreenHeight(context);
    double tweak = byTop? -(mainHeight/2) : (mainHeight/2);
    return (val / 2) + tweak;
  }

  double getHorizontalMedian(BuildContext context, double mainWidth, bool byLeft) {
    double val = getScreenWidth(context);
    double tweak = byLeft? -(mainWidth/2) : (mainWidth/2);
    return (val / 2) + tweak;
  }
}

UtilMediaQuery utilMediaQuery = UtilMediaQuery();