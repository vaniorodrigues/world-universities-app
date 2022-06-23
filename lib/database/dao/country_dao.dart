import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:worlduniversities/repositories/country_repository.dart';

import '../../models/country.dart';
import '../database.dart';

// DAO - Data Access Object
class CountryDao {
  static const String tableSql = 'CREATE TABLE $_tableName( '
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_foundUniversities INTEGER, '
      '$_isLocalDataAvailable INTEGER)';

  static const String _tableName = 'contries';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _foundUniversities = 'foundUniversities';
  static const String _isLocalDataAvailable = 'isLocalDataAvailable';

  void initializeCountriesDatabase(List<Country> countries) async {
    final Database database = await getCountryDatabase();
    List<Country> countriesOnDB = _toList(await database.query(_tableName));
    if (countriesOnDB.isEmpty) {
      for (Country country in countries) {
        Map<String, dynamic> countryMap = _toMap(country);
        database.insert(_tableName, countryMap);
      }
    }
  }

  Map<String, dynamic> _toMap(Country country) {
    final Map<String, dynamic> countryMap = {};
    countryMap[_name] = country.name;
    countryMap[_foundUniversities] = country.foundUniversities;
    countryMap[_isLocalDataAvailable] = country.isLocalDataAvailable;
    return countryMap;
  }

  Future<List<Country>> findAll() async {
    final Database database = await getCountryDatabase();
    List<Country> countries = _toList(await database.query(_tableName));
    for (Country country in countries) {
      debugPrint('CURRENT DATABASE (FINDALL): ${country.toString()}');
    }
    return countries;
  }

  List<Country> _toList(List<Map<String, dynamic>> result) {
    final List<Country> countries = [];
    for (Map<String, dynamic> row in result) {
      final Country country = Country(
        row[_id],
        name: row[_name],
        foundUniversities: row[_foundUniversities],
        isLocalDataAvailable: row[_isLocalDataAvailable],
      );
      countries.add(country);
    }
    return countries;
  }

  Future<void> updateCountry(Country country) async {
    debugPrint(
        '==========>TRYING TO UPDATE FOR THE 100X TIME: ${country.toString()}');
    final Database database = await getCountryDatabase();
    Map<String, dynamic> countryMap = _toMap(country);
    database.update(
      _tableName,
      countryMap,
      where: '$_id = ?',
      whereArgs: [country.id],
    );
    findAll();
  }

  Future<void> save(Country country) async {
    final Database database = await getCountryDatabase();
    Map<String, dynamic> countryMap = _toMap(country);
    database.insert(_tableName, countryMap);
    ConflictAlgorithm.replace;
    debugPrint(
        '==========>SAVING COUNTRY CountryDao.updateFoundUniversities. countryOnDB: $country');
  }
}
