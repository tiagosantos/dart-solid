import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart';

main() async {
  final httpClient = DioAdapter();
  final repo = UserApiRepository(httpClient: httpClient);
  await repo.loadCurrentUser();
}

final class UserApiRepository {
  final HttpGetClient httpClient;

  const UserApiRepository({
    required this.httpClient,
  });

  Future<void> loadCurrentUser() async {
    final json = await httpClient.get(url: "http://localhost:4000/users");
    print(json);
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
