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
    String address = parsedJson['address'].toString();
    address = address.replaceAll(',', '\n');
    return Address(
        address: address,
        zipCode: parsedJson['zipCode'].toString(),
        city: parsedJson['city'].toString(),
        country: parsedJson['country'].toString());
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'zipCode': zipCode.toString(),
        'city': city,
        'country': country
      };
}
