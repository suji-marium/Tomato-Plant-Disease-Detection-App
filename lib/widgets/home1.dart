import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loginsuji/model/article_model.dart';
import 'package:loginsuji/pages/article_view.dart';
import 'package:loginsuji/services/news.dart';
import 'package:loginsuji/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

class Home1 extends StatefulWidget {
  final String uid;
  const Home1({Key? key, required this.uid}) : super(key: key);

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1 > {
  List <ArticleModel> articles=[];
  bool _loading=true;
  int activeIndex=0;
  var userData = {};
  var classData = {};
  int postLen = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
    getNews();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;

      setState(() {
        isLoading = false;
      });
    } 
    catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
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
  SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 150, 238, 153),
        elevation: 0,
        toolbarHeight: 75.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60))),
        title: Center(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (userData['name'] != null)
                    Text(
                      userData['name'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    CircularProgressIndicator(), // Show circular indicator if name is null
                  Text(
                    ' !',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
            ),
            SizedBox(height: 10,),
            Text(
              'Welcome to AgroGuard',
              style: TextStyle(color: Colors.black87, fontSize: 15),
            ),
          ],
        ),
      ),
    ),
   body: _loading
        ? Center(child: CircularProgressIndicator())
        : Scrollbar(
            thumbVisibility: true, // Set isAlwaysShown to true
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
    return GestureDetector(
      
      onDoubleTap: () {
        Navigator.push(context, MaterialPageRoute(builder:(context)=>ArticleView(blogurl: url)));
      },
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
                                //width: MediaQuery.of(context).size.width/1.8,
                                child: Text(title,
                                //maxLines: 2,
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