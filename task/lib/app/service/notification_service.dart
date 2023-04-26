import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task/app/globals.dart';
import 'package:task/app/model/notification_message.dart';
import 'package:task/presentation/route/route_generator.dart';

class NotificationService {
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final _notificationService = NotificationService._internal();
  factory NotificationService() => _notificationService;
  NotificationService._internal();

  static void _handleClickNotification() {
    Navigator.of(navigatorKey.currentContext!).pushNamed(
      RouteGenerator.sendMailScreen,
      arguments: {'showGoogleMaps': true},
    );
  }

  @pragma('vm:entry-point')
  static void _handleBackgroundClickNotification(final NotificationResponse notificationResponse) {}

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (_) => _handleClickNotification(),
      onDidReceiveBackgroundNotificationResponse: _handleBackgroundClickNotification,
    );
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  Future<void> showNotification(final NotificationMessage notificationMessage) async {
    final newInterventionSpecifics = _createNotificationDetails(
      channelId: 'task_notification_channel',
      channelTitle: 'Task Email',
      description: 'Task notification channel',
    );
    _showNotification(
      body: '${notificationMessage.message} ${notificationMessage.timestamp}',
      platformSpecifics: newInterventionSpecifics,
    );
  }

  NotificationDetails _createNotificationDetails({
    required final String channelId,
    required final String channelTitle,
    required final String description,
  }) {
    final androidNotificationDetails = AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: description,
      playSound: true,
      priority: Priority.max,
      importance: Importance.max,
    );

    const iOSNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );
    return platformChannelSpecifics;
  }

  Future<void> _showNotification({
    required final String body,
    required final NotificationDetails platformSpecifics,
  }) =>
      _localNotificationsPlugin.show(
        0,
        'Task',
        body,
        platformSpecifics,
      );
}
