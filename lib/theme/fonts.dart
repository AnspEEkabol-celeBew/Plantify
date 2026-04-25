import 'package:flutter/material.dart';

enum Fonts{
  defaultFontRegular(fontFamily: "Palanquin",weight: null,style: null),
  defaultFontBold(fontFamily: "Palanquin",weight: FontWeight.w900,style: null),
  defaultFontSemiBold(fontFamily: "Palanquin",weight: FontWeight.w800,style: null),
  defaultFontMedium(fontFamily: "Palanquin",weight: FontWeight.w700,style: null),
  defaultFontLight(fontFamily: "Palanquin",weight: FontWeight.w600,style: null),
  defaultFontExtraLight(fontFamily: "Palanquin",weight: FontWeight.w500,style: null),
  defaultFontThin(fontFamily: "Palanquin",weight: FontWeight.w400,style: null),

  palanquinRegular(fontFamily: "Palanquin",weight: null,style: null),
  palanquinBold(fontFamily: "Palanquin",weight: FontWeight.w900,style: null),
  palanquinSemiBold(fontFamily: "Palanquin",weight: FontWeight.w800,style: null),
  palanquinMedium(fontFamily: "Palanquin",weight: FontWeight.w700,style: null),
  palanquinLight(fontFamily: "Palanquin",weight: FontWeight.w600,style: null),
  palanquinExtraLight(fontFamily: "Palanquin",weight: FontWeight.w500,style: null),
  palanquinThin(fontFamily: "Palanquin",weight: FontWeight.w400,style: null);

  final String fontFamily;
  final FontWeight? weight;
  final FontStyle? style;

  const Fonts({
    required this.fontFamily,
    this.weight,
    this.style
  });
}