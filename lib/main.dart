import 'package:app/l10n/app_localizations.dart';
import 'package:app/router/pages.dart';
import 'package:app/router/router_name.dart';
import 'package:app/src/core/color/app_theme.dart';
import 'package:app/src/data/local/token_storage.dart';
import 'package:app/src/feature/main_controller/main_controller.dart';
import 'package:app/src/feature/widget/draggable_ai_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app/src/data/network/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp();
  debugPrint("Firebase initialized successfully");

  Get.put(ApiClient());
  final mainController = Get.put(
    MainController(SecureTokenStorage.instance),
    permanent: true,
  );
  await mainController.loadSettings();
  runApp(const FinzaApp());
}

class FinzaApp extends StatefulWidget {
  const FinzaApp({super.key});

  @override
  State<FinzaApp> createState() => _FinzaAppState();
}

class _FinzaAppState extends State<FinzaApp> {
  final MainController _mainController = Get.find<MainController>();

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
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _mainController.locale,
          fallbackLocale: const Locale('en'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _mainController.themeMode,
          routingCallback: (routing) {
            _mainController.updateCurrentRoute(routing?.current);
          },
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                child ?? const SizedBox.shrink(),
                const DraggableAiChatButton(),
              ],
            );
          },
        );
      },
    );
  }
}
