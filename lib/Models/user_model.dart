import 'package:message_wise/util.dart';

class UserModels {
  String uid;
  String? username;
  String email;
  String? photo;
  UserConnections state;
  UserModels(
      {required this.uid,
      required this.email,
      this.photo,
      this.username,
      required this.state});
}

class Profile {
  String uid;
  String? username;
  String email;
  String? photo;

  Profile({
    required this.uid,
    required this.email,
    this.photo,
    this.username,
  });
}
