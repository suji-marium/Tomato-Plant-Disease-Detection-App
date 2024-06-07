import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsuji/Screen/LoginScreen.dart';
import 'package:loginsuji/model/user_model.dart';
import 'package:loginsuji/resources/auth_methods.dart';
import 'package:loginsuji/utils/utils.dart';
import 'package:loginsuji/widgets/changepassword.dart';
import 'package:loginsuji/widgets/editprofile.dart';
import 'package:loginsuji/widgets/infocard.dart';

class Profile extends StatefulWidget {
  final String uid;

  const Profile({Key? key, required this.uid}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? pickedImage;
  ImagePicker _picker = ImagePicker();
  Map<String, dynamic> userData = {};
  int postLen = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance.collection('user').doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();

      setState(() {
        userData = userSnap.data() ?? {};
        postLen = postSnap.docs.length;
        isLoading = false;
      });
      if (!userData.containsKey('image')) {
        await FirebaseFirestore.instance.collection('user').doc(widget.uid).update({'image': ''});
        setState(() {
          userData['image'] = '';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Failed to fetch data: $e');
    }
  }

  // Method to refresh user data
  Future<void> refreshUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance.collection('user').doc(widget.uid).get();
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get();

      setState(() {
        userData = userSnap.data() ?? {};
        postLen = postSnap.docs.length;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, 'Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Center(child: Text('Profile', style: TextStyle(color: Colors.green))),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,color: Colors.black,), // Icon for the three-dot button
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                  PopupMenuItem<String>(
                    value: 'change_password',
                    child: Text('Change Password'),
                  ),
                ],
            
                onSelected: (String value) async {
                  if (value == 'logout') {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          
                          builder: (BuildContext context) => const LoginScreen(),
                        ),
                      );
                      } catch (e) {
                        print('Error signing out: $e');
                      }
                    
                  } else if (value == 'change_password') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordDialog()));
                  }
                },
              ),
            ],
          ),

      body: RefreshIndicator(
        onRefresh: refreshUserData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 5),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70.0,
                      backgroundColor: const Color.fromARGB(255, 217, 216, 216),
                      child: Icon(
                        Icons.person,
                        size: 80.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Text(
                userData['name'] ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              InfoCard(text: userData['uname'] ?? '', icon: Icons.account_circle, onPressed: () async {}),
              InfoCard(text: userData['phoneno'] ?? '', icon: Icons.phone, onPressed: () async {}),
              InfoCard(text: userData['email'] ?? '', icon: Icons.email, onPressed: () async {}),
              InfoCard(text: userData['place'] ?? '', icon: Icons.place, onPressed: () async {}),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40,
                    width: 200,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen(uid: widget.uid)));
                      },
                      child: Text('Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Logout Confirmation'),
      content: Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () async {
            await AuthMethods().signOut();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
          },
          child: Text('Logout'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel',style: TextStyle(color: const Color.fromARGB(255, 130, 129, 129)),),
          
        ),
      ],
    );
  }
}