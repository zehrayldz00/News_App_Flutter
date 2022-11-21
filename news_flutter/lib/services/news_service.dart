import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_flutter/models/articles.dart';
import 'package:news_flutter/models/news.dart';

class NewsService{

  Future<List<Articles>> fetchNews(String category)async{
    String url 
    = "https://newsapi.org/v2/top-headlines?country=tr&category=$category&apiKey=3214630fc1d84cf88b55fc49a7fb0f8b";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final result = json.decode(response.body);
      News news = News.fromJson(result);
      return news.articles ?? [];

    } 
    throw Exception('Bad Request');

  }
}