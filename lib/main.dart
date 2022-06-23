import 'package:flutter/material.dart';

import 'pages/countries_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CountriesListPage(),
    );
  }
}


// Project guidelines:
// 1. The app must have 3 pages 
// - First with list of countries in south america, with the number of universities of each country. Initialia all coutries must countain 0.
// 2. Load the universities of each country in the second page from public api. Once load, it must be stoared locally in the database, and open the list sorted in alphabetical order.
// FIXME: 2.5: This page should have a field search for name/city and a filter to order by city/state name
// FIXME: 2.6: university_info should rederect to website of university from domains.
// 3. The third page must show the universities of the selected country, espeacilly with the URL of the university which must be clickable to open the website
// 4. Each line must exibit the name of the university a favorite icon
// 5. The favorite icon must be clickable to add or remove the university from the favorite list.
// 6. All information must be saves locally in the database, to persist even when the app closes. 