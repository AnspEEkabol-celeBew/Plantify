import 'package:flutter/material.dart';

class UtilFlexBox extends StatelessWidget {
  final List<Widget> children;

  // Flex behavior
  final Axis direction;
  final MainAxisAlignment main;
  final CrossAxisAlignment cross;
  final double gap;
  final MainAxisSize mainSize;

  // Spacing
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // Container style
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final AlignmentGeometry? alignment;

  // Interaction
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const UtilFlexBox({
    super.key,
    required this.children,
    this.direction = Axis.vertical,
    this.main = MainAxisAlignment.start,
    this.cross = CrossAxisAlignment.start,
    this.gap = 0,
    this.mainSize = MainAxisSize.max,

    this.padding,
    this.margin,

    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.boxShadow,

    this.alignment,

    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 Add gap
    List<Widget> spacedChildren = [];

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);

      if (i != children.length - 1) {
        spacedChildren.add(
          SizedBox(
            width: direction == Axis.horizontal ? gap : 0,
            height: direction == Axis.vertical ? gap : 0,
          ),
        );
      }
    }

    Widget flex = Flex(
      direction: direction,
      mainAxisAlignment: main,
      crossAxisAlignment: cross,
      mainAxisSize: mainSize,
      children: spacedChildren,
    );

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: flex,
    );

    // 🔥 Make clickable (with ripple)
    if (onTap != null || onLongPress != null) {
      container = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          child: container,
        ),
      );
    }

    return container;
  }
}

class UtilGridBox extends StatelessWidget {
  final List<Widget> children;

  // Grid config
  final int columns;
  final double gapX;
  final double gapY;
  final double childAspectRatio;

  // Container props (like Div)
  final double? width;
  final double? height;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final Color? color;
  final Gradient? gradient;

  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final AlignmentGeometry? alignment;

  // Scroll
  final bool scrollable;

  // Interaction
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const UtilGridBox({
    super.key,
    required this.children,

    this.columns = 2,
    this.gapX = 0,
    this.gapY = 0,
    this.childAspectRatio = 1,

    this.width,
    this.height,

    this.margin,
    this.padding,

    this.color,
    this.gradient,

    this.borderRadius,
    this.border,
    this.boxShadow,

    this.alignment,

    this.scrollable = false,

    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    Widget grid = GridView.builder(
      shrinkWrap: !scrollable,
      physics: scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: children.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: gapX,
        mainAxisSpacing: gapY,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        return children[index];
      },
    );

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
      ),
      child: grid,
    );

    // 🔥 Clickable container
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