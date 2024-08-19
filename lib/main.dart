import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

main() async {
  final logger = ConsoleLoggerAdapter();
  final repo =
      UserApiRepository(httpClient: makeHttpClientGet(), logger: logger);
  await repo.loadCurrentUser();
}

HttpGetClient makeHttpClientGet() => DioAdapter();

final class UserApiRepository {
  final HttpGetClient httpClient;
  final Logger logger;

  const UserApiRepository({
    required this.httpClient,
    required this.logger,
  });

  Future<void> loadCurrentUser() async {
    final json = await httpClient.get(url: "http://localhost:4000/users");
    logger.log(key: 'loadCurrentUser', value: json);
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

  @override
  Future<dynamic> get({required String url}) async {
    final response = await client.get(Uri.parse(url));
    return jsonDecode(response.body);
  }
}

final class DioAdapter implements HttpGetClient {
  final client = Dio();

  @override
  Future<dynamic> get({required String url}) async {
    final response = await client.get(url);
    return response.data;
  }
}
