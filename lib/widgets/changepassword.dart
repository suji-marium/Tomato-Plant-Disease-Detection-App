import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordDialog extends StatefulWidget {
  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  @override
  void initState() {
    super.initState();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmNewPassword = _confirmNewPasswordController.text;

    if (newPassword != confirmNewPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match.'),
      ));
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reauthenticate user before changing password
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Change password
        await user.updatePassword(newPassword);

        // Password changed successfully, close dialog
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User not logged in.'),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to change password: $error'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Change Password',
        style: TextStyle(
          color: Colors.green, // Change the color here
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _oldPasswordController,
            obscureText: true,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              labelText: 'Old Password',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green),
              ),
            ),
          ),
          TextField(
            controller: _newPasswordController,
            obscureText: true,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green),
              ),
            ),
          ),
          TextField(
            controller: _confirmNewPasswordController,
            obscureText: true,
            cursorColor: Colors.green,
            decoration: InputDecoration(
              labelText: 'Confirm New Password',
              labelStyle: TextStyle(color: Colors.green),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.green),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: const Color.fromARGB(255, 121, 121, 121)),
          ),
        ),
        ElevatedButton(
          onPressed: _changePassword,
          child: Text('Save'),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
        ),
      ],
    );
  }
}
