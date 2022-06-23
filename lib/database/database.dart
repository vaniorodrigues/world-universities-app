import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dao/country_dao.dart';

import 'dao/university_dao.dart';

// Open the database and store the reference.
Future<Database> getUniversityDatabase() async {
  final String path = join(await getDatabasesPath(), 'uni.db');
  // deleteDatabase(path);
  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(UniversityDao.tableSql);
    },
    version: 1,
    // onDowngrade:
    //     onDatabaseDowngradeDelete, // apagar o banco de dados, mudar version para 2 para isso
  );
}

Future<Database> getCountryDatabase() async {
  final String path = join(await getDatabasesPath(), 'country.db');
  // deleteDatabase(path);
  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute(CountryDao.tableSql);
      // dao.saveAll();
    },
    version: 1,
    // onDowngrade:
    // onDatabaseDowngradeDelete, // apagar o banco de dados, mudar version para 2 para isso
  );
}
