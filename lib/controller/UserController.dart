import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/repository/UserRepository.dart';
import 'package:somos/model/view-model/ErrorViewModel.dart';

class UserController {
  UserRepository repository;

  UserController() {
    repository = new UserRepository();
  }

  Future<ErrorViewModel> getUserList(
      SearchUserViewModel searchUserViewModel) async {
    ErrorViewModel responseUser =
        await repository.getListByAPI(searchUserViewModel);
    if (responseUser.message.isEmpty) {
      var responseFavorite = await repository.getFavoriteList();
      if (responseFavorite.message.isEmpty) {
        responseUser.list.forEach((elementUserList) {
          responseFavorite.list.forEach((elementFavoriteList) {
            if (elementUserList.login == elementFavoriteList.login) {
              elementUserList.isFavorite = true;
            }
          });
        });
      } else {
        responseUser.message = responseFavorite.message;
      }
    } else if (responseUser.list != null && responseUser.list[0] != null) {
      responseUser.message = "Erro ao favoritar usuário";
    }
    return responseUser;
  }

  Future<ErrorViewModel> insertFavorite(
      SearchUserViewModel searchUserViewModel) async {
    searchUserViewModel.busy = true;
    var responseUser = await getUserList(searchUserViewModel);
    if (responseUser.message.isEmpty && responseUser.list[0] != null) {
      var responseFavorite =
          await repository.insertFavorite(responseUser.list[0]);
      responseUser = responseFavorite;
    } else if (responseUser.list != null && responseUser.list[0] != null) {
      responseUser.message = "Erro ao favoritar usuário";
    }
    searchUserViewModel.busy = false;
    return responseUser;
  }

  Future<ErrorViewModel> deleteFavorite(
      SearchUserViewModel searchUserViewModel) async {
    searchUserViewModel.busy = true;
    ErrorViewModel responseFavorite =
        await repository.deleteFavorite(searchUserViewModel);
    searchUserViewModel.busy = false;
    return responseFavorite;
  }

  Future<ErrorViewModel> getFavoriteList({String nickname = ""}) async {
    ErrorViewModel responseFavorite =
        await repository.getFavoriteList(nickname: nickname);
    return responseFavorite;
  }
}
