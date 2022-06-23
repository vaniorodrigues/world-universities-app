import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:worlduniversities/database/dao/university_dao.dart';
import 'package:worlduniversities/models/university.dart';
import 'package:worlduniversities/widgets/favorite_button.dart';

class UniversityInfoPage extends StatelessWidget {
  final University university;
  final UniversityDao _daoUni = UniversityDao();

  UniversityInfoPage(this.university, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('UniversityInfoPage --> university: ${university.toString()}');
    return Scaffold(
      appBar: AppBar(
        title: Text(university.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Country: ${university.country}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FavoriteButton(university: university, daoUni: _daoUni),
              ],
            ),
            Text('State: ${university.state}'),
            Text('Domains: ${university.domains[0]}'),
            Text('Webpages: ${university.webPages[0]}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Webpages:'),
                Column(
                  children: (university.webPages
                      .map<Widget>((e) => GestureDetector(
                            child: Text(e),
                            onTap: () => {_launchUrl(e)},
                          ))
                      .toList()),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () => {_launchUrl(university.webPages[0])},
                child: const Text('Abrir google')),
          ],
        ),
      ),
    );
  }

  _launchUrl(String url) async {
    debugPrint('==============>Trying to open url: $url');
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
