import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:worlduniversities/http/interceptors/logging_interceptor.dart';

final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
  requestTimeout: const Duration(seconds: 2),
);

const String baseUrl = 'http://universities.hipolabs.com';
