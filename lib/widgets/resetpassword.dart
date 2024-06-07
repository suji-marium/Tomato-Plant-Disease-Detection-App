import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Reset Password"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            Container(
               height: 40,
               width: 20,
              child: ElevatedButton(
                onPressed: () {
                  resetPassword(context);
                },
                child: Text("Reset Password"),
                style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))),
                backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword(BuildContext context) async {
  try {
    String email = emailController.text;
    //print(email);
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    Fluttertoast.showToast(
      msg: "Password reset email sent, please check your inbox.",
    );
    Navigator.pop(context); // Close the reset password page after sending email
  } catch (e) {
    print("Error sending password reset email: $e");
    Fluttertoast.showToast(
      msg: "Error sending password reset email: $e",
    );
  }
}

}
