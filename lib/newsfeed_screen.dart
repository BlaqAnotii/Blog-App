import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sharedpreference/edit_post.dart';
import 'package:sharedpreference/model/newsfeed.dart';
import 'package:sharedpreference/model/user.dart';
import 'package:sharedpreference/preference/user_preference.dart';
import 'package:sharedpreference/provider/blog_provider.dart';
import 'package:sharedpreference/provider/newsfeed_provider.dart';
import 'package:sharedpreference/utility/http_service.dart';
import 'package:sharedpreference/utility/util.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  Future<User> getUser() => UserPreference().getUser();
   String username = "";
   String token = "";

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
  void initState() {
    // TODO: implement initState
    super.initState();
     getUser().then((value)  {
        username = value.user;
        token = value.token;
        print(username);
      
      });
  }

  @override
  Widget build(BuildContext context) {
    
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
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.only(top: 20),
                                child: username == snapshot.data![index].author
                                ?
                                 ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(context,
                                     MaterialPageRoute(builder:
                                      (context) => EditPost(id: snapshot.data![index].id, 
                                      title: snapshot.data![index].title, 
                           body: snapshot.data![index].body)));
                                  },
                                  child: const Icon(Icons.edit))
                                  : const SizedBox()
                              ),
                              title: textInfo("${snapshot.data[index].title}",
                                  FontWeight.w600, Colors.blue, 15),
                              subtitle: textInfo("${snapshot.data[index].body}",
                                  FontWeight.w300, Colors.black, 13),
                              trailing: username == snapshot.data![index].author
                              ?Container(
                                padding: const EdgeInsets.only(top: 20),
                                child: ElevatedButton(
                                  style: const ButtonStyle(
                                    backgroundColor: 
                                    MaterialStatePropertyAll(Colors.blue)),
                                    onPressed: () {
                                       BlogProvider().deletePost(snapshot.data![index].author, 
                            snapshot.data![index].id, token).then((response){
                                print(response);
                               HttpService().showMessage(response["message"], context);
                              BlogProvider().getNews();


                            });
                                      //myNews.addNews("${snapshot.data[i].title}", "${snapshot.data[i].body}");
                                    },
                                   // icon: const Icon(Icons.cancel),
                                    child: const Text("Delete",
                                    style: TextStyle(color: Colors.white),)),
                              )
                              :const SizedBox()
                              ),
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