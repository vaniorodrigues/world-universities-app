import 'package:flutter/material.dart';
import 'package:worlduniversities/database/dao/country_dao.dart';
import 'package:worlduniversities/repositories/country_repository.dart';

import '../database/dao/university_dao.dart';
import '../models/country.dart';
import '../widgets/circular_progress.dart';
import 'universities_list_page.dart';

class CountriesListPage extends StatefulWidget {
  const CountriesListPage({Key? key}) : super(key: key);

  @override
  State<CountriesListPage> createState() => _CountriesListPageState();
}

class _CountriesListPageState extends State<CountriesListPage> {
  final CountryDao _dao = CountryDao();
  final List<Country> _countries = CountryRepository.countries;

  @override
  Widget build(BuildContext context) {
    _dao.initializeCountries(
        _countries); //Initialize the database with the countries data.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Country in South America'),
      ),
      body: FutureBuilder<List<Country>>(
          initialData: const [],
          future: _dao.findAll(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                return const Progress();
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                final List<Country> countries = snapshot.data!;
                return _CountriesListViewBuilder(countries);
            }
            return const Text('Error in loading the database data');
          }),
    );
  }
}

class _CountriesListViewBuilder extends StatelessWidget {
  const _CountriesListViewBuilder(
    this.countries, {
    Key? key,
  }) : super(key: key);

  final List<Country> countries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: ((context, index) => const Divider()),
      itemCount: countries.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int index) {
        // debugPrint('countries name: ${countries[index].name}');
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UniversitiesListPage(
                            country: countries[index].name,
                            index: index,
                          )))
                  // .then((_) => setState(() {}))
                  ;
            },
            title: Text(
              countries[index].name,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
                'Universities found: ${countries[index].foundUniversities}'),
          ),
        );
      },
    );
  }
}
