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
    );
  }

  _getUserList() {
    setState(() {
      _searchUserViewModel.busy = true;
    });
    _searchUserViewModel.nickname = _controllerSearch.text.trim();
    _userController.getUserList(_searchUserViewModel).then((value) {
      if (value.message.isEmpty) {
        _listUserModel = List.generate(
          value.list.length,
          (i) {
            return value.list[i];
          },
        );
        _listUserModelShow = List.generate(
          value.list.length,
          (i) {
            return value.list[i];
          },
        );
        setState(() {
          _searchUserViewModel.busy = false;
        });
      } else {
        flutterToastDefault(value.message);
        setState(() {
          _searchUserViewModel.busy = false;
        });
      }
    }).catchError((e) {
      print(e);
      flutterToastDefault(e);
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
          "onTap": () {},
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
                  labelText: "Qtde. por Página",
                  alignLabelWithHint: true,
                ),
                onTap: () => _controllerQtdePerPage.text = "",
                onChanged: (value) {
                  int temp = int.tryParse(value);
                  if (temp.runtimeType == int)
                    _searchUserViewModel.qtdePerPage = int.tryParse(value);
                  else
                    flutterToastDefault("Digite apenas números inteiros");
                },
              ),
            ),
          ],
        ),
      ),
    );
    dialog.build();
  }

  _searchUserList(String value) {
    _listUserModelShow.clear();
    _listUserModel.forEach((element) {
      if (element.login.toLowerCase().contains(value.toLowerCase())) {
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
                      onChanged: (value) {
                        if (value.length > 0) {
                          _searchUserList(value);
                        } else {
                          _listUserModelShow.clear();
                          _listUserModel.forEach((element) {
                            _listUserModelShow.add(element);
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
                                  model: _listUserModelShow[index]);
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
