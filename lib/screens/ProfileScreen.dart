import 'package:emart/global_variables.dart';
import 'package:emart/services/Auth.dart';
import 'package:flutter/material.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  void _signOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Sign out"),
            content: Text("Are you sure want to logout?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  Auth().signOut();
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Confirm"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImage == null
                  ? 'https://via.placeholder.com/150'
                  : profileImage!)),
          SizedBox(height: 10),
          Text("$firstName $lastName",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("$email"),
          SizedBox(height: 10),

          Divider(
            height: 20,
          ),

          // list view
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/edit');
                  },
                  leading: Icon(Icons.person),
                  title: Text("Edit Profile"),
                  subtitle: Text("Change your profile details"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/changepassword');
                  },
                  leading: Icon(Icons.safety_check),
                  title: Text("Change Password"),
                  subtitle: Text("create a new password"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/myproducts');
                  },
                  leading: Icon(Icons.shopping_bag),
                  title: Text("My Products"),
                  subtitle: Text("Show all your products"),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/favourite');
                  },
                  leading: Icon(Icons.favorite),
                  title: Text("Favourite"),
                  subtitle: Text("view your favourite products"),
                  trailing: Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          ),

          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                _signOut();
              },
              child: const Text("Logout"))
        ]),
      ),
    );
  }
}
