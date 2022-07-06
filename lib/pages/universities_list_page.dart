import 'package:flutter/material.dart';
import 'package:worlduniversities/components/university_list_view_builder.dart';
import 'package:worlduniversities/database/dao/country_dao.dart';
import 'package:worlduniversities/database/dao/university_dao.dart';
import 'package:worlduniversities/http/webclients/transaction_webclient.dart';
import 'package:worlduniversities/models/country.dart';
import 'package:worlduniversities/models/university.dart';
import 'package:worlduniversities/widgets/centered_message.dart';
import 'package:worlduniversities/widgets/circular_progress.dart';

import 'university_info_page.dart';

class UniversitiesListPage extends StatelessWidget {
  final List<Country> countries;
  final int index;

  UniversitiesListPage({Key? key, required this.index, required this.countries}) : super(key: key);

  final TransactionWebClient _webClient = TransactionWebClient();

  final UniversityDao _daoUni = UniversityDao();
  final CountryDao _daoCountry = CountryDao();

  @override
  Widget build(BuildContext context) {
    Country selectedCountry = countries[index];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Universities in ${selectedCountry.name}'),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Image.asset(
                'assets/${countries[index].name.toLowerCase()}.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // Tests if the country has already been searched in the web api, if so, shows the database data.
      body: _GetUniversities(
        webClient: _webClient,
        countries: countries,
        daoUni: _daoUni,
        daoCountry: _daoCountry,
        index: index,
      ),
    );
  }
}

class _GetUniversities extends StatefulWidget {
  final TransactionWebClient _webClient;
  final List<Country> countries;
  final UniversityDao _daoUni;
  final CountryDao _daoCountry;
  final int index;

  const _GetUniversities({
    Key? key,
    required TransactionWebClient webClient,
    required this.countries,
    required UniversityDao daoUni,
    required CountryDao daoCountry,
    required this.index,
  })  : _webClient = webClient,
        _daoUni = daoUni,
        _daoCountry = daoCountry,
        super(key: key);

  @override
  State<_GetUniversities> createState() => _GetUniversitiesState();
}

class _GetUniversitiesState extends State<_GetUniversities> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<University>>(
      initialData: const [],
      future: _loadsUniversities(widget.countries[widget.index]),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return const Progress();
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final List<University> universities = snapshot.data!;
              return UniversityListViewBuilder(
                universities: universities,
                daoUni: widget._daoUni,
                onClick: (university) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => UniversityInfoPage(university)))
                      .then((value) => setState(() {}));
                },
              );
            }
            return const CenteredMessage(message: 'No universities found.', icon: Icons.error_outline);
        }
        return const CenteredMessage(message: 'Unknown Error', icon: Icons.warning);
      },
    );
  }

  Future<List<University>> _loadsUniversities(Country country) async {
    if (country.isLocalDataAvailable == 0) {
      final List<University> universities = await widget._webClient.findByCountry(country.name);
      await _saveUniversitiesDao(universities);
      country.foundUniversities = universities.length;
      country.isLocalDataAvailable = 1;
      await widget._daoCountry.updateCountry(country);
      return universities;
    }
    List<University> universities = await widget._daoUni.findByCountry(country.name);
    return universities;
  }

  Future<void> _saveUniversitiesDao(List<University> universities) async {
    for (final university in universities) {
      await widget._daoUni.save(university);
    }
  }
}
