import 'package:flutter/material.dart';

/// 🔥 ITEM MODEL (GENERIC + CUSTOM CHILD)
class UtilDropdownItem<T> {
  final String? label;
  final T value;

  final Widget? child; // custom UI
  final TextStyle? style;
  final Color? color;

  const UtilDropdownItem({
    this.label,
    required this.value,
    this.child,
    this.style,
    this.color,
  });
}

/// 🔥 CONTROLLER
class UtilDropdownController<T> extends ValueNotifier<T?> {
  UtilDropdownController(super.value);

  void setValue(T value) {
    this.value = value;
  }
}

/// 🔥 MAIN DROPDOWN
class UtilDropdown<T> extends StatefulWidget {
  final List<UtilDropdownItem<T>> items;

  final UtilDropdownController<T>? controller;
  final T? value;
  final ValueChanged<T>? onChanged;

  // Style (Div-like)
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final Color? color;
  final Gradient? gradient;

  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;

  final double? width;

  // Text style (default)
  final TextStyle? textStyle;

  // Prefix / Suffix
  final Widget? prefix;
  final Widget? suffix;

  const UtilDropdown({
    super.key,
    required this.items,
    this.controller,
    this.value,
    this.onChanged,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.width,
    this.textStyle,
    this.prefix,
    this.suffix,
  });

  @override
  State<UtilDropdown<T>> createState() => _UtilDropdownState<T>();
}

class _UtilDropdownState<T> extends State<UtilDropdown<T>> {
  OverlayEntry? overlayEntry;
  bool isOpen = false;

  T? get currentValue => widget.controller?.value ?? widget.value;

  void toggleDropdown() {
    if (isOpen) {
      closeDropdown();
    } else {
      openDropdown();
    }
  }

  void openDropdown() {
    overlayEntry = _createOverlay();
    Overlay.of(context).insert(overlayEntry!);
    setState(() => isOpen = true);
  }

  void closeDropdown() {
    overlayEntry?.remove();
    overlayEntry = null;
    setState(() => isOpen = false);
  }

  void selectItem(UtilDropdownItem<T> item) {
    if (widget.controller != null) {
      widget.controller!.setValue(item.value);
    } else {
      widget.onChanged?.call(item.value);
    }
    closeDropdown();
  }

  OverlayEntry _createOverlay() {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: position.dx,
          top: position.dy + box.size.height,
          width: widget.width ?? box.size.width,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 200),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.95 + (0.05 * value),
                    alignment: Alignment.topCenter,
                    child: child,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: widget.color ?? Colors.white,
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12),
                  boxShadow: widget.boxShadow ??
                      [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.items.map((item) {
                    final isSelected = item.value == currentValue;

                    return InkWell(
                      onTap: () => selectItem(item),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        color: isSelected
                            ? Colors.black.withOpacity(0.05)
                            : null,
                        child: item.child ??
                            Text(
                              item.label ?? "",
                              style: item.style ??
                                  widget.textStyle ??
                                  const TextStyle(),
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = widget.items.firstWhere(
      (e) => e.value == currentValue,
      orElse: () => widget.items.first,
    );

    Widget display = selectedItem.child ??
        Text(
          selectedItem.label ?? "",
          style: widget.textStyle,
        );

    Widget content = Row(
      children: [
        if (widget.prefix != null) ...[
          widget.prefix!,
          const SizedBox(width: 8),
        ],
        Expanded(child: display),
        if (widget.suffix != null) ...[
          const SizedBox(width: 8),
          widget.suffix!,
        ] else
          const Icon(Icons.arrow_drop_down),
      ],
    );

    return GestureDetector(
      onTap: toggleDropdown,
      child: Container(
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: widget.gradient == null ? widget.color : null,
          gradient: widget.gradient,
          borderRadius: widget.borderRadius,
          border: widget.border,
          boxShadow: widget.boxShadow,
        ),
        child: content,
      ),
    );
  }
}