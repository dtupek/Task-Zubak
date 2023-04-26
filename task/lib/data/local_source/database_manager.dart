import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/data/local_source/hive_boxes.dart';
import 'package:task/domain/model/email.dart';

class DatabaseManager {
  static Future<void> initialize() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(emailAdapterId)) {
      Hive.registerAdapter(EmailAdapter());
    }
    if (!Hive.isBoxOpen(emailBoxName)) {
      await Hive.openBox<Email>(emailBoxName);
    }
  }
}
