import 'package:flutter/material.dart';
import 'package:somos/controller/UserController.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/default/my_functions.dart';

class FavoriteStar extends StatefulWidget {
  FavoriteStar({
    @required this.model,
    this.hideAtDesfavorite = false,
    this.funcReload,
  });

  final UserModel model;

  final bool hideAtDesfavorite;

  final Function(dynamic) funcReload;

  @override
  _FavoriteStarState createState() => _FavoriteStarState();
}

class _FavoriteStarState extends State<FavoriteStar> {
  IconData _iconFavorite = Icons.star_border;

  UserController _userController = UserController();
  SearchUserViewModel _searchUserViewModel = SearchUserViewModel();

  _saveFavorite() async {
    if (_iconFavorite == Icons.star_border) {
      setState(() {
        widget.model.isFavorite = true;
      });
      _searchUserViewModel.nickname = widget.model.login;
      await _userController.insertFavorite(_searchUserViewModel).then((value) {
        if (value.message.isNotEmpty) {
          flutterToastDefault(value.message);
          widget.model.isFavorite = false;
        }
        setState(() {});
      });
    } else {
      setState(() {
        widget.model.isFavorite = false;
      });
      _searchUserViewModel.nickname = widget.model.login;
      await _userController.deleteFavorite(_searchUserViewModel).then((value) {
        if (value.message.isNotEmpty) {
          flutterToastDefault(value.message);
          widget.model.isFavorite = false;
        }
        if (widget.hideAtDesfavorite) widget.funcReload(dynamic);
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _iconFavorite = widget.model.isFavorite ? Icons.star : Icons.star_border;
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
