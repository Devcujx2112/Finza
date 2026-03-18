import 'package:app/src/feature/splash/viewmodel/splash_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _decideRoute());
  }

  Future<void> _decideRoute() async {
    final seen = await _controller.checkOnboarding();
    if (!mounted) return;
    Get.offAllNamed(seen ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
