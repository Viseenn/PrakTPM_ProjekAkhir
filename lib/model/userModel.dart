import 'package:hive_flutter/hive_flutter.dart';
part 'userModel.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  UserModel({required this.username, required this.password});

  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @override
  String toString() {
    return 'UserModel{username: $username, password: $password}';
  }
}
