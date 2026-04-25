import 'package:flutter/material.dart';

enum NavAnimation {
  slideLeft,
  slideRight,
  slideUp,
  slideDown,
  fade,
  zoomIn,
  zoomOut,
  slideFade,
  zoomFade,
  slideZoomFade,
  pushLeft,
  pushRight,
  pushUp,
  pushDown,
  pushFade,
}

Future<void> navigateTo(
  BuildContext context, {
  required NavAnimation animationType,
  required int duration,
  required Widget page,
  Curve curve = Curves.easeInOut,
  bool replace = false, // 🔥 NEW
}) {
  final route = PageRouteBuilder(
    transitionDuration: Duration(milliseconds: duration),
    reverseTransitionDuration: Duration(milliseconds: duration),

    pageBuilder: (_, animation, secondaryAnimation) => page,

    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: curve,
        reverseCurve: curve,
      );

      final curvedSecondary = CurvedAnimation(
        parent: secondaryAnimation,
        curve: curve,
        reverseCurve: curve,
      );

      // ---------------- NORMAL SLIDE ----------------
      final slideLeft = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curved);

      final slideRight = Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(curved);

      final slideUp = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(curved);

      final slideDown = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(curved);

      // ---------------- PUSH STYLE (DUAL ANIMATION) ----------------

      Offset pushOffsetForward(Offset begin) =>
          Tween<Offset>(begin: begin, end: Offset.zero).evaluate(curved);

      Offset pushOffsetBack(Offset end) =>
          Tween<Offset>(begin: Offset.zero, end: end)
              .evaluate(curvedSecondary);

      // ---------------- ZOOM ----------------
      final zoomIn = Tween<double>(begin: 0.8, end: 1.0).animate(curved);
      final zoomOut = Tween<double>(begin: 1.2, end: 1.0).animate(curved);

      switch (animationType) {
        // ===== NORMAL =====
        case NavAnimation.slideLeft:
          return SlideTransition(position: slideLeft, child: child);

        case NavAnimation.slideRight:
          return SlideTransition(position: slideRight, child: child);

        case NavAnimation.slideUp:
          return SlideTransition(position: slideUp, child: child);

        case NavAnimation.slideDown:
          return SlideTransition(position: slideDown, child: child);

        case NavAnimation.fade:
          return FadeTransition(opacity: curved, child: child);

        case NavAnimation.zoomIn:
          return ScaleTransition(scale: zoomIn, child: child);

        case NavAnimation.zoomOut:
          return ScaleTransition(scale: zoomOut, child: child);

        case NavAnimation.slideFade:
          return SlideTransition(
            position: slideLeft,
            child: FadeTransition(opacity: curved, child: child),
          );

        case NavAnimation.zoomFade:
          return ScaleTransition(
            scale: zoomIn,
            child: FadeTransition(opacity: curved, child: child),
          );

        case NavAnimation.slideZoomFade:
          return SlideTransition(
            position: slideUp,
            child: ScaleTransition(
              scale: zoomIn,
              child: FadeTransition(opacity: curved, child: child),
            ),
          );

        // ===== PUSH STYLE =====

        case NavAnimation.pushLeft:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(-1, 0),
              ).animate(curvedSecondary),
              child: child,
            ),
          );

        case NavAnimation.pushRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(curved),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(1, 0),
              ).animate(curvedSecondary),
              child: child,
            ),
          );

        case NavAnimation.pushUp:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curved),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, -1),
              ).animate(curvedSecondary),
              child: child,
            ),
          );

        case NavAnimation.pushDown:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -1),
              end: Offset.zero,
            ).animate(curved),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0, 1),
              ).animate(curvedSecondary),
              child: child,
            ),
          );

        case NavAnimation.pushFade:
          return FadeTransition(
            opacity: curved,
            child: FadeTransition(
              opacity: Tween<double>(begin: 1, end: 0).animate(curvedSecondary),
              child: child,
            ),
          );
      }
    },
  );

  // 🔥 PUSH vs REPLACE
  if (replace) {
    return Navigator.pushReplacement(context, route);
  } else {
    return Navigator.push(context, route);
  }
}