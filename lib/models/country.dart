class Country {
  final int id;
  final String name;
  int foundUniversities;
  int isLocalDataAvailable;

  Country(
    this.id, {
    required this.name,
    this.foundUniversities = 0,
    this.isLocalDataAvailable = 0,
  });

  Country.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'],
        foundUniversities = json['foundUniversities'],
        isLocalDataAvailable = json['isLocalDataAvailable'];

  @override
  String toString() =>
      'Countries(name: $name, foundUniversities: $foundUniversities, isLocalDataAvailable: $isLocalDataAvailable)';
}
