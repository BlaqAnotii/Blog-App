import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sharedpreference/model/newsfeed.dart';
import 'package:sharedpreference/provider/auth_provider.dart';

import '../utility/http_service.dart';

class NewsProvider with ChangeNotifier {
  List receivedNews = [];
  List get received => receivedNews;

  removeNews(String title, String body, String author, int id) {
    receivedNews.remove(News(title: title, body: body, author: author, id: id));
    notifyListeners();
  }
}
