import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

main() async {
  final repo = UserApiRepository(httpClient: makeHttpClientGet());
  await repo.loadCurrentUser();
}

HttpGetClient makeHttpClientGet() => DioAdapter();

final class UserApiRepository {
  final HttpGetClient httpClient;

  const UserApiRepository({
    required this.httpClient,
  });

  Future<void> loadCurrentUser() async {
    final json = await httpClient.get(url: "http://localhost:4000/users");
    Logger().log(key: 'loadCurrentUser', value: json);
  }
}

final class Logger {
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
