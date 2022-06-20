import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../models/universities.dart';
import '../webclient.dart';

class TransactionWebClient {
  Future<List<University>> findAll() async {
    final Response response = await client.get(Uri.parse(baseUrl));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => University.fromJson(json))
        .toList();
  }

  Future<List<University>> findByCountry(String country) async {
    debugPrint('Url: $baseUrl/search?country=$country');
    final Response response =
        await client.get(Uri.parse('$baseUrl/search?country=$country'));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => University.fromJson(json))
        .toList();
  }
}
