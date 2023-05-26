import 'package:hive_flutter/adapters.dart';
import 'package:project_visen/model/userModel.dart';
import 'package:project_visen/service/shared_preference.dart';

class DatabaseHelper {
  static final Box<UserModel> _database = Hive.box<UserModel>("user");

  void addData(UserModel user) {
    _database.add(user);
  }

  int getLength() {
    return _database.length;
  }

  bool cekLogin(String username, String password) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _database.getAt(i)!.username &&
          password == _database.getAt(i)!.password) {
        SharedPreference().setLogin(username);
        print("Login Berhasil");
        found = true;
        break;
      } else {
        found = false;
      }
    }
    return found;
  }

  String? getHashedPassword(String username) {
    for (int i = 0; i < getLength(); i++) {
      if (username == _database.getAt(i)!.username) {
        return _database.getAt(i)!.password;
      }
    }
    return null; // Return null if the username is not found
  }
}
