import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:somos/controller/UserController.dart';
import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/OpenPicture.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:somos/view/default/my_functions.dart';
import 'package:somos/view/default/my_widgets.dart';

class UserDetails extends StatefulWidget {
  UserDetails({
    @required this.userModel,
    this.hideAtDesfavorite = false,
  });

  final UserModel userModel;

  final bool hideAtDesfavorite;

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  UserController _userController = UserController();
  SearchUserViewModel _searchUserViewModel = SearchUserViewModel();
  UserModel _userModel = UserModel();
  bool _connectedInternet = false;

  _openPicture() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return OpenPicture(avatarUrl: _userModel.avatarUrl);
        },
      ),
    );
  }

  _getUserList() {
    setState(() {
      _searchUserViewModel.busy = true;
    });
    _userController.getUserList(_searchUserViewModel).then((responseUser) {
      if (responseUser.message.isEmpty) {
        _userModel = responseUser.list[0];
        setState(() {
          _searchUserViewModel.busy = false;
        });
      } else if (responseUser.list[0] == null) {
        flutterToastDefault(
            "Usuário não encontrado!\nVerifique sua conexão com a internet.");
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
      print(e);
      flutterToastDefault(e);
    });
  }

  _getFavoriteSingle() async {
    setState(() {
      _searchUserViewModel.busy = true;
    });
    var responseFavorite =
        await _userController.getFavoriteList(nickname: widget.userModel.login);
    if (responseFavorite.message.isEmpty) {
      _userModel = responseFavorite.list[0];
    } else {
      flutterToastDefault(responseFavorite.message);
    }
    setState(() {
      _searchUserViewModel.busy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkConnectionInternet().then((value) => _connectedInternet = value);
    if (widget.userModel != null && widget.userModel.login.isNotEmpty) {
      _searchUserViewModel.login = widget.userModel.login;
      checkConnectionInternet().then((value) {
        if (value) {
          _getUserList();
        } else {
          _getFavoriteSingle();
        }
      });
    } else {
      flutterToastDefault("Usuário não encontrado!");
      Navigator.pop(context);
    }
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
              child: _searchUserViewModel.busy
                  ? Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: (screenSize(context).height -
                                      safeAreaSize(context).top -
                                      56 -
                                      25) /
                                  2),
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(BG_COLOR_DEFAULT),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: _userModel.avatarUrl != null &&
                                    _connectedInternet
                                ? NetworkImage(
                                    _userModel.avatarUrl,
                                  )
                                : AssetImage("${URL_IMAGE_DEFAULT}logo.png"),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 30,
                                height: 30,
                                child: FavoriteStar(
                                  userModel: _userModel,
                                  hideAtDesfavorite: widget.hideAtDesfavorite,
                                  funcReload: (_) {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (_connectedInternet) _openPicture();
                          },
                        ),
                        Padding(padding: EdgeInsets.only(top: 20)),
                        _userModel.login != null
                            ? Column(
                                children: [
                                  Text(
                                    _userModel.login,
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10))
                                ],
                              )
                            : Container(),
                        _userModel.email != null
                            ? Column(
                                children: [
                                  Text(
                                    _userModel.email,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10))
                                ],
                              )
                            : Container(),
                        _userModel.location != null
                            ? Column(
                                children: [
                                  Text(
                                    _userModel.location,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 10))
                                ],
                              )
                            : Container(),
                        _userModel.bio != null
                            ? Text(
                                _userModel.bio,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.justify,
                              )
                            : Container(),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
