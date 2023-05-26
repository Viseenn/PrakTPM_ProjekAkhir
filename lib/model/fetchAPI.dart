class NewsArticle {
  String author;
  String title;
  String description;
  String urlToImage;
  String content;
  String articleUrl;
  DateTime publshedAt;

  NewsArticle(
      {required this.author,
      required this.title,
      required this.description,
      required this.urlToImage,
      required this.content,
      required this.articleUrl,
      required this.publshedAt});
}
