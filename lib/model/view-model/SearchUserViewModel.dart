class SearchUserViewModel {
  String login;
  int qtdePerPage;
  bool busy;

  SearchUserViewModel({
    this.login,
    this.busy = false,
  });
}
