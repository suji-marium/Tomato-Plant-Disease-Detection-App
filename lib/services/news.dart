import 'dart:convert';
//import 'package:agroguard/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'package:loginsuji/model/article_model.dart';
//import 'package:news/models/article_model.dart';

class News{
  List<ArticleModel> news=[];
  
Future<void> getNews()async{
//String url='https://newsapi.org/v2/everything?q=tesla&from=2024-01-07&sortBy=publishedAt&apiKey=bfb8e068daad483bbc28f633c69f394e';
//String url='https://newsapi.org/v2/top-headlines?country=us&q=agriculture&apiKey=bfb8e068daad483bbc28f633c69f394e';
String url="https://newsapi.org/v2/everything?q=agriculture OR farming OR crops&apiKey=54145bc9681c42de9a6cc831aa90502b";
 var response= await http.get(Uri.parse(url));

var jsonData= jsonDecode(response.body);

if(jsonData['status']=='ok'){
  jsonData["articles"].forEach((element){
    if(element["urlToImage"]!=null && element['description']!=null){
      ArticleModel articleModel= ArticleModel(
        title: element["title"],
        description: element["description"],
        url: element["url"],
        urlToImage: element["urlToImage"],
        content: element["content"],
        author: element["author"],
      );
      news.add(articleModel);
    }
  });
}
 
  }
}