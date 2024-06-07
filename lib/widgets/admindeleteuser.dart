import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsuji/Screen/LoginScreen.dart';
import 'package:loginsuji/resources/auth_methods.dart';

class AdminDeleteUser extends StatefulWidget {
  @override
  _AdminDeleteUserState createState() => _AdminDeleteUserState();
}

class _AdminDeleteUserState extends State<AdminDeleteUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _admin;

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

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Delete User',style: TextStyle(color: Colors.green),)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      
      body: StreamBuilder(
        stream: _firestore.collection('user').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          List<DocumentSnapshot> users = snapshot.data!.docs;

          return ListView.builder(
            
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name']),
                
                
                trailing: IconButton(
                  icon: Icon(Icons.delete,color: Colors.red,),
                  onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  AlertDialog(
                                  title: Text('Delete Confirmation'),
                                  content: Text('Are you sure you want to delete?'),
                                    actions: [
                                      TextButton(  
                                        onPressed: () async {
                                        try {
                                          Navigator.of(context).pop();
                                          await _firestore.collection('user').doc(users[index].id).delete();
                                          
                                        } catch (e) {
                                          print('Error deleting user: $e');
                                        }
                                      },
                                        child: Text('Delete',style: TextStyle(color: Colors.red),),
                                        
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel',style: TextStyle(color: Colors.grey)),
                                      ),
                                    ],

                          ) ;
                        },
                      );
                  },
                ),
              );
            },
          );
        },
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
          child: Text('Cancel'),
        ),
      ],
    );
  }
}


