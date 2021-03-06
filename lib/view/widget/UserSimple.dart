import 'package:flutter/material.dart';
import 'package:somos/view/UserDetails.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_widgets.dart';

class UserSimple extends StatefulWidget {
  @override
  _UserSimpleState createState() => _UserSimpleState();
}

class _UserSimpleState extends State<UserSimple> {
  _openUserDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return UserDetails();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "${URL_IMAGE_DEFAULT}logo.png",
                height: 50,
                width: 50,
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
              Text(
                "EduFranchi",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Container(
            width: 30,
            height: 30,
            child: FavoriteStar(nickname: "EduFranchi"),
          ),
        ],
      ),
      onPressed: () {
        _openUserDetails();
      },
    );
  }
}
