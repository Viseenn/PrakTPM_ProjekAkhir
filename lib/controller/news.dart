import 'dart:convert';
import 'package:project_visen/model/fetchAPI.dart';
import 'package:http/http.dart' as http;

class News {
  List<NewsArticle> news = [];

  Future<void> getNews() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=bad9385326564669afa286b3a7ab0d41';
    var response = await http.get(url);
    // print('response body: ${response.statusCode}');
    var jsonData = jsonDecode(response.body);
    // print('response json: ${jsonData}');

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        // print('response json 1: ${jsonData['articles']}');
        if (element['urlToImage'] != null && element['description'] != null) {
          NewsArticle newsarticle = NewsArticle(
              author: element['author'],
              title: element['title'],
              description: element['description'],
              urlToImage: element['urlToImage'],
              publshedAt: DateTime.parse(element['publishedAt']),
              content: element['content'],
              articleUrl: element['url']);
          news.add(newsarticle);


        print('response article: ${newsarticle}');
        }
        print('response news 1: ${news}');
      });
      print('response news 2: ${news}');

    }
  }
}

class NewsCategory {
  List<NewsArticle> news = [];

  Future<void> getNewsCategory(String category) async {
    String url =
        "http://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=bad9385326564669afa286b3a7ab0d41";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          NewsArticle newsarticle = NewsArticle(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(newsarticle);
        }
      });
    }
  }
}

class SearchNews {
  List<NewsArticle> news = [];

  Future<void> getSearch(String judul) async {
    String url =
        "https://newsapi.org/v2/everything?q=${judul}&apiKey=bad9385326564669afa286b3a7ab0d41";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          NewsArticle newsarticle = NewsArticle(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(newsarticle);
        }
      });
    }
  }
}

class DetailNews {
  List<NewsArticle> news = [];

  Future<void> getDetailNews() async {
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=bad9385326564669afa286b3a7ab0d41';
    var response = await http.get(url);
    // print('response body: ${response.statusCode}');
    var jsonData = jsonDecode(response.body);
    // print('response json: ${jsonData}');

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        // print('response json 1: ${jsonData['articles']}');
        if (element['urlToImage'] != null && element['description'] != null) {
          NewsArticle newsarticle = NewsArticle(
              author: element['author'],
              title: element['title'],
              description: element['description'],
              urlToImage: element['urlToImage'],
              publshedAt: DateTime.parse(element['publishedAt']),
              content: element['content'],
              articleUrl: element['url']);
          news.add(newsarticle);


          print('response article: ${newsarticle}');
        }
        print('response news 1: ${news}');
      });
      print('response news 2: ${news}');

    }
  }
}
