import 'package:flutter/material.dart';

import '../database/dao/university_dao.dart';
import '../models/university.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    Key? key,
    required this.university,
    required UniversityDao daoUni,
  })  : _daoUni = daoUni,
        super(key: key);

  final University university;
  final UniversityDao _daoUni;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        (widget.university.isFavorite == 1)
            ? widget.university.isFavorite = 0
            : widget.university.isFavorite = 1;
        widget._daoUni.updateFavorite(widget.university);
        setState(() {
          // widget.university.isFavorite;
        });
      },
      child: (widget.university.isFavorite == 1)
          ? const Icon(Icons.favorite, color: Colors.red, size: 24)
          : const Icon(Icons.favorite_border, color: Colors.red, size: 24),
      // Icon(Icons.favorite_border_sharp),
    );
  }
}
