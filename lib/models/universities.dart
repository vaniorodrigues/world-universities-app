// import 'dart:convert';

class University {
  final String name;
  final String country;
  final String? state;
  final String alpha2Code;
  final List<String> domains;
  final List<String> webPages;

  University({
    required this.name,
    required this.country,
    this.state = 'not found',
    required this.alpha2Code,
    required this.domains,
    required this.webPages,
  });

  University.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        country = json['country'],
        state = json['state'] ?? 'not found',
        alpha2Code = json['alpha_two_code'],
        domains = List<String>.from(json['domains']),
        webPages = List<String>.from(json['web_pages']);
}
