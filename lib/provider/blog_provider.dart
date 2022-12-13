import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sharedpreference/model/blog.dart';
import 'package:sharedpreference/model/newsfeed.dart';
import 'package:sharedpreference/provider/auth_provider.dart';
import 'package:sharedpreference/utility/http_service.dart';


class BlogProvider with ChangeNotifier{

    Status _loadingCircle = Status.notLoading;

    Status get loadingCicle => _loadingCircle;

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

    Future<Map<String, dynamic>> savePost(String title, 
    String body, String author, String token) async{

      final Map<String, dynamic> bodyPost = {
        'title': title,
        'body' : body,
        'author' : author
      };

      _loadingCircle = Status.loading;
      notifyListeners();

      final response = await post(Uri.parse(HttpService.blogs),
          headers: {
            'content-Type' : 'application/json',
            'Authorization' : 'Bearer $token'
          },
          body: json.encode(bodyPost)
      ).then(onValue)
      .catchError(onError);

      _loadingCircle = Status.loaded;
      notifyListeners();

      return response;
    }

     Future<Map<String, dynamic>> updatePost(String title, 
    String body, int id, String token) async{

      final Map<String, dynamic> bodyPost = {
        'title': title,
        'body' : body
      };

      _loadingCircle = Status.loading;
      notifyListeners();

      final response = await put(Uri.parse(HttpService.updateblog + id.toString()),
          headers: {
            'content-Type' : 'application/json',
            'Authorization' : 'Bearer $token'
          },
          body: json.encode(bodyPost)
      ).then(onValue)
      .catchError(onError);

      _loadingCircle = Status.loaded;
      notifyListeners();

      return response;
    }

      Future<Map<String, dynamic>> deletePost(String author, 
    int id, String token) async{
print(id);
      final Map<String, dynamic> bodyPost = {
        'author': author
      };

      _loadingCircle = Status.loading;
      notifyListeners();

      final response = await delete(Uri.parse(HttpService.deleteblog + id.toString()),
          headers: {
            'content-Type' : 'application/json',
            'Authorization' : 'Bearer $token'
          },
          body: json.encode(bodyPost)
      ).then(onValue)
      .catchError(onError);

      _loadingCircle = Status.loaded;
      notifyListeners();

      return response;
    }



    static Future onValue(Response response) async{
      var result;

      final Map<String, dynamic> responseData = json.decode(response.body);

      if(response.statusCode == 200){
            // print(responseData);
              Blog blog = Blog.fromJson(responseData['data']);
         
              result= {
                "status" : 200,
                "message" : responseData["message"],
                'data' : blog
              };


         
      }else{
         result= {
                "status" : 500,
                "message" : "Unable to create post!",
                'data' : null
              };
      }
        return result;
    }

    static onError(error){
      print(error);
      return {
        'status' : false,
        'message' : "Unexpected Error Encountered!",
        'data' : error
      };
    }



}