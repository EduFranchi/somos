import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somos/controller/UserController.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';

class FavoriteList extends StatefulWidget {
  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  UserController _userController = UserController();
  List<UserModel> _listUserModel = List<UserModel>();
  List<UserModel> _listUserModelShow = List<UserModel>();
  bool _busy = false;
  TextEditingController _controllerSearch = TextEditingController();

  _getFavoriteList() async {
    setState(() {
      _busy = true;
    });
    var responseFavorite = await _userController.getFavoriteList();
    if (responseFavorite.message.isEmpty) {
      _listUserModel = List.generate(
        responseFavorite.list.length,
        (i) {
          return responseFavorite.list[i];
        },
      );
      _listUserModelShow = List.generate(
        responseFavorite.list.length,
        (i) {
          return responseFavorite.list[i];
        },
      );
    } else {
      flutterToastDefault(responseFavorite.message);
    }
    setState(() {
      _busy = false;
    });
  }

  _searchUserList(String text) {
    _listUserModelShow.clear();
    _listUserModel.forEach((elementUser) {
      if (elementUser.login.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          _listUserModelShow.add(elementUser);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getFavoriteList();
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
                    controller: _controllerSearch,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      labelText: "Pesquisar",
                      alignLabelWithHint: true,
                    ),
                    onChanged: (valueTextFiel) {
                      if (valueTextFiel.length > 0) {
                        _searchUserList(valueTextFiel);
                      } else {
                        _listUserModelShow.clear();
                        _listUserModel.forEach((elementUser) {
                          _listUserModelShow.add(elementUser);
                        });
                      }
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                ),
                (_busy
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: (screenSize(context).height -
                                    safeAreaSize(context).top -
                                    56 -
                                    25) /
                                3),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(BG_COLOR_DEFAULT),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                          itemCount: _listUserModelShow.length,
                          itemBuilder: (_, index) {
                            return UserSimple(
                              userModel: _listUserModelShow[index],
                              funcReload: (_) {
                                _getFavoriteList();
                              },
                              hideAtDesfavorite: true,
                            );
                          },
                          separatorBuilder: (_, index) {
                            return SizedBox(
                              height: 1,
                              width: double.infinity,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8E8E8),
                                ),
                              ),
                            );
                          },
                        ),
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
