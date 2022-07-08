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
  List<University> universities = [];
  bool _toggle = false;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    (firstTime) ? universities = widget.universities : null;
    firstTime = false;
    return Column(
      children: [
        _ToggleFavorites(
          toggle: _toggle,
          onChanged: (bool value) {
            setState(
              () {
                _toggle = value;
                (_toggle)
                    ? universities = universities.where((university) => university.isFavorite == 1).toList()
                    : universities = widget.universities;
              },
            );
          },
        ),
        _SearchBar(
          searchController: searchController,
          onPressed: () {
            setState(
              () => universities = widget.universities,
            );
          },
          onChanged: (value) {
            setState(
              () => universities = widget.universities
                  .where((university) => university.name.toLowerCase().contains(value.toLowerCase()))
                  .toList(),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '${universities.length} universities found',
              style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ),
        _UniversityListView(universities: universities, widget: widget),
      ],
    );
  }
}

class _ToggleFavorites extends StatelessWidget {
  const _ToggleFavorites({
    Key? key,
    required bool toggle,
    required this.onChanged,
  })  : _toggle = toggle,
        super(key: key);

  final bool _toggle;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
      child: SwitchListTile(
        value: _toggle,
        title: const Text('Only Show Favorites'),
        secondary: const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
        activeColor: Colors.red,
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    Key? key,
    required this.searchController,
    required this.onPressed,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController searchController;
  final Function onPressed;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 0.0),
      child: Card(
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            icon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.all(8.0),
            labelText: 'Search',
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                onPressed();
              },
            ),
          ),
          onChanged: (value) => onChanged(value),
        ),
      ),
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
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
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
