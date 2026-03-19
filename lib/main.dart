import 'package:app/firebase_options.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/src/core/color/app_theme.dart';
import 'package:app/src/feature/home/view/homepage_view.dart';
import 'package:app/src/feature/notification/view/notification_view.dart';
import 'package:app/src/feature/onboarding/view/onboarding_view.dart';
import 'package:app/src/feature/splash/view/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const FinzaApp());
}

class FinzaApp extends StatefulWidget {
  const FinzaApp({super.key});

  @override
  State<FinzaApp> createState() => _FinzaAppState();
}

class _FinzaAppState extends State<FinzaApp> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // Future<void> saveUserToken(String userId, String token) async {
  //   await FirebaseFirestore.instance.collection('users').doc(userId).set({
  //     'fcmToken': token,
  //     'updatedAt': FieldValue.serverTimestamp(),
  //   }, SetOptions(merge: true));
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initializeNotifications();
  //   _setupFCM();
  // }

  // void initializeNotifications() {
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   flutterLocalNotificationsPlugin.initialize(
  //       settings: initializationSettings);
  // }

  // Future<void> _setupFCM() async {
  //   NotificationSettings settings =
  //       await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     String? token = await FirebaseMessaging.instance.getToken();
  //     if (token != null) {
  //       final user = _auth.currentUser;
  //       if (user != null) {
  //         await saveUserToken(user.uid, token);
  //       }
  //     }
  //     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //       RemoteNotification? notification = message.notification;
  //       AndroidNotification? android = message.notification?.android;
  //       if (notification != null && android != null) {
  //         flutterLocalNotificationsPlugin.show(
  //             id: notification.hashCode,
  //             title: notification.title,
  //             body: notification.body,
  //             notificationDetails: NotificationDetails(
  //                 android: AndroidNotificationDetails("high_importance_channel",
  //                     "High Importance Notifications",
  //                     importance: Importance.max,
  //                     priority: Priority.high,
  //                     showWhen: true,
  //                     channelShowBadge: true)));
  //       }
  //     });
  //     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //       print('A new onMessageOpenedApp event was published!');
  //       Get.toNamed('/notification');
  //     });
  //   } else {
  //     debugPrint('User declined or has not accepted permission');
  //   }
  //   FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       await saveUserToken(user.uid, newToken);
  //     }
  //   });
  // }

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
            GetPage(
                name: '/notification', page: () => const NotificationView()),
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
