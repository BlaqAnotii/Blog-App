import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sharedpreference/model/newsfeed.dart';
import 'package:sharedpreference/provider/auth_provider.dart';

import '../utility/http_service.dart';

class NewsProvider with ChangeNotifier {
  List receivedNews = [];
  List get received => receivedNews;

  addNews(String title, String body) {
    receivedNews.add(News(title: title, body: body));
    notifyListeners();
  }
}
