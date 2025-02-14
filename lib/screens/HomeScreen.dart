import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart/global_variables.dart';
import 'package:emart/widgets/ProductCard.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // list of images
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c2hvZXN8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
    'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2071&q=80',
    'https://images.unsplash.com/photo-1529374255404-311a2a4f1fd9?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80',
    'https://images.unsplash.com/photo-1593305841991-05c297ba4575?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1957&q=80',
  ];

  String filterCategory = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $firstName'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            const Text(
              'Showing popular products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // list of products category
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: filterCategory == 'all'
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: filterCategory == 'all'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          filterCategory = 'all';
                        });
                      },
                      child: const Text('All'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: filterCategory == 'furniture'
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: filterCategory == 'furniture'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          filterCategory = 'furniture';
                        });
                      },
                      child: const Text('Furniture'),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: filterCategory == 'clothes'
                            ? Colors.blue
                            : Colors.white,
                        foregroundColor: filterCategory == 'clothes'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          filterCategory = 'clothes';
                        });
                      },
                      child: const Text('Clothes'),
                    ),
                  ],
                ),
              ),
            ),

            // future builder for getting data from firebase
            FutureBuilder<QuerySnapshot?>(
                future: filterCategory == "all"
                    ? FirebaseFirestore.instance.collection('products').get()
                    : FirebaseFirestore.instance
                        .collection('products')
                        .where("category", isEqualTo: filterCategory)
                        .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('No products found for this category'),
                      ),
                    );
                  }

                  final data = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing:
                          10, // Add horizontal spacing between items
                      mainAxisSpacing: 10, // Add vertical spacing between items
                      children: data.map((doc) {
                        final product = doc.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/details",
                                arguments: {
                                  "id": doc.id,
                                  "name": product['name'],
                                  "price": product['price'],
                                  "description": product['description'],
                                  "category": product['category'],
                                  "images": product['images'],
                                  "userId": product['userId'],
                                  "favouriteBy": product['favouriteBy']
                                });
                          },
                          child: Productcard(
                            name: product['name'],
                            price: product['price'],
                            description: product['description'],
                            category: product['category'],
                            image: (product['images'] != null &&
                                    product['images'].isNotEmpty)
                                ? product['images'][0]
                                : 'https://via.placeholder.com/150',
                          ),
                        );
                      }).toList(),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
