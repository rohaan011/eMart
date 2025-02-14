import 'package:emart/screens/AddProductScreen.dart';
import 'package:emart/screens/ChangePasswordScreen.dart';
import 'package:emart/screens/EditProfileScreen.dart';
import 'package:emart/screens/FavoutiteScreen.dart';
import 'package:emart/screens/HomeScreen.dart';
import 'package:emart/screens/LoginScreen.dart';
import 'package:emart/screens/MyProductsScreen.dart';
import 'package:emart/screens/ProductDetails.dart';
import 'package:emart/screens/RegisterScreen.dart';
import 'package:emart/screens/SplashScreen.dart';
import 'package:emart/widgets/Navbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/login': (context) => Loginscreen(),
        '/register': (context) => Registerscreen(),
        '/home': (context) => Homescreen(),
        '/navbar': (context) => Navbar(),
        '/add': (context) => Addproductscreen(),
        '/details': (context) => Productdetails(),
        '/myproducts': (context) => Myproductsscreen(),
        '/edit': (context) => Editprofilescreen(),
        '/favourite': (context) => Favoutitescreen(),
        '/changepassword': (context) => Changepasswordscreen(),
        '/edit_product': (context) => Editprofilescreen(),
      },
    );
  }
}
