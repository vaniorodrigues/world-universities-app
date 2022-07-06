import 'package:flutter/material.dart';
import 'package:worlduniversities/database/dao/university_dao.dart';
import 'package:worlduniversities/models/university.dart';
import 'package:worlduniversities/widgets/favorite_button.dart';

class UniversityListViewBuilder extends StatefulWidget {
  const UniversityListViewBuilder({
    Key? key,
    required this.universities,
    required this.daoUni,
    required this.onClick,
  }) : super(key: key);

  final List<University> universities;
  final UniversityDao daoUni;
  final Function onClick;

  @override
  State<UniversityListViewBuilder> createState() => UniversityListViewBuilderState();
}

class UniversityListViewBuilderState extends State<UniversityListViewBuilder> {
  final TextEditingController searchController = TextEditingController();
  bool _toggle = false;
  List<University> universities = [];

  @override
  Widget build(BuildContext context) {
    (_toggle)
        ? universities = widget.universities.where((university) => university.isFavorite == 1).toList()
        : universities = widget.universities;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
          child: SwitchListTile(
            value: _toggle,
            title: const Text('Only Show Favorites'),
            secondary: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            activeColor: Colors.red,
            onChanged: (bool value) {
              setState(() => _toggle = value);
            },
          ),
        ),
        _UniversityListView(universities: universities, widget: widget),
      ],
    );
  }
}

class _UniversityListView extends StatelessWidget {
  const _UniversityListView({
    Key? key,
    required this.universities,
    required this.widget,
  }) : super(key: key);

  final List<University> universities;
  final UniversityListViewBuilder widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 200,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: universities.length,
          itemBuilder: (context, index) {
            final University university = universities[index];
            return Card(
              child: ListTile(
                trailing: FavoriteButton(university: university, daoUni: widget.daoUni),
                onTap: () {
                  widget.onClick(university);
                },
                title: Text(
                  university.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                subtitle: Text(
                  'State/Province: ${university.state}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
