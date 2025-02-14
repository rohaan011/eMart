import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favoutitescreen extends StatefulWidget {
  const Favoutitescreen({super.key});

  @override
  State<Favoutitescreen> createState() => _FavoutitescreenState();
}

class _FavoutitescreenState extends State<Favoutitescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Failed to load data'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            } else {
              final data = snapshot.data!.data()!['favourites'];

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('products')
                            .doc(data[index]['productId'])
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Failed to load data'));
                          } else if (!snapshot.hasData) {
                            return const Center(child: Text('No data found'));
                          } else {
                            final data = snapshot.data!.data()!;
                            // print document id
                            print(snapshot.data!.id);
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/details",
                                    arguments: {
                                      "id": snapshot.data!.id,
                                      "name": data['name'],
                                      "price": data['price'],
                                      "description": data['description'],
                                      "category": data['category'],
                                      "images": data['images'],
                                      "userId": data['userId'],
                                      "favouriteBy": data['favouriteBy']
                                    });
                              },
                              child: ListTile(
                                leading: Image.network(data['images'][0]),
                                title: Text(data['name']),
                                subtitle: Text(data['price']),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            );
                          }
                        });
                  });
            }
          }),
    );
  }
}
