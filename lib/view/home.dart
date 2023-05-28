import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_visen/controller/news.dart';
import 'package:project_visen/controller/newsCategory.dart';
import 'package:project_visen/model/fetchCategory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_visen/view/category.dart';
import 'package:project_visen/view/detail.dart';
import 'package:project_visen/view/profile.dart';
import 'package:project_visen/view/search.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading;
  var newslist;
  int _currentIndex = 0;
  final _controller = TextEditingController();
  String? text;

  List<CategoryModel> category = [];

  void getNewsHome() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    _loading = true;
    super.initState();

    category = getCategory();
    getNewsHome();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              "App",
              style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (value) {
          if (value == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomePage()));
          } else if (value == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()));
          } else if (value == 2) {
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
            title: Text('Profile'),
            icon: Icon(Icons.person_outline_outlined),
          ),
          BottomNavigationBarItem(
            title: Text('Logout'),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Container(
                    padding: EdgeInsets.all(1),
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(1),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Enter news title",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(7.0),
                                  ),
                                  filled: true,
                                ),
                                controller: _controller,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchPage(judul: _controller.text),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                //Category
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 70,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: category.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                newsCategory:
                                category[index].categorieName,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 14),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  category[index].imageAssetUrl,
                                  height: 60,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 60,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black26,
                                ),
                                child: Text(
                                  category[index].categorieName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                //News
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: newslist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                articleUrl: newslist[index].articleUrl,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 24),
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16),
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(6),
                                  bottomLeft: Radius.circular(6),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        child: Image.network(
                                          newslist[index].urlToImage,
                                          height: 200,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    newslist[index].title,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    newslist[index].description,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
