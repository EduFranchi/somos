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
