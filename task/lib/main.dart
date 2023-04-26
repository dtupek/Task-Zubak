import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task/app/globals.dart';
import 'package:task/app/service/messaging_service.dart';
import 'package:task/app/service/notification_service.dart';
import 'package:task/data/local_source/database_manager.dart';
import 'package:task/presentation/route/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(MessagingService.subscribeToBackgroundMessages);
  await NotificationService().init();
  await DatabaseManager.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    MessagingService.subscribeToForegroundMessages();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        MessagingService.subscribeToForegroundMessages();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        MessagingService.unsubscribeFromForegroundMessages();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: const TextTheme(
          labelLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: RouteGenerator.homeScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
