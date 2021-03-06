import 'package:flutter/material.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/view/UserDetails.dart';
import 'package:somos/view/default/my_widgets.dart';

class UserSimple extends StatefulWidget {
  UserSimple({
    @required this.model,
  });

  final UserModel model;

  @override
  _UserSimpleState createState() => _UserSimpleState();
}

class _UserSimpleState extends State<UserSimple> {
  _openUserDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return UserDetails(model: widget.model);
        },
      ),
    );
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
              Image.network(
                widget.model.avatarUrl,
                height: 50,
                width: 50,
              ),
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
            child: FavoriteStar(nickname: widget.model.login),
          ),
        ],
      ),
      onPressed: () {
        _openUserDetails();
      },
    );
  }
}
