import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:project_visen/service/database_helper.dart';
import 'package:project_visen/view/register_page.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true;
  bool isHidden = true;

  final _formKey = GlobalKey<FormState>(); //validasi form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        key: _formKey,
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
                    padding: const EdgeInsets.only(top: 20),
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
                      const Text("Belum punya akun?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text('Daftar'),
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
        controller: usernameController,
        decoration: InputDecoration(
          fillColor: Colors.teal,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(
              color: Colors.teal,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: isLogin ? Colors.teal : Colors.red),
          ),
          labelText: "Username",
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Username tidak boleh kosong";
          }
        },
      ),
    );
  }

  Widget passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        enabled: true,
        controller: passwordController,
        obscureText: isHidden,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.teal),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: isLogin ? Colors.teal : Colors.red),
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
    return _submitButton(
      labelButton: "Login",
      submitCallback: (value) {
        String currentUsername = usernameController.value.text;
        String currentPassword = passwordController.value.text;

        prosesLogin(currentUsername, currentPassword);
      },
    );
  }

  Widget _submitButton({
    required String labelButton,
    required Function(String) submitCallback,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          submitCallback(labelButton);
        },
        child: const Text('Login'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
          primary: isLogin ? Colors.teal : Colors.red,
          onPrimary: Colors.white,
          shape: StadiumBorder(),
        ),
      ),
    );
  }

  void prosesLogin(String username, String password) async {
    final DatabaseHelper databaseHive = DatabaseHelper();
    final enkripPassword = sha256.convert(utf8.encode(password)).toString();
    bool found = false;

    found = databaseHive.cekLogin(username, password);

    String? hashedPassword = databaseHive.getHashedPassword(username);

    if (hashedPassword != null) {
      if (enkripPassword == hashedPassword) {
        found = true;
      }
    }

    if (!found) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Gagal'),
          content: const Text('Username atau password salah.'),
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
    } else {
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
                  'Login Berhasil',
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
                          return HomePage();
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
    }
  }
}
