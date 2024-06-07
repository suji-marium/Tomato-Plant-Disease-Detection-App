import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginsuji/resources/StorageMethods.dart';

class UserModel {
  /*
  final String uid;
  final String? email;
  final String firstName;
  final String? secondName;
  */
  String uid;
  String name;
  String uname;
  String email;
  String phoneno;
  String password;
  String place;
  String role;
  String? image;
  

  UserModel({
    /*
    required this.uid,
    required this.email,
    required this.firstName,
    required this.secondName,
    */
    required this.uid,
    required this.name,
    required this.uname,
    required this.email,
    required this.phoneno,
    required this.password,
    required this.place,
    required this.role,
    this.image
  });

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      /*
      uid: snapshot['uid'],
      email: snapshot['email'],
      firstName: snapshot['firstName'],
      secondName: snapshot['secondName'],
      */
      uid: snapshot['uid'],
      name: snapshot['name'],
      uname: snapshot['uname'],
      email: snapshot['email'],
      phoneno: snapshot['phoneno'],
      password: snapshot['password'],
      place: snapshot['place'],
      role: snapshot['role'],
      image:snapshot['image']
    );
  }

  Map<String, dynamic> toJson() => {
    /*
        'uid': uid,
        'email': email,
        'firstName': firstName,
        'secondName': secondName,
        */
        'uid': uid,
        'name':name,
        'uname':uname,
        'email':email,
        'phoneno':phoneno,
        'password':password,
        'place':place,
        'role':role,
        'image':image,
      };
}
