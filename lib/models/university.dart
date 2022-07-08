class University {
  int id;
  final String name;
  final String country;
  final String state;
  final String alpha2Code;
  final List<String> domains;
  final List<String> webPages;
  int isFavorite;

  University(
    this.id, {
    required this.name,
    required this.country,
    required this.state,
    required this.alpha2Code,
    required this.domains,
    required this.webPages,
    this.isFavorite = 0,
  });

  University.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'],
        country = json['country'],
        state = json['state'] ?? 'not defined',
        alpha2Code = json['alpha_two_code'],
        domains = List<String>.from(json['domains']),
        webPages = List<String>.from(json['web_pages']),
        isFavorite = json['is_favorite'] ?? 0;

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'id': id,
  //     'name': name,
  //     'country': country,
  //     'state': state,
  //     'alpha2Code': alpha2Code,
  //     'domains': domains,
  //     'webPages': webPages,
  //   };
  // }

  // factory University.fromMap(Map<String, dynamic> map) {
  //   return University(
  //     id: map['id'] as int,
  //     name: map['name'] as String,
  //     country: map['country'] as String,
  //     state: map['state'] != null ? map['state'] as String : null,
  //     alpha2Code: map['alpha2Code'] as String,
  //     domains: List<String>.from((map['domains'] as List<String>)),
  //     webPages: List<String>.from((map['webPages'] as List<String>)),
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory University.fromJson(String source) => University.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'University(id: $id, name: $name, country: $country, state: $state, alpha2Code: $alpha2Code, domains: $domains, webPages: $webPages, isFavorite: $isFavorite)';
  }
}
