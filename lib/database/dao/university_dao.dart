import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/university.dart';
import '../database.dart';

// DAO - Data Access Object
class UniversityDao {
  static const String tableSql = 'CREATE TABLE $_tableName( '
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_country TEXT, '
      '$_state TEXT, '
      '$_alpha2Code TEXT, '
      '$_domains TEXT, '
      '$_webPages TEXT, '
      '$_isFavorite INTEGER)';

  static const String _tableName = 'universities';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _country = 'country';
  static const String _state = 'state';
  static const String _alpha2Code = 'alpha2Code';
  static const String _domains = 'domains';
  static const String _webPages = 'webPages';
  static const String _isFavorite = 'isFavorite';

  Future<int> save(University university) async {
    final Database database = await getUniversityDatabase();
    List<University> universities = _toList(await database.query(_tableName));
    university.id = universities.length +
        1; // Sets the id to the next available id on db, otherwise the favorite university will be overwritten.
    Map<String, dynamic> universityMap = _toMap(university);
    return database.insert(_tableName, universityMap);
  }

  Future<void> updateFavorite(University university) async {
    final Database database = await getUniversityDatabase();
    Map<String, dynamic> universityMap = _toMap(university);
    debugPrint(
        'UniversityDao.updateFavorite. universityMap: id:${university.id} ${university.toString()}');
    database.update(_tableName, universityMap,
        where: '$_id = ?', whereArgs: [university.id]);
  }

  // Gets all universities from the database.
  Future<List<University>> findAll() async {
    final Database database = await getUniversityDatabase();
    List<University> universities = _toList(await database.query(_tableName));
    for (University university in universities) {
      debugPrint('UniversityDao.findAll. university: ${university.toString()}');
    }
    return universities;
  }

  // Gets universities by country from the database.
  Future<List<University>> findByCountry(String country) async {
    final Database database = await getUniversityDatabase();
    List<University> universities = _toList(await database
        .query(_tableName, where: '$_country = ?', whereArgs: [country]));
    universities.sort((a, b) => a.name.compareTo(b.name));
    for (University university in universities) {
      debugPrint(
          'UniversityDao.findByCountry. AFTER SORTING universities: ${university.toString()}');
    }
    return universities;
  }

  List<University> _toList(List<Map<String, dynamic>> result) {
    final List<University> universities = [];
    for (Map<String, dynamic> row in result) {
      final University university = University(
        row[_id],
        name: row[_name],
        country: row[_country],
        state: row[_state],
        alpha2Code: row[_alpha2Code],
        domains: List<String>.from(row[_domains].split(',')),
        webPages: List<String>.from(row[_webPages].split(',')),
        isFavorite: row[_isFavorite],
      );
      universities.add(university);
    }
    return universities;
  }

  Map<String, dynamic> _toMap(University university) {
    final Map<String, dynamic> universityMap = {};
    // Not adding 'id' here will make SQLite take care of increment it.
    universityMap[_id] = university.id;
    universityMap[_name] = university.name;
    universityMap[_country] = university.country;
    universityMap[_state] = university.state;
    universityMap[_alpha2Code] = university.alpha2Code;
    universityMap[_domains] = university.domains.toString();
    universityMap[_webPages] = university.webPages.toString();
    universityMap[_isFavorite] = university.isFavorite;
    return universityMap;
  }
}
