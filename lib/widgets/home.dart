import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginsuji/model/user_model.dart';
import 'package:loginsuji/widgets/bot.dart';
import 'package:loginsuji/widgets/home1.dart';
import 'package:loginsuji/widgets/news.dart';
import 'package:loginsuji/widgets/profile.dart';
import 'package:loginsuji/widgets/upload.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          if (user != null) Home1(uid: user.uid,)
          else CircularProgressIndicator(),
          Upload(),
          Bot(),
          if (user != null) Profile(uid: user.uid)
          else CircularProgressIndicator(),
        ],
      ),
      bottomNavigationBar: 
      BottomNavigationBar(
        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: onTapped,
        currentIndex: selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 57, 132, 59),
        unselectedItemColor: const Color.fromARGB(255, 124, 124, 124),
      ),
    );
  }
}
