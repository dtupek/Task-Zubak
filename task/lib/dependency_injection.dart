import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task/data/local_source/email/email_manager_impl.dart';
import 'package:task/data/remote_source/email_api.dart';
import 'package:task/data/repository/email_repository_impl.dart';
import 'package:task/domain/manager/email_manager.dart';
import 'package:task/domain/repository/email_repository.dart';
import 'package:task/domain/usecase/get_email_use_case.dart';
import 'package:task/domain/usecase/send_email_use_case.dart';
import 'package:task/presentation/riverpod/email_notifier.dart';

//! Ova adresa je postavljena iz razloga sto Android emulator ne zna sto je localhost, a backend app je na localhostu.
//! Za rad aplikacije potrebno je svoju IP adresu postaviti
final emailApiProvider = Provider<EmailApi>(
  ((ref) => EmailApi(Dio(BaseOptions()), baseUrl: 'http://192.168.0.183:3000')),
);

final emailManagerProvider = Provider<EmailManager>(
  (ref) => EmailManagerImpl(),
);

final emailRepositoryProvider = Provider<EmailRepository>(
  (ref) => EmailRepositoryImpl(ref.watch(emailApiProvider)),
);

final sendEmailUseCaseProvider = Provider<SendEmailUseCase>(
  (ref) => SendEmailUseCase(
    ref.watch(emailRepositoryProvider),
    ref.watch(emailManagerProvider),
  ),
);

final getEmailUseCaseProvider = Provider<GetEmailUseCase>(
  (ref) => GetEmailUseCase(ref.watch(emailManagerProvider)),
);

final emailNotifierProvider = ChangeNotifierProvider<EmailNotifier>(
  (ref) => EmailNotifier(
    ref.watch(sendEmailUseCaseProvider),
    ref.watch(getEmailUseCaseProvider),
  ),
);
