import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Myproductsscreen extends StatefulWidget {
  const Myproductsscreen({super.key});

  @override
  State<Myproductsscreen> createState() => _MyproductsscreenState();
}

class _MyproductsscreenState extends State<Myproductsscreen> {
  void _deleteProduct(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete this product"),
            content: Text("Are you sure want to delete?"),
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
                  FirebaseFirestore.instance
                      .collection('products')
                      .doc(id)
                      .delete();
                  Navigator.pop(context);
                  setState(() {});
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
          title: const Text('My Products'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('products')
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Failed to load data'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              } else {
                final data = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(data[index]['images'][0]),
                        title: Text(data[index]['name']),
                        subtitle: Text(data[index]['description']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/edit_product',
                                      arguments: {
                                        "id": data[index].id,
                                        "name": data[index]['name'],
                                        "price": data[index]['price'],
                                        "description": data[index]
                                            ['description'],
                                        "category": data[index]['category'],
                                        "images": data[index]['images'],
                                        "userId": data[index]['userId'],
                                      });
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  _deleteProduct(data[index].id);
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      );
                    });
              }
            }));
  }
}
