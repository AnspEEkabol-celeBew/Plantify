import 'package:flutter/material.dart';

enum SnackBarAnimation {
  slideUp,
  slideDown,
  slideLeft,
  slideRight,
  fade,
  scale,
  slideFade,
  zoomFade,
}

void showUtilSnackBar(
  BuildContext context, {
  required Widget content,

  // timing
  int duration = 3000,
  int animationDuration = 300, // 🔥 NEW

  // layout
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  double? width,

  // style
  Color? color,
  Gradient? gradient,
  BorderRadius? borderRadius,
  BoxBorder? border,
  List<BoxShadow>? boxShadow,

  // position
  bool top = false,
  Offset? offset, // 🔥 NEW

  // animation
  SnackBarAnimation animation = SnackBarAnimation.slideUp,
  Curve curve = Curves.easeOut, // 🔥 NEW
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) {
      return _UtilSnackbarWidget(
        content: content,
        duration: duration,
        animationDuration: animationDuration,
        margin: margin,
        padding: padding,
        width: width,
        color: color,
        gradient: gradient,
        borderRadius: borderRadius,
        border: border,
        boxShadow: boxShadow,
        top: top,
        offset: offset,
        animation: animation,
        curve: curve,
        onDismissed: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}

class _UtilSnackbarWidget extends StatefulWidget {
  final Widget content;

  final int duration;
  final int animationDuration;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double? width;

  final Color? color;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final bool top;
  final Offset? offset;

  final SnackBarAnimation animation;
  final Curve curve;

  final VoidCallback onDismissed;

  const _UtilSnackbarWidget({
    required this.content,
    required this.duration,
    required this.animationDuration,
    this.margin,
    this.padding,
    this.width,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.boxShadow,
    required this.top,
    this.offset,
    required this.animation,
    required this.curve,
    required this.onDismissed,
  });

  @override
  State<_UtilSnackbarWidget> createState() => _UtilSnackbarWidgetState();
}

class _UtilSnackbarWidgetState extends State<_UtilSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );

    final curved = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
    );

    fade = Tween(begin: 0.0, end: 1.0).animate(curved);
    scale = Tween(begin: 0.8, end: 1.0).animate(curved);

    // 🔥 Dynamic slide direction
    Offset beginOffset;

    switch (widget.animation) {
      case SnackBarAnimation.slideUp:
        beginOffset = const Offset(0, 1);
        break;
      case SnackBarAnimation.slideDown:
        beginOffset = const Offset(0, -1);
        break;
      case SnackBarAnimation.slideLeft:
        beginOffset = const Offset(-1, 0);
        break;
      case SnackBarAnimation.slideRight:
        beginOffset = const Offset(1, 0);
        break;
      default:
        beginOffset = const Offset(0, 1);
    }

    slide = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(curved);

    controller.forward();

    Future.delayed(Duration(milliseconds: widget.duration), () async {
      await controller.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildAnimation(Widget child) {
    switch (widget.animation) {
      case SnackBarAnimation.fade:
        return FadeTransition(opacity: fade, child: child);

      case SnackBarAnimation.scale:
        return ScaleTransition(scale: scale, child: child);

      case SnackBarAnimation.slideFade:
        return SlideTransition(
          position: slide,
          child: FadeTransition(opacity: fade, child: child),
        );

      case SnackBarAnimation.zoomFade:
        return ScaleTransition(
          scale: scale,
          child: FadeTransition(opacity: fade, child: child),
        );

      case SnackBarAnimation.slideUp:
      case SnackBarAnimation.slideDown:
      case SnackBarAnimation.slideLeft:
      case SnackBarAnimation.slideRight:
        return SlideTransition(position: slide, child: child);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget box = Container(
      width: widget.width,
      margin: widget.margin ?? const EdgeInsets.all(16),
      padding: widget.padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.gradient == null ? widget.color ?? Colors.black : null,
        gradient: widget.gradient,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
        border: widget.border,
        boxShadow: widget.boxShadow,
      ),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: widget.content,
      ),
    );

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Align(
          alignment: widget.offset != null
              ? Alignment(widget.offset!.dx, widget.offset!.dy)
              : (widget.top ? Alignment.topCenter : Alignment.bottomCenter),
          child: buildAnimation(box),
        ),
      ),
    );
  }
}