import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';
import 'package:somos/view/FavoriteList.dart';
import 'package:somos/controller/UserController.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  UserController _userController = UserController();
  SearchUserViewModel _searchUserViewModel = SearchUserViewModel();
  List<UserModel> _listUserModel = List<UserModel>();
  List<UserModel> _listUserModelShow = List<UserModel>();

  TextEditingController _controllerSearch = TextEditingController();
  MaskedTextController _controllerQtdePerPage = MaskedTextController(
    mask: "000000000",
  );

  _openFavoriteList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return FavoriteList();
        },
      ),
    ).then((value) => _getUserList());
  }

  _getUserList() {
    setState(() {
      _searchUserViewModel.busy = true;
    });
    _searchUserViewModel.login = _controllerSearch.text.trim();
    _userController.getUserList(_searchUserViewModel).then((responseUser) {
      if (responseUser.message.isEmpty) {
        _listUserModel = List.generate(
          responseUser.list.length,
          (i) {
            return responseUser.list[i];
          },
        );
        _listUserModelShow = List.generate(
          responseUser.list.length,
          (i) {
            return responseUser.list[i];
          },
        );
        setState(() {
          _searchUserViewModel.busy = false;
        });
      } else {
        flutterToastDefault(responseUser.message);
        setState(() {
          _searchUserViewModel.busy = false;
        });
      }
    }).catchError((e) {
      print(e.toString());
      flutterToastDefault(e.toString());
      setState(() {
        _searchUserViewModel.busy = false;
      });
    });
  }

  _showModalFilter() {
    ShowDialogDefault dialog = ShowDialogDefault(
      context: context,
      barrierDismissible: true,
      title: "Filtrar",
      buttonList: [
        {
          "text": "Ok",
          "type": 0,
          "dismissBefore": true,
          "dismissAfter": false,
          "onTap": () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        },
      ],
      content: Container(
        width: double.infinity,
        height: 50,
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _controllerQtdePerPage,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  labelText: "Qtde. por P??gina",
                  alignLabelWithHint: true,
                ),
                onTap: () => _controllerQtdePerPage.text = "",
                onChanged: (valueTextField) {
                  int checkParseInt = int.tryParse(valueTextField);
                  if (checkParseInt.runtimeType == int)
                    _searchUserViewModel.qtdePerPage =
                        int.tryParse(valueTextField);
                  else
                    flutterToastDefault("Digite apenas n??meros inteiros");
                },
              ),
            ),
          ],
        ),
      ),
    );
    dialog.build();
  }

  _searchUserList(String text) {
    _listUserModelShow.clear();
    _listUserModel.forEach((element) {
      if (element.login.toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          _listUserModelShow.add(element);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _searchUserViewModel.qtdePerPage = 30;
    _controllerQtdePerPage.text = _searchUserViewModel.qtdePerPage.toString();
    _getUserList();
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
            title: Text("Usu??rios Github"),
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
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 10),
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
                      onChanged: (valueTextField) {
                        if (valueTextField.length > 0) {
                          _searchUserList(valueTextField);
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 35,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: Icon(Icons.filter_alt_outlined),
                            onPressed: () {
                              _showModalFilter();
                            },
                          ),
                        ),
                        Container(
                          width: 35,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            child: Icon(Icons.search),
                            onPressed: () {
                              _getUserList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  (_searchUserViewModel.busy
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
                                  _getUserList();
                                },
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
      ),
    );
  }
}
