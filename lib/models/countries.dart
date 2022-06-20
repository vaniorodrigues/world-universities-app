class Countries {
  final String name;
  int foundUniversities;

  Countries(this.name, {this.foundUniversities = 0});

  @override
  String toString() =>
      'Countries(name: $name, foundUniversities: $foundUniversities)';
}
