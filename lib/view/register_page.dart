import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:project_visen/model/userModel.dart';
import 'package:project_visen/service/database_helper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  bool isHidden = true;

  final DatabaseHelper databaseHive = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Card(
            elevation: 30,
            shadowColor: Colors.black,
            color: Colors.white,
            margin: EdgeInsets.all(40),
            child: Column(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 0),
                    child: Center(
                      child: Image.asset(
                        "assets/news.png",
                        width: 300,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 60),
                    child: Center(
                      child: usernameField(),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 60),
                    child: Center(
                      child: passwordField(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 0, left: 100, right: 100, top: 20),
                    child: Center(
                      child: loginButton(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget usernameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        controller: username_controller,
        decoration: InputDecoration(
          fillColor: Colors.blue,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          labelText: "Username",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Username tidak boleh kosong";
          }
          return null;
        },
      ),
    );
  }

  Widget passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        controller: password_controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                isHidden = !isHidden;
              });
            },
            child: Icon(
              isHidden ? Icons.visibility_off : Icons.visibility,
              color: isHidden ? Colors.grey : Colors.blue,
            ),
          ),
          labelText: 'Password',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Password tidak boleh kosong";
          }
          return null;
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: prosesDaftar,
        child: const Text('Daftar'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          onPrimary: Colors.white,
          shape: StadiumBorder(),
        ),
      ),
    );
  }

  void prosesDaftar() async {
    final String username = username_controller.text;
    final String password = password_controller.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      final enkripPassword = sha256.convert(utf8.encode(password)).toString();
      databaseHive.addData(UserModel(username: username, password: enkripPassword));
      username_controller.clear();
      password_controller.clear();
      print(username);
      print(enkripPassword);
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green,
                ),
                SizedBox(height: 20),
                Text(
                  'Berhasil Mendaftar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginPage();
                        },
                      ),
                    );
                  },
                  child: Text('OK'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Daftar Gagal'),
          content: const Text('Username dan Password harus diisi.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
