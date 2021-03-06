import 'dart:convert';

import 'package:somos/model/UserModel.dart';
import 'package:somos/model/view-model/ErrorViewModel.dart';
import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<ErrorViewModel> getListByAPI(SearchUserViewModel model) async {
    ErrorViewModel errorViewModel = ErrorViewModel();

    bool byNickname = model.nickname != null && model.nickname.trim() != "";

    try {
      String param = byNickname ? "/${model.nickname.trim()}" : "";

      param += "?per_page=${model.qtdePerPage}";
      String url = "$URL_API_DEFAULT$param";

      Map<String, String> headers = {
        'Accept': 'application/vnd.github.v3+json',
      };
      print(url);
      await http
          .get(
        url,
        headers: headers,
      )
          .then(
        (value) {
          var response = json.decode(value.body);
          errorViewModel.list = List.generate(
            byNickname ? 1 : response.length,
            (i) {
              return byNickname
                  ? UserModel.fromJson(response)
                  : UserModel.fromJson(response[i]);
            },
          );
        },
      );
    } on Exception catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message =
          "Erro ao consultar.\nVerifique sua conexão com a internet!";
    }

    return errorViewModel;
  }
  //Insert
  /*Future<ErrorViewModel> insert(CreateFolderViewModel model) async {
    ErrorViewModel errorViewModel = ErrorViewModel();
    try {
      final Database db = await getDatabase();

      await db.insert(
        TABLE_FOLDER_NAME,
        model.toJson(),
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      if (e.getResultCode() == 2067) {
        errorViewModel.message = "Nome da pasta já cadastrada";
      } else {
        errorViewModel.message = "Erro de banco de dados";
      }
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao cadastrar";
    }
    return errorViewModel;
  }

  //Get List
  Future<ErrorViewModel> getList({int folderId}) async {
    ErrorViewModel errorViewModel = ErrorViewModel();

    try {
      final Database db = await getDatabase();

      List<dynamic> whereArgs;
      String where;
      if (folderId != null) {
        where = "id = ?";
        whereArgs = List<dynamic>();
        whereArgs.add(folderId);
      }

      final List<Map<String, dynamic>> maps = await db.query(
        TABLE_FOLDER_NAME,
        where: where,
        whereArgs: whereArgs,
      );

      //print(maps[0]);

      if (folderId != null && maps.length > 0) {
        errorViewModel.obj = FolderModel.fromJson(maps[0]);
      } else {
        errorViewModel.list = List.generate(
          maps.length,
          (i) {
            return FolderModel.fromJson(maps[i]);
          },
        );
      }
      errorViewModel.list = List.generate(
        maps.length,
        (i) {
          return FolderModel.fromJson(maps[i]);
        },
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      errorViewModel.message = "Erro de banco de dados";
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao consultar";
    }
    return errorViewModel;
  }

  //Update
  Future<ErrorViewModel> update(UpdateDeleteViewModel model) async {
    ErrorViewModel errorViewModel = new ErrorViewModel(obj: model);

    try {
      final Database db = await getDatabase();

      await db.update(
        TABLE_FOLDER_NAME,
        model.toJson(),
        where: "id = ?",
        whereArgs: [model.id],
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      errorViewModel.message = "Erro de banco de dados";
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao atualizar";
    }
    return errorViewModel;
  }

  //Delete
  Future<ErrorViewModel> delete(UpdateDeleteViewModel model) async {
    ErrorViewModel errorViewModel = new ErrorViewModel(obj: model);

    try {
      final Database db = await getDatabase();

      await db.delete(
        TABLE_FOLDER_NAME,
        where: "id = ?",
        whereArgs: [model.id],
      );
    } on DatabaseException catch (e) {
      print("ERROR DatabaseException: $e");
      errorViewModel.message = "Erro de banco de dados";
    } catch (e) {
      print("ERROR Exception: $e");
      errorViewModel.message = "Erro ao excluir";
    }
    return errorViewModel;
  }*/
}
