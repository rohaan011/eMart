import 'dart:io';

import 'package:emart/model/Products.dart';
import 'package:emart/services/ProductServices.dart';
import 'package:emart/widgets/Esnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Editproductsscreen extends StatefulWidget {
  const Editproductsscreen({super.key});

  @override
  State<Editproductsscreen> createState() => _EditproductsscreenState();
}

class _EditproductsscreenState extends State<Editproductsscreen> {
  String? productId;
  String? _selectedCategory = 'electronics';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final List<String> _selectedImages = [];
  final List<dynamic> _existingImages = [];

  // form key
  final _formKey = GlobalKey<FormState>();

  void openMedia(ImageSource source) async {
    final permissionStatus = await Permission.camera.request();
    if (permissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }

    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      setState(() {
        _selectedImages.add(image.path);
      });
    }
  }

  void _updateProduct() async {
    List<String?> uploadedUrls = [];
    // for loop for uploading each images in array
    if (_selectedImages.isNotEmpty) {
      for (final eachImage in _selectedImages) {
        final url = await ProductServices().uploadImage(File(eachImage));
        if (url != null) {
          uploadedUrls.add(url);
        }
      }
    }
    uploadedUrls.addAll(List<String>.from(_existingImages));

    final product = Products(
      name: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      price: _priceController.text,
      images: uploadedUrls,
      userId: FirebaseAuth.instance.currentUser!.uid,
    );

    await ProductServices()
        .updateProduct(productId, product)
        .then(
            (value) => Esnackbar.show(context, "Product updated successfully"))
        .catchError((error) {
      Esnackbar.show(context, "Failed to update product");
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)!.settings.arguments as Map;
    _nameController.text = data['name'];
    _descriptionController.text = data['description'];
    _priceController.text = data['price'];
    _selectedCategory = data['category'];
    productId = data['id'];

    if (_existingImages.isEmpty) {
      _existingImages.addAll(data['images']);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit products'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter product name";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter product description";
                    }
                    return null;
                  },
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Product Description',
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text(
                      "Select Category",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                DropdownButton(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          child: Text("Fashion"), value: "Fashion"),
                      DropdownMenuItem(
                          child: Text("Electronics"), value: "electronics"),
                      DropdownMenuItem(child: Text("Sports"), value: "Sports"),
                      DropdownMenuItem(
                          child: Text("Property"), value: "Property"),
                      DropdownMenuItem(child: Text("Jobs"), value: "Jobs"),
                      DropdownMenuItem(child: Text("Others"), value: "Others"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value.toString();
                      });
                    }),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter product price";
                    }
                    return null;
                  },
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Product Price',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Existing images",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                _existingImages.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                            itemCount: _existingImages.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final image = _existingImages[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(image))),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              if (_existingImages.length > 1) {
                                                setState(() {
                                                  _existingImages
                                                      .removeAt(index);
                                                });
                                              }
                                            },
                                            icon: const Icon(Icons.close)))
                                  ],
                                ),
                              );
                            }),
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                            child: Text(
                          "No previous image",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ),

                // add image widget
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add product image",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              openMedia(ImageSource.camera);
                            },
                            icon: Icon(Icons.camera_alt)),
                        IconButton(
                            onPressed: () {
                              openMedia(ImageSource.gallery);
                            },
                            icon: Icon(Icons.photo)),
                      ],
                    ),
                  ],
                ),

                _selectedImages.isNotEmpty
                    ? SizedBox(
                        height: 100,
                        child: ListView.builder(
                            itemCount: _selectedImages.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final image = _selectedImages[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border:
                                              Border.all(color: Colors.grey),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(File(image)))),
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                _selectedImages.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(Icons.close)))
                                  ],
                                ),
                              );
                            }),
                      )
                    : Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                            child: Text(
                          "No image selected",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProduct();
                      }
                    },
                    child: const Text("Update Product"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
