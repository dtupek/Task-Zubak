import 'package:task/data/remote_source/email_api.dart';
import 'package:task/domain/model/email.dart';
import 'package:task/domain/repository/email_repository.dart';

class EmailRepositoryImpl implements EmailRepository {
  final EmailApi _emailApi;

  const EmailRepositoryImpl(
    this._emailApi,
  );
  @override
  Future<void> sendEmail(final Email email) async => _emailApi.sendEmail(email);
}
