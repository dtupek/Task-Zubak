import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:task/domain/model/email.dart';

part 'email_api.g.dart';

@RestApi()
abstract class EmailApi {
  factory EmailApi(Dio dio, {String? baseUrl}) = _EmailApi;

  @POST('/mail')
  Future<void> sendEmail(
    @Body() Email email,
  );
}
