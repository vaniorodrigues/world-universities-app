import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:worlduniversities/http/webclient.dart';
import 'package:worlduniversities/models/university.dart';

class TransactionWebClient {
  Future<List<University>> findAll() async {
    final Response response = await client.get(Uri.parse(baseUrl));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json) => University.fromJson(json)).toList();
  }

  Future<List<University>> findByCountry(String country) async {
    debugPrint('Url: $baseUrl/search?country=$country');
    final Response response = await client.get(Uri.parse('$baseUrl/search?country=$country'));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<University> universities = decodedJson.map((dynamic json) => University.fromJson(json)).toList();
    universities.sort((University a, University b) {
      return a.name.compareTo(b.name);
    });

    // The webAPI is sending duplicated universities for all requests.
    universities = deleteRepetitions(universities);

    for (University university in universities) {
      debugPrint('Transaction: Web-Client: findByCountry: ${university.toString()}');
    }

    return universities;
  }

  List<University> deleteRepetitions(List<University> universities) {
    List<University> universitiesUpdated = [];
    bool repetetive = false;
    for (University university in universities) {
      if (repetetive) {
        repetetive = false;
      } else {
        universitiesUpdated.add(university);
        repetetive = true;
      }
    }
    return universitiesUpdated;
  }
}
