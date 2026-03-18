import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_theme.dart';
import 'package:app/src/feature/home/view/homepage_view.dart';
import 'package:app/src/feature/onboarding/view/onboarding_view.dart';
import 'package:app/src/feature/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/get_navigation.dart';

void main() {
  runApp(const FinzaApp());
}

class FinzaApp extends StatelessWidget {
  const FinzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: "/",
          getPages: [
            GetPage(name: '/onboarding', page: () => const OnboardingView()),
            GetPage(name: '/home', page: () => const HomepageView()),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const Splashpage(),
        );
      },
    );
  }
}
