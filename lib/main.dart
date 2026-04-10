import 'package:app/firebase_options.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/pages.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FinzaApp());
}

class FinzaApp extends StatefulWidget {
  const FinzaApp({super.key});

  @override
  State<FinzaApp> createState() => _FinzaAppState();
}

class _FinzaAppState extends State<FinzaApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialRoute: RouterName.splash,
          getPages: Pages.page,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
        );
      },
    );
  }
}
