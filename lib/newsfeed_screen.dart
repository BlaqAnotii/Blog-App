import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sharedpreference/model/newsfeed.dart';
import 'package:sharedpreference/provider/newsfeed_provider.dart';
import 'package:sharedpreference/utility/http_service.dart';
import 'package:sharedpreference/utility/util.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  Future getNews() async {
    final response = await http.get(Uri.parse(HttpService.blogs));

    List<News> news = [];

    if (response.statusCode == 200) {
      var jsons = jsonDecode(response.body);

      for (var json in jsons['data']) {
        News newPost = News.fromJson(json);
        print(newPost.body);
        news.add(newPost);
      }
    } else {
      throw Exception("Failed to load");
    }
    return news;
  }

  @override
  Widget build(BuildContext context) {
    final myNews = Provider.of<NewsProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "NEWS FEED",
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            //physics: 
            child: Column(
              children: [
                const SizedBox(height: 20),
                FutureBuilder(
                future: getNews(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ListTile(
                              leading: const Icon(Icons.edit),
                              title: textInfo("${snapshot.data[i].title}",
                                  FontWeight.w600, Colors.blue, 15),
                              subtitle: textInfo("${snapshot.data[i].body}",
                                  FontWeight.w300, Colors.black, 13),
                              trailing: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: 
                                  MaterialStatePropertyAll(Colors.blue)),
                                  onPressed: () {
                                    //myNews.addNews("${snapshot.data[i].title}", "${snapshot.data[i].body}");
                                  },
                                 // icon: const Icon(Icons.cancel),
                                  child: const Text("Delete",
                                  style: TextStyle(color: Colors.white),))),
                        );
                      },
                    );
                  } else {
                    return loadingCircle();
                  }
                }),
              ],
            ),
          )
      ),
    );
  }
}
