import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somos/view/OpenPicture.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';

class UserDetails extends StatefulWidget {
  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  _openPicture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return OpenPicture();
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
            title: Text("Detalhes do Usuário"),
            backgroundColor: Color(BG_COLOR_DEFAULT),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              color: Colors.white,
              height:
                  screenSize(context).height - safeAreaSize(context).top - 56,
              width: screenSize(context).width,
              child: Column(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(
                        "${URL_IMAGE_DEFAULT}logo.png",
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: FavoriteStar(nickname: "EduFranchi"),
                        ),
                      ),
                    ),
                    onTap: () {
                      _openPicture();
                    },
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    "EduFranchi",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "eduardoafdo@hotmail.com",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "Londrina/PR - BR",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
