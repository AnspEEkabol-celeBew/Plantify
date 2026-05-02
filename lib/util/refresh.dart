import 'package:flutter/material.dart';

import '../theme/colors.dart';

class UtilRefresh extends StatefulWidget {
  const UtilRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.color,
    this.backgroundColor,
    this.displacement = 50.0,
  });

  /// Called when the user pulls to refresh — do your async reload here
  final Future<void> Function() onRefresh;

  /// The scrollable child (SingleChildScrollView, ListView, etc.)
  final Widget child;

  /// Spinner color — defaults to colorAccent.secondary
  final Color? color;

  /// Background of the refresh indicator circle
  final Color? backgroundColor;

  /// How far down the indicator sits before triggering
  final double displacement;

  @override
  State<UtilRefresh> createState() => _UtilRefreshState();
}

class _UtilRefreshState extends State<UtilRefresh>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    // Fade out
    await _fadeController.animateTo(0.0,
        duration: const Duration(milliseconds: 200));

    // Run the actual refresh
    await widget.onRefresh();

    // Fade back in
    await _fadeController.animateTo(1.0,
        duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      displacement: widget.displacement,
      color: widget.color ?? colorAccent.secondary,
      backgroundColor: widget.backgroundColor ?? colorAccent.cardLight,
      strokeWidth: 2.5,
      child: widget.child,
    );
  }
}