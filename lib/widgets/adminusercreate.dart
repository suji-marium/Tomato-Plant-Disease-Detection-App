import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: AdminUserCreate()));
}

class AdminUserCreate extends StatefulWidget {
  @override
  _AdminUserCreateState createState() => _AdminUserCreateState();
}

class _AdminUserCreateState extends State<AdminUserCreate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _admin;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  Future<void> _loadAdmin() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _admin = user;
      });
    }
  }

  Future<void> _addUser() async {
    try {
      // Create user account with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Retrieve the UID from the UserCredential
      String uid = credential.user!.uid;

      // Add user details to Firestore with the UID as the document ID
      await _firestore.collection('user').doc(uid).set({
        'uid': uid,
        'name': _nameController.text,
        'uname': _usernameController.text,
        'password':_passwordController.text,
        'email': _emailController.text,
        'phoneno': _phoneController.text,
        'role': 'user',
        'place': _placeController.text,
       
      });

      // Show an alert dialog for success
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('User Added Successfully'),
            
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      
      _usernameController.clear();
      _emailController.clear();
      _nameController.clear();
      _phoneController.clear();
      _passwordController.clear();
      _placeController.clear();
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Users'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _placeController,
              decoration: InputDecoration(labelText: 'Place'),
            ),
          ),
          
          ElevatedButton(
            onPressed: _addUser,
            child: Text('Add User',style: TextStyle(color: Colors.white),),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
          ),
        ],
      ),
    );
  }
}
