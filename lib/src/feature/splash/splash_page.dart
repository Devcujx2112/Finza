import 'package:app/src/feature/home/homepage_view.dart';
import 'package:app/src/feature/splash/splash_page_controller.dart';
import 'package:app/src/feature/onboarding/onboarding_view.dart';
import 'package:flutter/material.dart';

class Splashpage extends StatefulWidget {
  const Splashpage({super.key});

  @override
  State<Splashpage> createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  final SplashPageController _controller = SplashPageController();
  @override
  void initState() {
    super.initState();
    _controller.init();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isOnboarding.value) {
      return const HomepageView();
    } else {
      return const OnboardingView();
    }
  }
}
