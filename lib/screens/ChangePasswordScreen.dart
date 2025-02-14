import 'package:emart/widgets/Esnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Changepasswordscreen extends StatefulWidget {
  const Changepasswordscreen({super.key});

  @override
  State<Changepasswordscreen> createState() => _ChangepasswordscreenState();
}

class _ChangepasswordscreenState extends State<Changepasswordscreen> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _changePassword() {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword == confirmPassword) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        AuthCredential credential = EmailAuthProvider.credential(
            email: user!.email!, password: oldPassword);
        user.reauthenticateWithCredential(credential);
        user.updatePassword(newPassword);
        Esnackbar.show(context, "Password changed successfully");
      } catch (e) {
        Esnackbar.show(context, "Old password is incorrect");
      }
    } else {
      Esnackbar.show(
          context, "New password and confirm password does not match");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your old password';
                    }
                    return null;
                  },
                  obscureText: true,
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Old password',
                    hintText: 'Enter your old password',
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter your new password';
                    }
                    return null;
                  },
                  controller: _newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    hintText: 'Enter your new password',
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(height: 20),
              TextFormField(
                  obscureText: true,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter confirm password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    hintText: 'Enter your new password again',
                    border: OutlineInputBorder(),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _changePassword();
                    }
                  },
                  child: const Text('Change password'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50)))
            ],
          ),
        ),
      ),
    );
  }
}
