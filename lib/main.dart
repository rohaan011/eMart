import 'package:emart/firebase_options.dart';
import 'package:emart/local_storage/SharedPref.dart';
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
import 'package:emart/services/Auth.dart';
import 'package:emart/widgets/Navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPref().getUserData();
  User? user = await Auth().autoLogin();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: user != null ? '/navbar' : '/',
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
  ));
}
