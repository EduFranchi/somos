import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';
import 'package:somos/view/FavoriteList.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  _openFavoriteList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return FavoriteList();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Usuários Github"),
            backgroundColor: Color(BG_COLOR_DEFAULT),
            actions: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black,
                child: FlatButton(
                  padding: EdgeInsets.zero,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.star,
                    color: Colors.yellow.shade600,
                    size: 30,
                  ),
                  onPressed: () {
                    _openFavoriteList();
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 10)),
            ],
          ),
          body: Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.white,
            height: screenSize(context).height,
            width: screenSize(context).width,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    //controller: _controllerSearch,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: "Pesquisar",
                      alignLabelWithHint: true,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: 30,
                    itemBuilder: (_, index) {
                      return UserSimple();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
