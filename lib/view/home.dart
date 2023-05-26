import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_visen/controller/news.dart';
import 'package:project_visen/controller/newsCategory.dart';
import 'package:project_visen/model/fetchCategory.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:project_visen/view/category.dart';
import 'package:project_visen/view/detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _loading;
  var newslist;

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
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "App",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
                        //Category
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 70,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: category.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => CategoryPage(
                                          newsCategory: category[index].categorieName,
                                        )
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 14),
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.black26),
                                          child: Text(
                                            category[index].categorieName,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
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
                                                  articleUrl: newslist[index]
                                                      .articleUrl,
                                                )));
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
                                                  bottomRight:
                                                      Radius.circular(6),
                                                  bottomLeft:
                                                      Radius.circular(6))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    newslist[index].urlToImage,
                                                    height: 200,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    fit: BoxFit.cover,
                                                  )),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Text(
                                                newslist[index].title,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                newslist[index].description,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                      )),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
