import 'package:task/app/service/messaging_service.dart';
import 'package:task/domain/manager/email_manager.dart';
import 'package:task/domain/model/email.dart';
import 'package:task/domain/repository/email_repository.dart';

class SendEmailUseCase {
  final EmailRepository _emailRepository;
  final EmailManager _emailManager;

  const SendEmailUseCase(
    this._emailRepository,
    this._emailManager,
  );

  Future<void> sendEmail({
    required final List<String> recipients,
    required final double price,
    required final String message,
  }) async {
    final fcmToken = await MessagingService.getFCMToken();
    final email = Email(
      recipient: recipients,
      price: price,
      message: message,
      fcmToken: fcmToken!,
    );
    await _emailRepository.sendEmail(email);
    await _emailManager.insertEmail(email);
  }
}
