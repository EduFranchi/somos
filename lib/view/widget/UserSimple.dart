import 'package:flutter/material.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/view/UserDetails.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';

class UserSimple extends StatefulWidget {
  UserSimple({
    @required this.userModel,
    @required this.funcReload,
    this.hideAtDesfavorite = false,
  });

  final UserModel userModel;

  final Function(dynamic) funcReload;

  final bool hideAtDesfavorite;

  @override
  _UserSimpleState createState() => _UserSimpleState();
}

class _UserSimpleState extends State<UserSimple> {
  bool _connectedInternet = false;

  _openUserDetails() {
    if (_connectedInternet || widget.hideAtDesfavorite) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return UserDetails(
              userModel: widget.userModel,
              hideAtDesfavorite: widget.hideAtDesfavorite,
            );
          },
        ),
      ).then(widget.funcReload);
    } else {
      flutterToastDefault("Verifique sua conexão com a internet");
    }
  }

  @override
  void initState() {
    super.initState();
    checkConnectionInternet().then((responseConnetion) {
      setState(() {
        _connectedInternet = responseConnetion;
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
              (_connectedInternet
                  ? Image.network(
                      widget.userModel.avatarUrl,
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
                widget.userModel.login,
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
              userModel: widget.userModel,
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
