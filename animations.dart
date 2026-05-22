// lib/utils/animations.dart

import 'package:flutter/material.dart';

class AnimationUtils {
  // Standard animation duration (300ms) - smooth but snappy
  static const Duration standardDuration = Duration(milliseconds: 300);
  
  // Long animation duration (500ms) - used for page transitions
  static const Duration longDuration = Duration(milliseconds: 500);
  
  // Short animation duration (150ms) - subtle feedback
  static const Duration shortDuration = Duration(milliseconds: 150);

  // Standard curve for smooth animations
  static const Curve standardCurve = Curves.easeInOutCubic;
  
  // Entrance curve (slightly bouncy)
  static const Curve entranceCurve = Curves.easeOut;
  
  // Exit curve
  static const Curve exitCurve = Curves.easeIn;

  // Create a fade transition
  static PageRoute<T> fadeTransition<T>({
    required Widget page,
    required String name,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: name),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: longDuration,
      reverseTransitionDuration: longDuration,
    );
  }

  // Create a slide transition from right
  static PageRoute<T> slideTransition<T>({
    required Widget page,
    required String name,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: name),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: longDuration,
      reverseTransitionDuration: longDuration,
    );
  }

  // Create a scale + fade transition
  static PageRoute<T> scaleTransition<T>({
    required Widget page,
    required String name,
  }) {
    return PageRouteBuilder<T>(
      settings: RouteSettings(name: name),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: entranceCurve),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: longDuration,
      reverseTransitionDuration: longDuration,
    );
  }

  // Staggered list animation
  static Animation<double> staggerAnimation({
    required Animation<double> parent,
    required int itemIndex,
    required int totalItems,
  }) {
    const staggerDelay = 0.05;
    const start = staggerDelay * 0.0;
    final itemDelay = staggerDelay * itemIndex;
    final end = itemDelay + staggerDelay;

    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: parent,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }
}

// Smooth page transition helper
class SmoothPageRoute<T> extends PageRoute<T> {
  final Widget Function(
    BuildContext,
    Animation<double>,
    Animation<double>,
  ) pageBuilder;

  final Duration transitionDuration;

  SmoothPageRoute({
    required this.pageBuilder,
    this.transitionDuration = const Duration(milliseconds: 500),
    RouteSettings? settings,
  }) : super(settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  bool get opaque => true;

  @override
  Duration get transitionDuration => this.transitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return pageBuilder(context, animation, secondaryAnimation);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.05),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: child,
      ),
    );
  }
}
