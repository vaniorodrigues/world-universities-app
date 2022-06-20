import 'package:flutter/material.dart';
import 'package:worlduniversities/models/universities.dart';

import '../http/webclients/transaction_webclient.dart';
import '../repositories/country_repository.dart';
import '../widgets/centered_message.dart';
import '../widgets/circular_progress.dart';
import '../models/countries.dart';
import 'university_info_page.dart';

class UniversitiesList extends StatefulWidget {
  final String country;

  const UniversitiesList({Key? key, required this.country}) : super(key: key);

  @override
  State<UniversitiesList> createState() => _UniversitiesListState();
}

class _UniversitiesListState extends State<UniversitiesList> {
  final TransactionWebClient _webClient = TransactionWebClient();
  final List<Countries> countries = CountryRepository.countries;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities in ${widget.country}'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<University>>(
        future: _webClient.findByCountry(widget.country),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              const Progress();
              break;
            case ConnectionState.waiting:
              const Progress();
              break;
            case ConnectionState.active:
              const Progress();
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final List<University> universities = snapshot.data!;
                countries[countries.indexWhere((c) => c.name == widget.country)]
                    .foundUniversities = universities.length;
                if (universities.isNotEmpty) {
                  return ListView.builder(
                    itemCount: universities.length,
                    itemBuilder: (context, index) {
                      final University university = universities[index];
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    UniversityInfoPage(university),
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
                return const CenteredMessage(
                    message: 'No universities found.',
                    icon: Icons.error_outline);
              }
              return const CenteredMessage(
                  message: 'No data found!', icon: Icons.warning);
          }
          return const Progress();
        },
      ),
    );
  }
}
