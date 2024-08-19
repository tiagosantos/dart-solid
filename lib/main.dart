import 'dart:convert';

import 'package:http/http.dart';

main() async {
  final repo = UserApiRepository();
  await repo.loadCurrentUser();
}

final class UserApiRepository {
  Future<void> loadCurrentUser() async {
    final response =
        await Client().get(Uri.parse("http://localhost:4000/users"));
    print(response.statusCode);
    print(jsonDecode(response.body));
  }
}
