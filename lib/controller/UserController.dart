import 'package:somos/model/view-model/SearchUserViewModel.dart';
import 'package:somos/repository/UserRepository.dart';
import 'package:somos/model/view-model/ErrorViewModel.dart';

class UserController {
  UserRepository repository;

  UserController() {
    repository = new UserRepository();
  }

  Future<ErrorViewModel> getUserList(SearchUserViewModel model) async {
    ErrorViewModel response = await repository.getListByAPI(model);
    if (response.message.isEmpty) {
      var response2 = await repository.getFavoriteList();
      if (response2.message.isEmpty) {
        response.list.forEach((element) {
          response2.list.forEach((element2) {
            if (element.login == element2.login) {
              element.isFavorite = true;
            }
          });
        });
      } else {
        response.message = response2.message;
      }
    } else if (response.list != null && response.list[0] != null) {
      response.message = "Erro ao favoritar usuário";
    }
    return response;
  }

  Future<ErrorViewModel> insertFavorite(SearchUserViewModel model) async {
    model.busy = true;
    var response = await getUserList(model);
    if (response.message.isEmpty && response.list[0] != null) {
      var response2 = await repository.insertFavorite(response.list[0]);
      response = response2;
    } else if (response.list != null && response.list[0] != null) {
      response.message = "Erro ao favoritar usuário";
    }
    model.busy = false;
    return response;
  }

  Future<ErrorViewModel> deleteFavorite(SearchUserViewModel model) async {
    model.busy = true;
    ErrorViewModel response = await repository.deleteFavorite(model);
    model.busy = false;
    return response;
  }

  Future<ErrorViewModel> getFavoriteList() async {
    ErrorViewModel response = await repository.getFavoriteList();
    return response;
  }

  /*Future<ErrorViewModel> create(CreateFolderViewModel model) async {
    model.busy = true;
    ErrorViewModel response = await repository.insert(model);
    model.busy = false;
    return response;
  }

  Future<ErrorViewModel> getFolderList({int folderId}) async {
    ErrorViewModel response = await repository.getList(folderId: folderId);
    return response;
  }

  Future<ErrorViewModel> delete(UpdateDeleteViewModel model) async {
    model.busy = true;

    PictureController pictureController = PictureController();
    UpdateDeleteViewModel modelPicture =
        UpdateDeleteViewModel(parentId: model.id);

    ErrorViewModel response = await pictureController.delete(modelPicture).then(
      (value) async {
        if (value.message.isNotEmpty) {
          return value;
        } else {
          return await repository.delete(model);
        }
      },
    );

    model.busy = false;

    return response;
  }*/
}
