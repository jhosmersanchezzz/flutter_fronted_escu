// models/user_model.dart

class User {
  final int id;
  final String username;
  final String email;
  final String name;
  final String lastName;
  final String address;
  final String phoneNumber;
  final int countryId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.lastName,
    required this.address,
    required this.phoneNumber,
    required this.countryId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      lastName: json['last_name'],
      address: json['address'],
      phoneNumber: json['phone_number'],
      countryId: json['country_id'],
    );
  }
}
