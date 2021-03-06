class UserModel {
  int id;
  String avatarUrl;
  String login;
  String email;
  String location;
  String bio;
  bool isFavorite = false;

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
    avatarUrl =
        json['avatar_url'] != null ? json['avatar_url'] : json['avatarUrl'];
    login = json['login'];
    email = json['email'];
    location = json['location'];
    bio = json['bio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatarUrl'] = this.avatarUrl;
    data['login'] = this.login;
    data['email'] = this.email;
    data['location'] = this.location;
    data['bio'] = this.bio;
    return data;
  }
}
