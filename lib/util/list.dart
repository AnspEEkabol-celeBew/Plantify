import 'package:flutter/material.dart';

class UtilListTile extends StatelessWidget {
  // Content
  final Widget? title;
  final Widget? subtitle;

  final Widget? prefix;
  final Widget? suffix;

  // Layout
  final double gap;
  final double verticalGap;

  // Container style
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? color;
  final Gradient? gradient;

  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  // Interaction
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // Alignment
  final CrossAxisAlignment crossAlign;

  const UtilListTile({
    super.key,
    this.title,
    this.subtitle,
    this.prefix,
    this.suffix,

    this.gap = 12,
    this.verticalGap = 4,

    this.padding,
    this.margin,

    this.color,
    this.gradient,

    this.borderRadius,
    this.border,
    this.boxShadow,

    this.onTap,
    this.onLongPress,

    this.crossAlign = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      crossAxisAlignment: crossAlign,
      children: [
        // 🔹 Prefix
        if (prefix != null) ...[
          prefix!,
          SizedBox(width: gap),
        ],

        // 🔹 Text Section
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) title!,

              if (subtitle != null) ...[
                SizedBox(height: verticalGap),
                subtitle!,
              ],
            ],
          ),
        ),

        // 🔹 Suffix
        if (suffix != null) ...[
          SizedBox(width: gap),
          suffix!,
        ],
      ],
    );

    Widget container = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: content,
    );

    // 🔥 Clickable
    if (onTap != null || onLongPress != null) {
      container = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          onLongPress: onLongPress,
          child: container,
        ),
      );
    }

    return container;
  }
}