import 'package:flutter/material.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/view/UserDetails.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';

class UserSimple extends StatefulWidget {
  UserSimple({
    @required this.model,
    @required this.funcReload,
    this.hideAtDesfavorite = false,
  });

  final UserModel model;

  final Function(dynamic) funcReload;

  final bool hideAtDesfavorite;

  @override
  _UserSimpleState createState() => _UserSimpleState();
}

class _UserSimpleState extends State<UserSimple> {
  bool _connected = false;

  _openUserDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return UserDetails(
            model: widget.model,
            hideAtDesfavorite: widget.hideAtDesfavorite,
          );
        },
      ),
    ).then(widget.funcReload);
  }

  @override
  void initState() {
    super.initState();
    checkConnectionInternet().then((value) {
      setState(() {
        _connected = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (_connected
                  ? Image.network(
                      widget.model.avatarUrl,
                      height: 50,
                      width: 50,
                    )
                  : Image.asset(
                      "${URL_IMAGE_DEFAULT}logo.png",
                      height: 50,
                      width: 50,
                    )),
              Padding(padding: EdgeInsets.only(right: 10)),
              Text(
                widget.model.login,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Container(
            width: 30,
            height: 30,
            child: FavoriteStar(
              model: widget.model,
              hideAtDesfavorite: widget.hideAtDesfavorite,
              funcReload: widget.funcReload,
            ),
          ),
        ],
      ),
      onPressed: () {
        _openUserDetails();
      },
    );
  }
}
