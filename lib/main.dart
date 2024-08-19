import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

main() async {
  final repo = UserApiRepository(httpClient: makeHttpClientGet());
  await repo.loadCurrentUser();
}

HttpGetClient makeHttpClientGet() => DioAdapter(logger: ConsoleLoggerAdapter());

final class UserApiRepository {
  final HttpGetClient httpClient;

  const UserApiRepository({
    required this.httpClient,
  });

  Future<void> loadCurrentUser() async {
    await httpClient.get(url: "http://localhost:4000/users");
  }
}

abstract interface class Logger {
  Future<void> log({required String key, required Map<String, dynamic> value});
}

final class ConsoleLoggerAdapter implements Logger {
  @override
  Future<void> log(
      {required String key, required Map<String, dynamic> value}) async {
    print(key);
    print(value);
  }
}

abstract interface class HttpGetClient {
  Future<dynamic> get({required String url});
}

final class HttpAdapter implements HttpGetClient {
  final client = Client();
  final Logger logger;

  HttpAdapter({
    required this.logger,
  });

  @override
  Future<dynamic> get({required String url}) async {
    final response = await client.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    await logger.log(key: 'http_request', value: json);

    return json;
  }
}

final class DioAdapter implements HttpGetClient {
  final client = Dio();
  final Logger logger;

  DioAdapter({
    required this.logger,
  });

  @override
  Future<dynamic> get({required String url}) async {
    final response = await client.get(url);
    final json = response.data;
    await logger.log(key: 'http_request', value: json);

    return json;
  }
}
