import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

main() async {
  final repo = UserApiRepository(httpClient: makeHttpClientGet());
  await repo.loadCurrentUser();
}

HttpGetClient makeHttpClientGet() => HttpGetClientLogDecorator(
      logger: ConsoleLoggerAdapter(),
      decoratee: HttpAdapter(),
    );

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

final class HttpGetClientLogDecorator implements HttpGetClient {
  final Logger logger;
  final HttpGetClient decoratee;

  HttpGetClientLogDecorator({
    required this.logger,
    required this.decoratee,
  });

  @override
  Future<dynamic> get({required String url}) async {
    final response = await decoratee.get(url: url);
    await logger.log(
      key: 'http_request',
      value: {
        url: url,
      },
    );
    await logger.log(
      key: 'http_request',
      value: response,
    );
    return response;
  }
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
