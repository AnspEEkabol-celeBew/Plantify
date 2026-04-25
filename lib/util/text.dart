import 'package:flutter/material.dart';
import 'package:plantify/theme/fonts.dart';

class UtilText extends StatelessWidget {
  final String text;

  // Text style
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final Fonts? family;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;
  final List<Shadow>? shadow;

  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  // 🔥 Prefix / Suffix
  final Widget? prefix;
  final Widget? suffix;
  final double gap;

  // 🔥 Optional click
  final VoidCallback? onTap;

  const UtilText(
    this.text, {
    super.key,
    this.size,
    this.color,
    this.weight,
    this.family,
    this.letterSpacing,
    this.height,
    this.decoration,
    this.shadow,
    this.align,
    this.maxLines,
    this.overflow,

    this.prefix,
    this.suffix,
    this.gap = 6,

    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget textWidget = Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: family?.fontFamily,
        fontSize: size,
        color: color,
        fontWeight: weight ?? family?.weight,
        fontStyle: family?.style,
        letterSpacing: letterSpacing,
        height: height,
        decoration: decoration,
        shadows: shadow,
      ),
    );

    // 🔥 If no prefix/suffix → return plain text
    if (prefix == null && suffix == null) {
      if (onTap != null) {
        return GestureDetector(
          onTap: onTap,
          child: textWidget,
        );
      }
      return textWidget;
    }

    Widget row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefix != null) ...[
          prefix!,
          SizedBox(width: gap),
        ],

        Flexible(child: textWidget),

        if (suffix != null) ...[
          SizedBox(width: gap),
          suffix!,
        ],
      ],
    );

    // 🔥 Clickable
    if (onTap != null) {
      row = GestureDetector(
        onTap: onTap,
        child: row,
      );
    }

    return row;
  }
}