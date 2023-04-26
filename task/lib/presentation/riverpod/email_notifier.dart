import 'package:flutter/material.dart';
import 'package:task/domain/model/email.dart';
import 'package:task/domain/usecase/send_email_use_case.dart';
import 'package:task/domain/usecase/get_email_use_case.dart';

class EmailNotifier extends ChangeNotifier {
  final SendEmailUseCase _sendEmailUsecase;
  final GetEmailUseCase _getEmailUseCase;

  EmailNotifier(
    this._sendEmailUsecase,
    this._getEmailUseCase,
  );

  Future<void> sendEmail({
    required final List<String> recipients,
    required final double price,
    required final String message,
  }) async {
    await _sendEmailUsecase.sendEmail(
      recipients: recipients,
      price: price,
      message: message,
    );
    notifyListeners();
  }

  List<Email> getEmails() => _getEmailUseCase.getEmails();
}
