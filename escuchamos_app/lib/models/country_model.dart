class Country {
  final int id;
  final String name;
  final String abbreviation;
  final String dialingCode;

  Country({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.dialingCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      dialingCode: json['dialing_code'],
    );
  }
}
