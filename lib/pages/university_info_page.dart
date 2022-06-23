import 'package:flutter/material.dart';
import 'package:worlduniversities/database/dao/university_dao.dart';

import '../models/university.dart';
import '../widgets/favorite_button.dart';

// Description of all data from university
class UniversityInfoPage extends StatelessWidget {
  final University
      university; //should this be final thought? I am changing the value of university in the build method.
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Country: ${university.country}',
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('State: ${university.state}'),
                Text('Alpha 2 Code: ${university.alpha2Code}'),
                Text('Domains: ${university.domains.toString()}'),
                Text('Webpages: ${university.webPages.toString()}'),
              ],
            ),
            FavoriteButton(university: university, daoUni: _daoUni),
          ],
        ),
      ),
    );
  }
}
