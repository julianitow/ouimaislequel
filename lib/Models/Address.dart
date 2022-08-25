class Address {
  String address;
  String zipCode;
  String city;
  String country;
  Address(
      {required this.address,
      required this.zipCode,
      required this.city,
      required this.country});

  @override
  String toString() {
    return '$address, $zipCode, $city';
  }

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    return Address(
        address: parsedJson['address'].toString(),
        zipCode: parsedJson['zipCode'].toString(),
        city: parsedJson['city'].toString(),
        country: parsedJson['country'].toString());
  }
}
