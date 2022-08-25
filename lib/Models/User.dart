class User {
  String? id;
  String username;

  User({required this.id, required this.username});
  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['_id'].toString(),
        username: parsedJson['username'].toString());
  }
}
