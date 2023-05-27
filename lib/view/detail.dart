import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_visen/model/fetchAPI.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  final String articleUrl;
  const DetailPage({required this.articleUrl});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  bool fav = false;

  @override
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
        actions: [
          _favButton(widget.articleUrl.toString())
        ],
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: widget.articleUrl,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }

  _favoriteAction(String articleUrl) async {
    setState(() {
      fav = !fav;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        "favorite", [articleUrl, fav.toString()]);
    prefs.commit();

    if (fav) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8.0),
                Text('Article Favorited'),
              ],
            ),
            content: Text('The article has been added to your favorites.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  _checkFavorite(String articleUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorite = prefs.getStringList("favorite");
    if (favorite != null) {
      if (favorite[1] == "true" && articleUrl == favorite[0]) {
        setState(() {
          fav = true;
        });
      }
    }
  }

  _favButton(String articleUrl) {
    _checkFavorite(articleUrl);
    return IconButton(
      onPressed: () {
        _favoriteAction(articleUrl);
      },
      icon: Icon(
        fav ? Icons.favorite : Icons.favorite_border,
        color: fav ? Colors.red : Colors.white,
      ),
    );
  }

}
