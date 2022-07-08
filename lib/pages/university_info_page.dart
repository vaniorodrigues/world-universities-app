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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Searchbar textfield to search for universities by name

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(
                    university.name,
                    overflow: TextOverflow.clip,
                    // softWrap: true,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FavoriteButton(university: university, daoUni: _daoUni),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'State: ${university.state}',
                style: const TextStyle(fontSize: 20.0, overflow: TextOverflow.ellipsis),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Country: ${university.country}',
                style: const TextStyle(fontSize: 20.0, overflow: TextOverflow.ellipsis),
              ),
            ),
            _UrlRow(urls: university.domains, title: 'Domains'),
            _UrlRow(urls: university.webPages, title: 'Webpages'),
          ],
        ),
      ),
    );
  }
}

class _UrlRow extends StatelessWidget {
  const _UrlRow({
    Key? key,
    required this.urls,
    required this.title,
  }) : super(key: key);

  // final University university;
  final List<String> urls;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20.0, overflow: TextOverflow.ellipsis),
          ),
          Column(
            children: (urls
                .map<Widget>((e) => GestureDetector(
                      child: Text(e),
                      onTap: () => {_launchUrl(e)},
                    ))
                .toList()),
          ),
        ],
      ),
    );
  }

  _launchUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
