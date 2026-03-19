import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationController {
  String? tokenNotification;

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    tokenNotification = token;
  }

  Future<void> sendFCM(String token) async {}
}
