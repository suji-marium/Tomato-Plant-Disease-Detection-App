import 'package:cached_network_image/cached_network_image.dart';
import 'package:loginsuji/model/article_model.dart';
import 'package:loginsuji/pages/article_view.dart';
import 'package:loginsuji/services/news.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen ({super.key});

  @override
  State<NewsScreen > createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen > {
  List <ArticleModel> articles=[];
  bool _loading=true;
  int activeIndex=0;
  @override
  void initState(){
    getNews();
    super.initState();
  }

  getNews()async{
    News newsclass=News();
    await newsclass.getNews();
    articles=newsclass.news;
    setState(() {
      _loading=false;
    });
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    body: _loading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return BlockTile(
                  url: articles[index].url!,
                  desc: articles[index].description!,
                  imageurl: articles[index].urlToImage!,
                  title: articles[index].title!,
                );
              },
            ),
          ),
  );
}

  
  Widget buildImage(String image,int index,String name)=>Container(
    margin: EdgeInsets.all(10),
    child: Stack(
      children: [ClipRRect(
      
        borderRadius: BorderRadius.circular(6),
        child:CachedNetworkImage(imageUrl: image,height: 250,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width, )),
        Container(
          height: 100,
          padding: EdgeInsets.only(left: 10),
          child: Text(name,style:TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),),
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top:130),
          decoration: BoxDecoration(color: Colors.black26,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
        )
        ]
    ),
  );

  Widget buildIndicator()=>AnimatedSmoothIndicator(
    activeIndex: activeIndex, 
    count: 5);
}

class BlockTile extends StatelessWidget {
  String imageurl,title,desc,url;
  BlockTile({required this.url,required this.desc,required this.imageurl,required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              
                              child: CachedNetworkImage(
                          imageUrl: imageurl,
                                height: 170,
                                width:MediaQuery.of(context).size.width,
                                fit: BoxFit.cover, 
                                
                              )
                          )),
                          SizedBox(height: 8,),
                          Column(
                            children: [
                              Container(
                                child: Text(title,
                                style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w500),)),
                              SizedBox(width: 5.0,),
                          
                          Container(
                            //width: MediaQuery.of(context).size.width/1.8,
                            child: Text(desc,
                            maxLines: 2,
                            style: TextStyle(color: Colors.black54,fontSize: 15,fontWeight: FontWeight.w500),))
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ),
    );
      
  }
}