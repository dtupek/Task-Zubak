import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:task/app/model/notification_message.dart';
import 'package:task/app/service/notification_service.dart';

class MessagingService {
  static final FirebaseMessaging _messagingInstance = FirebaseMessaging.instance;
  static StreamSubscription? stream;

  static Future<String?> getFCMToken() async => await _messagingInstance.getToken();

  static Future<void> askIOSPermission() async {
    await _messagingInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static void subscribeToForegroundMessages() {
    stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _notifyUser(message);
    });
  }

  static void unsubscribeFromForegroundMessages() async => await stream?.cancel();

  @pragma('vm:entry-point')
  static Future<void> subscribeToBackgroundMessages(final RemoteMessage message) async {
    await Firebase.initializeApp();
    await _notifyUser(message);
  }

  static Future<void> _notifyUser(RemoteMessage message) async {
    final notification = _getNotificationMessageFromRemoteMessage(message);
    await NotificationService().showNotification(notification);
  }

  static NotificationMessage _getNotificationMessageFromRemoteMessage(
    final RemoteMessage message,
  ) =>
      NotificationMessage.fromJson(message.data);
}
