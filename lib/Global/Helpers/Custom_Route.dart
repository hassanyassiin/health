import 'package:flutter/material.dart';

class CustomPage<T> extends Page<T> {
  final Widget screen;
  CustomPage({required this.screen}) : super(key: ValueKey(screen));

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return screen;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}

PageRouteBuilder<void> Custom_Fade_and_Slide_Route({required Widget screen}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return screen;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (animation.status == AnimationStatus.reverse) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offset_animation = animation.drive(tween);

        return SlideTransition(
          position: offset_animation,
          child: child,
        );
      } else {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var fade_animation = animation.drive(tween);

        return FadeTransition(
          opacity: fade_animation,
          child: child,
        );
      }
    },
  );
}

PageRouteBuilder<void> Custom_Fade_Route({required Widget screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
    return screen;
  }, transitionsBuilder: (context, animation, secondaryAnimation, child) {
    const begin = 0.0;
    const end = 1.0;
    const curve = Curves.easeInOut;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var fade_animation = animation.drive(tween);

    return FadeTransition(
      opacity: fade_animation,
      child: child,
    );
  });
}

PageRouteBuilder<dynamic> Custom_From_Down_To_Up_Route(
    {required Widget screen}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return screen;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
