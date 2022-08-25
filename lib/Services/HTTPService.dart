import 'dart:convert';

import 'package:http/http.dart';
import 'package:mcdo_paris/Models/User.dart';

class HttpService {
  final String host = '10.0.2.2:3000';
  final String usersRoute = '/users';
  final String restaurantsRoute = '/list';

  Future<List<User>> getUsers() async {
    final Uri uri = Uri.http(host, usersRoute);
    List<User> users = List.empty();
    Response res = await get(uri);
    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      users = body.map((e) => User.fromJson(e)).toList();
    } else {
      print('Error: $res.statusCode');
    }
    return users;
  }
}
