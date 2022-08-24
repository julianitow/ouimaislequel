import 'package:mcdo_paris/Models/Address.dart';

class Restaurant {
  String name;
  Address address;
  List<double> coordinates;
  bool visited = false;
  late int note;

  Restaurant(
      {required this.name, required this.address, required this.coordinates});

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurant(
        name: parsedJson['name'].toString(),
        address: Address.fromJson(parsedJson['restaurantAddress'][0]),
        coordinates: [
          parsedJson['coordinates']['latitude'],
          parsedJson['coordinates']['longitude']
        ]);
  }
}
