import 'dart:ffi';

import 'package:mcdo_paris/Models/Address.dart';

class Restaurant {
  String id;
  String name;
  Address address;
  List<double> coordinates;
  bool visited = false;
  String? date;
  late int note;

  Restaurant(
      {required this.id,
      required this.name,
      required this.address,
      required this.coordinates,
      this.visited = false,
      this.date});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    final coordinates = parsedJson['coordinates'];
    for (var i = 0; i < coordinates.length; i++) {
      if (coordinates[i] == 0) {
        coordinates[i] = 0.0;
      }
    }
    return Restaurant(
        id: parsedJson['_id'].toString(),
        name: parsedJson['name'].toString(),
        address: Address.fromJson(parsedJson['address']),
        visited: parsedJson['visited'] == 'true',
        coordinates: [coordinates[0] as double, coordinates[1] as double],
        date: parsedJson['date']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address.toJson(),
        'coordinates': coordinates,
        'visited': visited.toString()
      };
}
