import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';

class FavoriteList extends StatefulWidget {
  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
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
            title: Text("Favoritos"),
            backgroundColor: Color(BG_COLOR_DEFAULT),
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
