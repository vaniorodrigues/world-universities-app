// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  String toString() {
    return 'Country(id: $id, name: $name, foundUniversities: $foundUniversities, isLocalDataAvailable: $isLocalDataAvailable)';
  }
}
