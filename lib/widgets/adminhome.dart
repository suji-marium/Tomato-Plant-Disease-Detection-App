import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsuji/Screen/LoginScreen.dart';
import 'package:loginsuji/resources/auth_methods.dart';
import 'package:loginsuji/widgets/admindeleteuser.dart';
import 'package:loginsuji/widgets/adminusercreate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      home: AdminPanel(),
    );
  }
}

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
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
        title: Center(child: Text('Admin Panel',style: TextStyle(color: Colors.green),)),
        backgroundColor: Colors.white,
        elevation: 0,
         iconTheme: IconThemeData(
            color: Colors.black, // Change this to the desired color
          ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: Container(
          color:Colors.white,
          child: ListView(
            children: [
             SizedBox(height: 20,),
             GestureDetector(child: ListTile(leading:Icon(Icons.add,color: const Color.fromARGB(214, 0, 0, 0),),title: Text('Add Users'),
             onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminUserCreate()));
              }
             )),
             GestureDetector(
              child: ListTile(leading:Icon(Icons.people,color: const Color.fromARGB(214, 0, 0, 0),),title: Text('Users'),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel()));
              }
              ), 
             GestureDetector(child: ListTile(leading:Icon(Icons.delete,color: const Color.fromARGB(214, 0, 0, 0),),title: Text('Delete User'),),
             onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDeleteUser()));
              }
             ),
             GestureDetector(
              child: ListTile(leading:Icon(Icons.power_settings_new_sharp,color: const Color.fromARGB(214, 0, 0, 0),),title: Text('Logout'),),
              onTap: (){
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LogoutAlertDialog();
                },
              );
              }
              )
            ],
          ),
        ),
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
                
                subtitle: Text(user['email']),
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




