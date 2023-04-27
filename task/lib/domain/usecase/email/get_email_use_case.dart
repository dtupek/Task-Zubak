import 'package:task/domain/manager/email_manager.dart';
import 'package:task/domain/model/email.dart';

class GetEmailUseCase {
  final EmailManager _emailManager;

  const GetEmailUseCase(this._emailManager);

  List<Email> getEmails() => _emailManager.getEmails();
}
