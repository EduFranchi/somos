import 'package:flutter/material.dart';

class FavoriteStar extends StatefulWidget {
  FavoriteStar({
    @required this.nickname,
  });

  final String nickname;

  @override
  _FavoriteStarState createState() => _FavoriteStarState();
}

class _FavoriteStarState extends State<FavoriteStar> {
  IconData _iconFavorite = Icons.star_border;

  _saveFavorite() {
    if (_iconFavorite == Icons.star_border) {
      setState(() {
        _iconFavorite = Icons.star;
      });
    } else {
      setState(() {
        _iconFavorite = Icons.star_border;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        _iconFavorite,
        size: 30,
        color: Colors.yellow.shade600,
      ),
      onTap: () {
        _saveFavorite();
      },
    );
  }
}
