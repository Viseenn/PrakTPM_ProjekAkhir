import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  final Future<SharedPreferences> _sharedpref = SharedPreferences.getInstance();

  void setLogin(String username) async {
    SharedPreferences getPref = await _sharedpref;
    getPref.setBool('isLogin', true);
    getPref.setString('username', username);
  }

  void setLogout() async {
    SharedPreferences getPref = await _sharedpref;
    getPref.setBool('isLogin', false);
    getPref.remove('username');
  }

  Future<String> getUsername() async {
    SharedPreferences getSharedPref = await _sharedpref;
    String username =
        getSharedPref.getString('username') ?? 'Data tidak ditemukan';
    return username;
  }

  Future<bool> getLoginStatus() async {
    SharedPreferences getSharedPref = await _sharedpref;
    bool status_login = getSharedPref.getBool('isLogin') ?? false;
    return status_login;
  }
}
