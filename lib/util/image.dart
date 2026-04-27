import 'dart:io';

import 'package:flutter/material.dart';

class UtilFitImage extends StatelessWidget {
  final String imagePath;

  // Size
  final double? width;
  final double? height;

  // Image fit
  final BoxFit fit;

  // Spacing
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding; // only for overlay

  // Container style
  final Color? color;
  final Gradient? gradient;

  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final AlignmentGeometry? alignment;

  // 🔥 Overlay (single + multiple)
  final Widget? child;
  final List<Widget>? children;

  // Interaction
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const UtilFitImage(
    this.imagePath, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,

    this.margin,
    this.padding,

    this.color,
    this.gradient,

    this.borderRadius,
    this.border,
    this.boxShadow,

    this.alignment,

    this.child,
    this.children,

    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // 🖼️ Base image
    Widget image = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      ),
    );

    // 🔥 Resolve overlay widgets
    List<Widget>? overlayWidgets;

    if (children != null && children!.isNotEmpty) {
      overlayWidgets = children;
    } else if (child != null) {
      overlayWidgets = [child!];
    }

    Widget content = image;

    if (overlayWidgets != null) {
      content = Stack(
        children: [
          Positioned.fill(child: image),

          Positioned.fill(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Stack(
                children: overlayWidgets,
              ),
            ),
          ),
        ],
      );
    }

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment,
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

class UtilFitImageFile extends StatelessWidget {
  final File imagePath;

  // Size
  final double? width;
  final double? height;
  final bool gaplessPlayback;

  // Image fit
  final BoxFit fit;

  // Spacing
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding; // only for overlay

  // Container style
  final Color? color;
  final Gradient? gradient;

  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final AlignmentGeometry? alignment;

  // 🔥 Overlay (single + multiple)
  final Widget? child;
  final List<Widget>? children;

  // Interaction
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const UtilFitImageFile(
    this.imagePath, {
    super.key,
    this.width,
    this.height,
    this.gaplessPlayback = false,
    this.fit = BoxFit.cover,

    this.margin,
    this.padding,

    this.color,
    this.gradient,

    this.borderRadius,
    this.border,
    this.boxShadow,

    this.alignment,

    this.child,
    this.children,

    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // 🖼️ Base image
    Widget image = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        imagePath,
        gaplessPlayback: gaplessPlayback,
        width: width,
        height: height,
        fit: fit,
      ),
    );

    // 🔥 Resolve overlay widgets
    List<Widget>? overlayWidgets;

    if (children != null && children!.isNotEmpty) {
      overlayWidgets = children;
    } else if (child != null) {
      overlayWidgets = [child!];
    }

    Widget content = image;

    if (overlayWidgets != null) {
      content = Stack(
        children: [
          Positioned.fill(child: image),

          Positioned.fill(
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: Stack(
                children: overlayWidgets,
              ),
            ),
          ),
        ],
      );
    }

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      alignment: alignment,
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