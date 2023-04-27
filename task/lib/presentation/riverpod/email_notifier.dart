import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task/domain/model/email.dart';
import 'package:task/domain/usecase/email/get_email_use_case.dart';
import 'package:task/domain/usecase/email/send_email_use_case.dart';
import 'package:task/domain/usecase/image/get_image_use_case.dart';

class EmailNotifier extends ChangeNotifier {
  final SendEmailUseCase _sendEmailUsecase;
  final GetEmailUseCase _getEmailUseCase;
  final GetImageUseCase _getImageUseCase;

  EmailNotifier(
    this._sendEmailUsecase,
    this._getEmailUseCase,
    this._getImageUseCase,
  );

  File? _cachedImage;

  File? get cachedImage => _cachedImage;

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
    _cachedImage = null;
    notifyListeners();
  }

  List<Email> getEmails() => _getEmailUseCase.getEmails();

  void getImage() async {
    _cachedImage = await _getImageUseCase.getImage();
    notifyListeners();
  }
}
