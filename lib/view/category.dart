import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:project_visen/controller/news.dart';
import 'package:project_visen/view/detail.dart';

class CategoryPage extends StatefulWidget {
  final String newsCategory;
  const CategoryPage({required this.newsCategory});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  var newslist;
  bool _loading = true;

  @override
  void initState() {
    getNews();
  }

  void getNews() async {
    NewsCategory news = NewsCategory();
    await news.getNewsCategory(widget.newsCategory);
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Berita",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
            ),
            Text(
              "Universe",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                      itemCount: newslist.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                          articleUrl:
                                              newslist[index].articleUrl,
                                        )));
                          },
                          child: Container(
                              margin: EdgeInsets.only(bottom: 24),
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(6),
                                          bottomLeft: Radius.circular(6))),
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
                                            width: MediaQuery.of(context)
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
                                            fontWeight: FontWeight.w500),
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
                ),
              ),
            ),
    );
  }
}
