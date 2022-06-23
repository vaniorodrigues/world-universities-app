import 'package:flutter/material.dart';
import 'package:worlduniversities/database/dao/university_dao.dart';
import 'package:worlduniversities/models/university.dart';
import 'package:worlduniversities/widgets/favorite_button.dart';

import '../database/dao/country_dao.dart';
import '../http/webclients/transaction_webclient.dart';
import '../widgets/centered_message.dart';
import '../widgets/circular_progress.dart';
import '../models/country.dart';
import 'university_info_page.dart';

class UniversitiesListPage extends StatefulWidget {
  final List<Country> countries;
  final int index;

  const UniversitiesListPage(
      {Key? key, required this.index, required this.countries})
      : super(key: key);

  @override
  State<UniversitiesListPage> createState() => _UniversitiesListPageState();
}

// TODO: Add a search field to filter the universities by name.
// TODO: Only one body is needed, make the API body a call to a function that saves the university data in the database, the database is then loaded.

class _UniversitiesListPageState extends State<UniversitiesListPage> {
  final TransactionWebClient _webClient = TransactionWebClient();

  final UniversityDao _daoUni = UniversityDao();
  final CountryDao _daoCountry = CountryDao();
  @override
  Widget build(BuildContext context) {
    Country selectedCountry = widget.countries[widget.index];
    _daoUni.findAll();

    debugPrint(
        'Is local data available: ${selectedCountry.isLocalDataAvailable}');
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities in ${selectedCountry.name}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      // Tests if the country has already been searched in the web api, if so, shows the database data.
      body: selectedCountry.isLocalDataAvailable == 1
          ? _GetUniversitiesFromDB(
              dao: _daoUni,
              widget: widget,
              countries: widget.countries,
            )
          : _GetUniversitiesFromAPI(
              webClient: _webClient,
              widget: widget,
              countries: widget.countries,
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
    required this.countries,
  })  : _dao = dao,
        super(key: key);

  final UniversityDao _dao;
  final UniversitiesListPage widget;
  final List<Country> countries;

  @override
  Widget build(BuildContext context) {
    debugPrint('getting from DB');
    return FutureBuilder<List<University>>(
        initialData: const [],
        future: _dao.findByCountry(countries[widget.index].name),
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
              return _UniversityListViewBuilder(
                universities: universities,
                daoUni: _dao,
              );
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
      future: _webClient.findByCountry(countries[widget.index].name),
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
              // Saves the data in the universities data from snapshtot into the database UniversityDao
              final List<University> universities = snapshot.data!;
              _saveUniversitiesDao(universities);

              // Updates the country's isLocalDataAvailable to 1 to indicate that the data is available in the database, also updates the number of universities in the country.
              countries[widget.index].foundUniversities = universities.length;
              countries[widget.index].isLocalDataAvailable = 1;
              _daoCountry.updateCountry(countries[widget.index]);
              // _daoCountry.save(countries[widget.index]);

              if (universities.isNotEmpty) {
                return _UniversityListViewBuilder(
                  universities: universities,
                  daoUni: _daoUni,
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

  Future<void> _saveUniversitiesDao(List<University> universities) async {
    for (final university in universities) {
      await _daoUni.save(university);
    }
  }
}

class _UniversityListViewBuilder extends StatelessWidget {
  const _UniversityListViewBuilder({
    Key? key,
    required this.universities,
    required this.daoUni,
  }) : super(key: key);

  final List<University> universities;
  final UniversityDao daoUni;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: universities.length,
      itemBuilder: (context, index) {
        final University university = universities[index];
        debugPrint(
            '_UniversityListViewBuilder --> university: ${university.toString()}');
        return Card(
          child: ListTile(
            trailing: FavoriteButton(university: university, daoUni: daoUni),
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
