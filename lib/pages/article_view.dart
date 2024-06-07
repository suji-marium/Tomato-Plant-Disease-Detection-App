
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticleView extends StatefulWidget {
  String blogurl;
  ArticleView({required this.blogurl});
  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 3),
      //appBar: AppBar(backgroundColor: Colors.white, ) ,

      body: Container(child: WebView(
        initialUrl:widget.blogurl,
        javascriptMode: JavascriptMode.unrestricted,
      ),),
    );
  }
}