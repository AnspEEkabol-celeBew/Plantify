import 'package:flutter/material.dart';

class UtilSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  // Size
  final double width;
  final double height;

  // Spacing
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  // Colors
  final Color activeColor;
  final Color inactiveColor;
  final Color knobColor;

  // Style
  final BorderRadius borderRadius;
  final BoxBorder? border;

  // Animation
  final bool animation;

  // Optional widgets
  final Widget? activeChild;
  final Widget? inactiveChild;

  const UtilSwitch({
    super.key,
    required this.value,
    required this.onChanged,

    this.width = 50,
    this.height = 28,

    this.margin,
    this.padding,

    this.activeColor = Colors.green,
    this.inactiveColor = Colors.grey,
    this.knobColor = Colors.white,

    this.borderRadius = const BorderRadius.all(Radius.circular(30)),
    this.border,

    this.animation = true,

    this.activeChild,
    this.inactiveChild,
  });

  @override
  State<UtilSwitch> createState() => _UtilSwitchState();
}

class _UtilSwitchState extends State<UtilSwitch> {
  void toggle() {
    widget.onChanged?.call(!widget.value);
  }

  @override
  Widget build(BuildContext context) {
    double knobSize = widget.height - 6;

    return GestureDetector(
      onTap: toggle,
      child: Container(
        margin: widget.margin,
        padding: widget.padding,
        child: AnimatedContainer(
          duration: widget.animation
              ? const Duration(milliseconds: 200)
              : Duration.zero,

          width: widget.width,
          height: widget.height,

          decoration: BoxDecoration(
            color: widget.value
                ? widget.activeColor
                : widget.inactiveColor,
            borderRadius: widget.borderRadius,
            border: widget.border,
          ),

          child: Stack(
            children: [
              // Optional center content
              Center(
                child: widget.value
                    ? widget.activeChild
                    : widget.inactiveChild,
              ),

              // Knob
              AnimatedAlign(
                duration: widget.animation
                    ? const Duration(milliseconds: 200)
                    : Duration.zero,
                curve: Curves.easeInOut,
                alignment: widget.value
                    ? Alignment.centerRight
                    : Alignment.centerLeft,

                child: Container(
                  width: knobSize,
                  height: knobSize,
                  margin: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: widget.knobColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}