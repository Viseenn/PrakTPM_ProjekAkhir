import 'package:flutter/material.dart';

import 'home.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class Anggota {
  final String nama;
  final String nim;
  final String plug;
  final String foto;

  Anggota({
    required this.nama,
    required this.nim,
    required this.plug,
    required this.foto,
  });
}

final daftarAnggota = [
  Anggota(
      nama: 'Giventheo Khemides',
      nim: '123200063',
      plug: 'C',
      foto: 'assets/man.png'),
  Anggota(
      nama: 'Visen', nim: '123200129', plug: 'C', foto: 'assets/person.png'),
];

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
          ),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 2,
          selectedItemColor: Colors.blue,
          onTap: (value) {
            if (value == 0) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            } else if (value == 1) {
              //Navigator.push(context,
              //    MaterialPageRoute(builder: (context) => SearchPage()));
            } else if (value == 2) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            } else if (value == 3) {
              AlertDialog alert = AlertDialog(
                title: Text("Logout"),
                content: Container(
                  child: Text("Apakah yakin ingin Logout?"),
                ),
                actions: [
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                  TextButton(
                      child: Text("Tidak"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              );
              showDialog(context: context, builder: (context) => alert);
            }
            // Respond to item press.
            setState(() => _currentIndex = value);
          },
          items: [
            BottomNavigationBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text('Search'),
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              title: Text('Profile'),
              icon: Icon(Icons.person_outline_outlined),
            ),
            BottomNavigationBarItem(
              title: Text('Logout'),
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(
            child: Card(
                margin: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: daftarAnggota.length,
                    itemBuilder: (BuildContext context, int index) {
                      final anggota = daftarAnggota[index];
                      return Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(anggota.foto),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      anggota.nama,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'NIM: ${anggota.nim}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      'Plug: ${anggota.plug}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      );
                    },
                  ),
                ))));
  }
}
