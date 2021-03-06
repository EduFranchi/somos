class UserModel {
  int id;
  String avatarUrl;
  String login;
  String email;
  String location;
  String bio;

  UserModel({
    this.id,
    this.avatarUrl,
    this.login,
    this.email,
    this.location,
    this.bio,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatarUrl = json['avatar_url'];
    login = json['login'];
    email = json['email'];
    location = json['location'];
    bio = json['bio'];
  }
}
