import 'package:hive_flutter/hive_flutter.dart';
import 'package:task/data/local_source/hive_boxes.dart';
import 'package:task/domain/manager/email_manager.dart';
import 'package:task/domain/model/email.dart';

class EmailManagerImpl implements EmailManager {
  @override
  List<Email> getEmails() {
    final emailBox = Hive.box<Email>(emailBoxName);
    return emailBox.values.toList();
  }

  @override
  Future<void> insertEmail(Email email) async {
    final emailBox = Hive.box<Email>(emailBoxName);
    await emailBox.add(email);
  }
}
