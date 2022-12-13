class News {
   final int id;
  final String title;
  final String body;
  final String author;

  News({required this.id,required this.title, required this.body, required this.author});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(id:json['id'],title: json["title"], body: json["body"], author: json["author"]);
  }
}
