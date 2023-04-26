import 'package:task/domain/model/email.dart';

abstract class EmailRepository {
  Future<void> sendEmail(final Email email);
}
