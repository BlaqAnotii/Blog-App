class News {
  final String title;
  final String body;

  News({required this.title, required this.body});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(title: json["title"], body: json["body"]);
  }
}
