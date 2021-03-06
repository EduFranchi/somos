import 'package:flutter/material.dart';
import 'package:somos/controller/UserController.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/default/my_functions.dart';

class FavoriteStar extends StatefulWidget {
  FavoriteStar({
    @required this.model,
  });

  final UserModel model;

  @override
  _FavoriteStarState createState() => _FavoriteStarState();
}

class _FavoriteStarState extends State<FavoriteStar> {
  IconData _iconFavorite = Icons.star_border;

  UserController _userController = UserController();
  SearchUserViewModel _searchUserViewModel = SearchUserViewModel();

  _saveFavorite() async {
    setState(() {});
    if (_iconFavorite == Icons.star_border) {
      setState(() {
        _iconFavorite = Icons.star;
      });
      _searchUserViewModel.nickname = widget.model.login;
      await _userController.insertFavorite(_searchUserViewModel).then((value) {
        if (value.message.isNotEmpty) {
          flutterToastDefault(value.message);
          _iconFavorite = Icons.star_border;
        }
        setState(() {});
      });
    } else {
      setState(() {
        _iconFavorite = Icons.star_border;
      });
      _searchUserViewModel.nickname = widget.model.login;
      await _userController.deleteFavorite(_searchUserViewModel).then((value) {
        if (value.message.isNotEmpty) {
          flutterToastDefault(value.message);
          _iconFavorite = Icons.star;
        }
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _iconFavorite = widget.model.isFavorite ? Icons.star : Icons.star_border;
  }

  @override
  Widget build(BuildContext context) {
    return _searchUserViewModel.busy
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.yellow.shade600,
              ),
            ),
          )
        : GestureDetector(
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
