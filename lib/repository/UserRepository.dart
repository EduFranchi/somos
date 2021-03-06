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
  Future<ErrorViewModel> getListByAPI(SearchUserViewModel model) async {
    ErrorViewModel errorViewModel = ErrorViewModel();

    bool byNickname = model.nickname != null && model.nickname.trim() != "";

    try {
      String param = byNickname ? "/${model.nickname.trim()}" : "";

      param += model.qtdePerPage != null && model.qtdePerPage > 0
          ? "?per_page=${model.qtdePerPage}"
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
          var response = json.decode(value.body);
          if (response.runtimeType.toString() != "List<dynamic>" &&
              response["message"] != null) {
            print("ERROR API: ${response["message"]}");
            errorViewModel.message = response["message"];
          } else {
            errorViewModel.list = List.generate(
              byNickname ? 1 : response.length,
              (i) {
                return byNickname
                    ? UserModel.fromJson(response)
                    : UserModel.fromJson(response[i]);
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
  Future<ErrorViewModel> insertFavorite(UserModel model) async {
    ErrorViewModel errorViewModel = ErrorViewModel();
    try {
      final Database db = await getDatabase();

      await db.insert(
        TABLE_FAVORITE_USERS_NAME,
        model.toJson(),
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
  Future<ErrorViewModel> deleteFavorite(SearchUserViewModel model) async {
    ErrorViewModel errorViewModel = new ErrorViewModel(obj: model);

    try {
      final Database db = await getDatabase();

      await db.delete(
        TABLE_FAVORITE_USERS_NAME,
        where: "login = ?",
        whereArgs: [model.nickname],
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
  Future<ErrorViewModel> getFavoriteList() async {
    ErrorViewModel errorViewModel = ErrorViewModel();

    try {
      final Database db = await getDatabase();

      final List<Map<String, dynamic>> maps = await db.query(
        TABLE_FAVORITE_USERS_NAME,
      );

      errorViewModel.list = List.generate(
        maps.length,
        (i) {
          return UserModel.fromJson(maps[i]);
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
