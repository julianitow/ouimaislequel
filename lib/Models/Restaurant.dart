import 'package:mcdo_paris/Models/Address.dart';

class Restaurant {
  String name;
  Address address;
  List<double> coordinates;
  bool visited = false;
  late int note;

  Restaurant(
      {required this.name,
      required this.address,
      required this.coordinates,
      this.visited = false});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    final coordinates = parsedJson['coordinates'];
    for (var i = 0; i < coordinates.length; i++) {
      if (coordinates[i] == 0) {
        coordinates[i] = 0.0;
      }
    }
    return Restaurant(
        name: parsedJson['name'].toString(),
        address: Address.fromJson(parsedJson['address']),
        coordinates: [coordinates[0] as double, coordinates[1] as double]);
  }
}
