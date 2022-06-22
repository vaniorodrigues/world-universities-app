import 'package:flutter/material.dart';
import 'package:worlduniversities/database/dao/university_dao.dart';
import 'package:worlduniversities/models/university.dart';

import '../database/dao/country_dao.dart';
import '../http/webclients/transaction_webclient.dart';
import '../repositories/country_repository.dart';
import '../widgets/centered_message.dart';
import '../widgets/circular_progress.dart';
import '../models/country.dart';
import 'university_info_page.dart';

// FIXME:
// - the isLocalDataAvailable needs to be saved in the database, otherwise it will be false everytime the app is reopened.

class UniversitiesListPage extends StatefulWidget {
  final String country;
  final int index;

  const UniversitiesListPage(
      {Key? key, required this.country, required this.index})
      : super(key: key);

  @override
  State<UniversitiesListPage> createState() => _UniversitiesListPageState();
}

class _UniversitiesListPageState extends State<UniversitiesListPage> {
  final TransactionWebClient _webClient = TransactionWebClient();
  final List<Country> countries = CountryRepository.countries;

  final UniversityDao _daoUni = UniversityDao();
  final CountryDao _daoCountry = CountryDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities in ${widget.country}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // Tests if the country has already been searched in the web api, if so, shows the database data.
      body: countries[widget.index].isLocalDataAvailable == 1
          ? _GetUniversitiesFromDB(
              dao: _daoUni,
              widget: widget,
            )
          : _GetUniversitiesFromAPI(
              webClient: _webClient,
              widget: widget,
              countries: countries,
              daoUni: _daoUni,
              daoCountry: _daoCountry,
            ),
    );
  }
}

class _GetUniversitiesFromDB extends StatelessWidget {
  const _GetUniversitiesFromDB({
    Key? key,
    required UniversityDao dao,
    required this.widget,
  })  : _dao = dao,
        super(key: key);

  final UniversityDao _dao;
  final UniversitiesListPage widget;

  @override
  Widget build(BuildContext context) {
    debugPrint('getting from DB');
    return FutureBuilder<List<University>>(
        initialData: const [],
        future: _dao.findByCountry(widget.country),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              final List<University> universities = snapshot.data!;
              return _UniversityListViewBuilder(universities: universities);
          }
          return const Text('Error in loading the database data');
        });
  }
}

class _GetUniversitiesFromAPI extends StatelessWidget {
  final TransactionWebClient _webClient;
  final UniversitiesListPage widget;
  final List<Country> countries;
  final UniversityDao _daoUni;
  final CountryDao _daoCountry;

  const _GetUniversitiesFromAPI({
    Key? key,
    required TransactionWebClient webClient,
    required this.widget,
    required this.countries,
    required UniversityDao daoUni,
    required CountryDao daoCountry,
  })  : _webClient = webClient,
        _daoUni = daoUni,
        _daoCountry = daoCountry,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('getting from API');
    return FutureBuilder<List<University>>(
      future: _webClient.findByCountry(widget.country),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            break;
          case ConnectionState.waiting:
            return const Progress();
          case ConnectionState.active:
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              // Saves the data in the universities data from snapshto into the database UniversityDao
              final List<University> universities = snapshot.data!;
              _saveUniversitiesDao(universities);

              // Updates the country's isLocalDataAvailable to 1 to indicate that the data is available in the database, also updates the number of universities in the country.
              countries[widget.index].foundUniversities = universities.length;
              countries[widget.index].isLocalDataAvailable = 1;
              _daoCountry.updateFoundUniversities(countries[widget.index]);

              if (universities.isNotEmpty) {
                return _UniversityListViewBuilder(
                  universities: universities,
                );
              }
              return const CenteredMessage(
                  message: 'No universities found.', icon: Icons.error_outline);
            }
            return const CenteredMessage(
                message: 'No data found!', icon: Icons.warning);
        }
        return const CenteredMessage(
            message: 'No data found 2!!', icon: Icons.warning);
      },
    );
  }

  void _saveUniversitiesDao(List<University> universities) {
    for (final university in universities) {
      _daoUni.save(university);
    }
  }
}

class _UniversityListViewBuilder extends StatelessWidget {
  const _UniversityListViewBuilder({
    Key? key,
    required this.universities,
  }) : super(key: key);

  final List<University> universities;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: universities.length,
      itemBuilder: (context, index) {
        final University university = universities[index];
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UniversityInfoPage(university),
                ),
              );
            },
            title: Text(
              university.name,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }
}
