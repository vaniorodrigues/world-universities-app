import 'package:flutter/material.dart';

import '../models/universities.dart';

// Description of all data from university
class UniversityInfoPage extends StatelessWidget {
  final University university;

  const UniversityInfoPage(this.university, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(university.name),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Country: ${university.country}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('State: ${university.state!}'),
            Text('Alpha 2 Code: ${university.alpha2Code}'),
            Text('Domains: ${university.domains.toString()}'),
            Text('Webpages: ${university.webPages.toString()}'),
          ],
        ),
      ),
    );
  }
}
