import 'package:flutter/material.dart';
import 'package:somos/controller/UserController.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/default/my_functions.dart';

class FavoriteStar extends StatefulWidget {
  FavoriteStar({
    @required this.userModel,
    this.hideAtDesfavorite = false,
    this.funcReload,
  });

  final UserModel userModel;

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
        widget.userModel.isFavorite = true;
      });
      _searchUserViewModel.login = widget.userModel.login;
      var responseInsertFavorite =
          await _userController.insertFavorite(_searchUserViewModel);
      if (responseInsertFavorite.message.isNotEmpty) {
        flutterToastDefault(responseInsertFavorite.message);
        widget.userModel.isFavorite = false;
      }
      setState(() {});
    } else {
      setState(() {
        widget.userModel.isFavorite = false;
      });
      _searchUserViewModel.login = widget.userModel.login;
      var responseDeleteFavorite =
          await _userController.deleteFavorite(_searchUserViewModel);
      if (responseDeleteFavorite.message.isNotEmpty) {
        flutterToastDefault(responseDeleteFavorite.message);
        widget.userModel.isFavorite = false;
      }
      if (widget.hideAtDesfavorite) widget.funcReload(dynamic);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _iconFavorite =
        widget.userModel.isFavorite ? Icons.star : Icons.star_border;
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
