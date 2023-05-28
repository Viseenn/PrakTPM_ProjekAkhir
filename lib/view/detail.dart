import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  List<String> favoriteList = [];
  bool fav = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite(widget.articleUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "News",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            Text(
              "App",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            )
          ],
        ),
        actions: [_favButton(widget.articleUrl.toString())],
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

  _favoriteAction(String title) async {
    setState(() {
      fav = !fav;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (fav) {
      favoriteList.add(title);
    } else {
      favoriteList.remove(title);
    }
    prefs.setStringList("favorite", favoriteList);
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
                Text('News Favorited'),
              ],
            ),
            content: Text('The news has been added to your favorites.'),
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

  _removeFavoriteAction(String title) async {
    setState(() {
      fav = !fav;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    favoriteList.remove(title);
    prefs.setStringList("favorite", favoriteList);
    prefs.commit();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.favorite_border, color: Colors.white),
              SizedBox(width: 8.0),
              Text('News Removed'),
            ],
          ),
          content: Text('The news has been removed from your favorites.'),
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

  _checkFavorite(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorite = prefs.getStringList("favorite");
    if (favorite != null) {
      setState(() {
        favoriteList = favorite;
        fav = favoriteList.contains(title);
      });
    }
  }

  _favButton(String title) {
    _checkFavorite(title);
    return IconButton(
      onPressed: () {
        if (fav) {
          _removeFavoriteAction(title);
        } else {
          _favoriteAction(title);
        }
      },
      icon: Icon(
        fav ? Icons.favorite : Icons.favorite_border,
        color: fav ? Colors.red : Colors.white,
      ),
    );
  }
}
