import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsuji/model/user_model.dart';


class EditProfileScreen extends StatefulWidget {
  final String uid;

  EditProfileScreen({required this.uid});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController unameController;
  late TextEditingController phoneController;
  late TextEditingController placeController;
  late TextEditingController passwordController;
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      var userSnap = await FirebaseFirestore.instance.collection('user').doc(widget.uid).get();
      setState(() {
        userData = userSnap.data() ?? {};
        nameController = TextEditingController(text: userData['name']);
        emailController = TextEditingController(text: userData['email']);
        unameController = TextEditingController(text: userData['uname']);
        phoneController = TextEditingController(text: userData['phoneno']);
        placeController = TextEditingController(text: userData['place']);
        passwordController = TextEditingController(text: userData['password']);
      });
    } catch (e) {
      // Handle error
    }
  }
  Future<void> _updateUserProfile() async {
    try {
      // Get a reference to the current user's document in Firestore
      final userDoc = FirebaseFirestore.instance.collection('user').doc(widget.uid);

      // Update the document with the new user data
      await userDoc.update({
        'name': nameController.text,
        'email': emailController.text,
        'uname': unameController.text,
        'phoneno': phoneController.text,
        'place': placeController.text,
        'password': passwordController.text,
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));

      // Navigate back to the previous screen
      Navigator.pop(context);
    } catch (e) {
      // Show an error message if updating the profile fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(child: Text('Edit Profile', style: TextStyle(color: Colors.black))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: unameController,
                decoration: InputDecoration(labelText: 'UserName'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              
              TextField(
                controller: placeController,
                decoration: InputDecoration(labelText: 'Place'),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
                backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                    onPressed: _updateUserProfile, // Call the update method when the button is pressed
                    child: Text('Save'),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
