import 'dart:convert';
import 'package:http/http.dart';
import 'package:mcdo_paris/Models/Restaurant.dart';
import 'package:mcdo_paris/Models/User.dart';

class HttpService {
  final String host = '10.0.2.2:3000';
  final String usersRoute = '/users';
  final String restaurantsRoute = '/list';
  final String restaurantUpdateRoute = '/restaurant/';

  Future<List<User>> getUsers() async {
    final Uri uri = Uri.http(host, usersRoute);
    List<User> users = List.empty();
    try {
      Response res = await get(uri);
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        users = body.map((e) => User.fromJson(e)).toList();
      } else {
        print('Error: $res.statusCode');
      }
    } catch (err) {
      print(err);
    }
    return users;
  }

  Future<List<Restaurant>> getRestaurants() async {
    final Uri uri = Uri.http(host, restaurantsRoute);
    List<Restaurant> restaurants = List.empty();
    try {
      Response res = await get(uri);
      if (res.statusCode == 200) {
        List<dynamic> body = jsonDecode(res.body);
        restaurants = body.map((e) => Restaurant.fromJson(e)).toList();
      } else {
        print('Error: $res.statusCode');
      }
    } catch (err) {
      print(err);
    }

    return restaurants;
  }

  Future<int> updateRestaurant(Restaurant restaurant) async {
    final String id = restaurant.id;
    final Uri uri = Uri.http(host, '$restaurantUpdateRoute$id');
    Map<String, String> headers = Map();
    headers['Content-Type'] = 'application/json';
    final json = jsonEncode(restaurant.toJson());
    print(json);
    int result = 0;
    try {
      Response res = await post(uri, headers: headers, body: json);
      result = res.statusCode;
    } catch (err) {
      result = -1;
    }
    return result;
  }
}
