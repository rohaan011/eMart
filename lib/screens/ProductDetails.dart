import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/widgets/Esnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  List<dynamic> imgList = [];

  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  void getUserData() async {
    if (userId != null) {
      var result = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      print(result['email']);

      setState(() {
        firstName = result['firsname'];
        lastName = result['lastname'];
        email = result['email'];
      });
    }
  }

  // open mail app
  void _goToMail() async {
    try {
      final mailData = Mailto(
          to: [email!],
          subject: "Product Inquiry",
          body: "Hi, I am interested in your product. Please contact me.");
      await launch('$mailData');
    } catch (e) {
      print(e);
    }
  }

  bool isFavourite = false;
  String? productId;
  String? productName;
  String? productImage;

  void _favouriteFunction() async {
    // finding user document
    final userDocument = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    // finding product document
    final productDocument =
        FirebaseFirestore.instance.collection("products").doc(productId);

    // creating favourite data
    final favouriteData = {
      "productId": productId,
      "productName": productName,
      "productImage": productImage
    };

    try {
      // if its true, remove from favourite
      if (isFavourite) {
        await userDocument.update({
          "favourites": FieldValue.arrayRemove([favouriteData])
        });
        await productDocument.update({
          "favouriteBy":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
        Esnackbar.show(context, "Removed from favourites");
        setState(() {
          isFavourite = !isFavourite;
        });
      } else {
        await userDocument.update({
          "favourites": FieldValue.arrayUnion([favouriteData])
        });
        await productDocument.update({
          "favouriteBy":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
        Esnackbar.show(context, "Added to favourites");
        setState(() {
          isFavourite = !isFavourite;
        });
      }
    } catch (e) {
      Esnackbar.show(context, "Error occured");
    }
  }

  bool isRemoved = false;
  List<dynamic> favouriteList = [];

  void checkFavorite() async {
    if (isRemoved) {
      setState(() {
        isFavourite = false;
      });
    } else {
      if (favouriteList.contains(FirebaseAuth.instance.currentUser!.uid)) {
        setState(() {
          isFavourite = true;
        });
      } else {
        setState(() {
          isFavourite = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    userId = data['userId'];
    productId = data['id'];
    productName = data['name'];
    productImage = data['images'][0];

    favouriteList = data['favouriteBy'];

    checkFavorite();

    imgList = data['images'];
    getUserData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                options: CarouselOptions(autoPlay: true),
                items: imgList
                    .map((item) => Container(
                          child: Image.network(
                            item,
                            fit: BoxFit.cover,
                            width: 1000,
                          ),
                        ))
                    .toList()),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data['name'],
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                Text("NPR.${data['price']}",
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ],
            ),
            Text(
              "Listed by: $firstName $lastName",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              data['description'],
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Category: ${data['category']}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _goToMail();
                    },
                    child: Text("Contact with email")),
                IconButton(
                    onPressed: () {
                      _favouriteFunction();
                    },
                    icon: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border))
              ],
            )
          ],
        ),
      ),
    );
  }
}
