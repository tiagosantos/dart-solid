import 'dart:convert';

import 'package:http/http.dart';

main() async {
  final repo = UserApiRepository();
  await repo.loadCurrentUser();
}

final class UserApiRepository {
  Future<void> loadCurrentUser() async {
    final httpClient = HttpGetClient();
    final json = await httpClient.get(url: "http://localhost:4000/users");
    print(json);
  }
}

final class HttpGetClient {
  Future<dynamic> get({required String url}) async {
    final response = await Client().get(Uri.parse(url));
    return jsonDecode(response.body);
  }
}
