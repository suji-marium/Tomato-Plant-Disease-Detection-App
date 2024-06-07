import 'dart:ffi';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:loginsuji/Screen/LoginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsuji/model/user_model.dart' as model;
import 'package:loginsuji/resources/StorageMethods.dart';
import 'package:loginsuji/resources/auth_methods.dart';
import 'package:loginsuji/utils/utils.dart';
import 'package:loginsuji/widgets/home.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final NameEditingController = new TextEditingController();
  final UNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final phoneEditingController=new TextEditingController();
  final placeEditingController=new TextEditingController();
  
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    final firstfield = TextFormField(
      autofocus: false,
      controller: NameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name cannot be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Name(Min. 3 Character)");
        }
        return null;
      },
      onSaved: (value) {
        NameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),//IconData(0xe043, fontFamily: 'MaterialIcons')
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    final secfield = TextFormField(
      autofocus: false,
      controller: UNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Username Name cannot be Empty");
        }
        if (!RegExp(r'^[a-z0-9]+[a-z0-9]$').hasMatch(value)) {
            return("Invalid username!");
        }

        return null;
      },
      onSaved: (value) {
        UNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    final emailfield = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]+.[a-z]")
            .hasMatch(value)) {
          return ("Please Enter a valid Mail");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_rounded),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    final passfield = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password (Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    final phonefield = TextFormField(
      autofocus: false,
      key: ValueKey('phoneno'),
      controller:phoneEditingController ,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Phone Number cannot be Empty");
        }
        
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );

    final placefield = TextFormField(
      autofocus: false,
      controller:placeEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Place name cannot be Empty");
        }
        
        return null;
      },
      onSaved: (value) {
        placeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.place),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Place",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          )),
    );


    final NextButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      color: Colors.green,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUser(
            email: emailEditingController.text,
            password: passwordEditingController.text,
          );
        },
        child: Container(
            child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
    );

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
                child: Container(
              color: Colors.white,
              child: Padding(
                  padding: EdgeInsets.all(36.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            "Create an account",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                          //SizedBox(height: 20),
                          SizedBox(height: 17),
                          firstfield,
                          SizedBox(height: 17),
                          secfield,
                          SizedBox(height: 17),
                          emailfield,
                          SizedBox(height: 17),
                          passfield,
                          SizedBox(height: 17),
                          phonefield,
                          SizedBox(height: 17),
                          placefield,
                          SizedBox(height: 25),
                          NextButton,
                          SizedBox(height: 20),
                          GestureDetector(
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already SignUp?",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(' Login',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreen(),
                                  ));
                            },
                          )],
                      ))),
            )),
          )),
    );
  }

  Future<String> signUser({
    required String email,
    required String password,
  }) async {
    setState(() {
      isLoading = true;
    });
    String role = "user";
    String res = "Some error occured";
    try {
      
      if (_formKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        
        //if(email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        model.UserModel userModel = model.UserModel(
          /*
          uid: cred.user!.uid,
          email: email,
          firstName: firstNameEditingController.text,
          secondName: SecondNameEditingController.text,
          */
          uid: cred.user!.uid,
          name:NameEditingController.text ,
          uname:UNameEditingController.text,
          email: email,
          password: password,
          phoneno:phoneEditingController.text ,
          place: placeEditingController.text,
          role:role
          
        );

        await _firestore
            .collection("user")
            .doc(cred.user!.uid)
            .set(userModel.toJson());
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "Account created Successfully");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false);
      } else {
        res = "Please enter all the fields";
        Fluttertoast.showToast(msg: "Please enter all the fields");
      }
    } catch (err) {
      res = err.toString();
      setState(() {
        isLoading = false;
      });
    }

    return res;
  }
}
