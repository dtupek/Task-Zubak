import 'package:task/domain/model/email.dart';

abstract class EmailManager {
  List<Email> getEmails();
  Future<void> insertEmail(Email email);
}
