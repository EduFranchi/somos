import 'dart:convert';

import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/ErrorViewModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:http/http.dart' as http;
import 'package:somos/view/default/my_functions.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  //GET User by API Github
  Future<ErrorViewModel> getListByAPI(
      SearchUserViewModel searchUserViewModel) async {
    ErrorViewModel errorViewModel = ErrorViewModel();

    bool byNickname = searchUserViewModel.login != null &&
        searchUserViewModel.login.trim() != "";

    try {
      String param = byNickname ? "/${searchUserViewModel.login.trim()}" : "";

      param += searchUserViewModel.qtdePerPage != null &&
              searchUserViewModel.qtdePerPage > 0
          ? "?per_page=${searchUserViewModel.qtdePerPage}"
          : "";
      String url = "$URL_API_DEFAULT$param";

      Map<String, String> headers = {
        'Accept': 'application/vnd.github.v3+json',
      };

      await http
          .get(
        url,
        headers: headers,
      )
          .then(
        (value) {
          var responseUser = json.decode(value.body);
          if (responseUser.runtimeType.toString() != "List<dynamic>" &&
              responseUser["message"] != null) {
            print("ERROR API: ${responseUser["message"]}");
            errorViewModel.message = responseUser["message"];
          } else {
            errorViewModel.list = List.generate(
              byNickname ? 1 : responseUser.length,
              (i) {
                return byNickname
                    ? UserModel.fromJson(responseUser)
                    : UserModel.fromJson(responseUser[i]);
              },
            );
          }
        },
      );
    } on Exception catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message =
          "Erro ao consultar.\nVerifique sua conexão com a internet!";
    }
    return errorViewModel;
  }

  //Insert Favorite local
  Future<ErrorViewModel> insertFavorite(UserModel userModel) async {
    ErrorViewModel errorViewModel = ErrorViewModel();
    try {
      final Database db = await getDatabase();

      await db.insert(
        TABLE_FAVORITE_USERS_NAME,
        userModel.toJson(),
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      errorViewModel.message = "Erro de banco de dados";
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao favoritar usuário";
    }
    return errorViewModel;
  }

  //Delete Favorite local
  Future<ErrorViewModel> deleteFavorite(
      SearchUserViewModel searchUserViewModel) async {
    ErrorViewModel errorViewModel =
        new ErrorViewModel(obj: searchUserViewModel);

    try {
      final Database db = await getDatabase();

      await db.delete(
        TABLE_FAVORITE_USERS_NAME,
        where: "login = ?",
        whereArgs: [searchUserViewModel.login],
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      errorViewModel.message = "Erro de banco de dados";
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao desfavoritar usuário";
    }
    return errorViewModel;
  }

  //Get Favorite List local
  Future<ErrorViewModel> getFavoriteList({String nickname = ""}) async {
    ErrorViewModel errorViewModel = ErrorViewModel();

    try {
      final Database db = await getDatabase();

      List<dynamic> whereArgs;
      String where;

      List<Map<String, dynamic>> maps;
      if (nickname != null && nickname.isNotEmpty) {
        where = "login = ?";
        whereArgs = List<dynamic>();
        whereArgs.add(nickname);
        maps = await db.query(
          TABLE_FAVORITE_USERS_NAME,
          where: where,
          whereArgs: whereArgs,
        );
      } else {
        maps = await db.query(TABLE_FAVORITE_USERS_NAME);
      }

      errorViewModel.list = List.generate(
        maps.length,
        (i) {
          UserModel userModelTemp = UserModel.fromJson(maps[i]);
          userModelTemp.isFavorite = true;
          return userModelTemp;
        },
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      errorViewModel.message = "Erro de banco de dados";
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao consultar favoritos";
    }
    return errorViewModel;
  }
}
