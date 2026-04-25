import 'package:flutter/material.dart';

import '../theme/fonts.dart';

class UtilInputBox extends StatefulWidget {
  final TextEditingController? controller;

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final Color? color;
  final Color? focusColor;
  final Color? disabledColor;

  final Gradient? gradient;
  final BorderRadius? borderRadius;

  final BoxBorder? border;
  final BoxBorder? focusBorder;
  final BoxBorder? disabledBorder;

  final List<BoxShadow>? boxShadow;

  final String? hint;

  final double? fontSize;
  final Color? textColor;
  final Fonts? fonts;

  final double? hintSize;
  final Color? hintColor;
  final Fonts? hintFonts;
  final TextAlign textAlign;
  final AlignmentGeometry? alignment;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool enabled;

  final ValueChanged<String>? onChanged;

  const UtilInputBox({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.margin,
    this.padding,

    this.color,
    this.focusColor,
    this.disabledColor,

    this.gradient,
    this.borderRadius,

    this.border,
    this.focusBorder,
    this.disabledBorder,

    this.boxShadow,

    this.hint,

    this.fontSize,
    this.textColor,

    this.fonts,

    this.hintSize,
    this.hintColor,
    this.hintFonts,

    this.textAlign = TextAlign.start,
    this.alignment,

    this.prefix,
    this.suffix,

    this.obscureText = false,
    this.keyboardType,
    this.enabled = true,

    this.onChanged,
  });

  @override
  State<UtilInputBox> createState() => _UtilInputBoxState();
}

class _UtilInputBoxState extends State<UtilInputBox> {
  late FocusNode _focusNode;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = !widget.enabled
        ? widget.disabledColor ?? widget.color
        : isFocused
            ? widget.focusColor ?? widget.color
            : widget.color;

    final currentBorder = !widget.enabled
        ? widget.disabledBorder ?? widget.border
        : isFocused
            ? widget.focusBorder ?? widget.border
            : widget.border;

    final decorationBox = BoxDecoration(
      color: widget.gradient == null ? currentColor : null,
      gradient: widget.gradient,
      borderRadius: widget.borderRadius,
      border: currentBorder,
      boxShadow: widget.boxShadow,
    );

    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
      alignment: widget.alignment,
      decoration: decorationBox,

      child: Row(
        children: [
          if (widget.prefix != null) ...[
            widget.prefix!,
            const SizedBox(width: 8),
          ],

          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              onChanged: widget.onChanged,
              textAlign: widget.textAlign,

              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.textColor,
                fontWeight: widget.fonts?.weight,
                fontStyle: widget.fonts?.style,
                fontFamily: widget.fonts?.fontFamily,
              ),

              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(
                  fontSize: widget.hintSize?? widget.fontSize,
                  color: widget.hintColor?? widget.textColor,
                  fontFamily: widget.hintFonts?.fontFamily?? widget.fonts?.fontFamily,
                  fontStyle: widget.hintFonts?.style?? widget.fonts?.style,
                  fontWeight: widget.hintFonts?.weight?? widget.fonts?.weight
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          if (widget.suffix != null) ...[
            const SizedBox(width: 8),
            widget.suffix!,
          ],
        ],
      ),
    );
  }
}