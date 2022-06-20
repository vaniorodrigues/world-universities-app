import 'package:flutter/material.dart';
import 'package:worlduniversities/repositories/country_repository.dart';

import '../models/countries.dart';
import 'universities_list_page.dart';

class CountriesPage extends StatefulWidget {
  const CountriesPage({Key? key}) : super(key: key);

  @override
  State<CountriesPage> createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage> {
  @override
  Widget build(BuildContext context) {
    List<Countries> countries = CountryRepository.countries;
    debugPrint('--------------------------------CountriesPage.build()');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Country in South America'),
      ),
      body: ListView.separated(
        separatorBuilder: ((context, index) => const Divider()),
        itemCount: CountryRepository.countries.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int index) {
          // debugPrint('countries name: ${countries[index].name}');
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) =>
                            UniversitiesList(country: countries[index].name)))
                    .then((_) => setState(() {}));
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
      ),
    );
  }
}
