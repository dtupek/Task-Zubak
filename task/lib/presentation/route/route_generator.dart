import 'package:flutter/material.dart';
import 'package:task/presentation/screen/home_screen.dart';
import 'package:task/presentation/screen/send_mail_screen.dart';

class RouteGenerator {
  static const String homeScreen = '/';
  static const String sendMailScreen = '/sendMail';

  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(settings: settings, builder: (_) => const HomeScreen());
      case sendMailScreen:
        final showGoogleMaps = settings.arguments as Map;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SendMailScreen(showGoogleMaps: showGoogleMaps['showGoogleMaps']),
        );
      default:
        throw Exception('Route not found');
    }
  }
}
