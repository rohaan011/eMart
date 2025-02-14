import 'package:flutter/material.dart';

class Productcard extends StatefulWidget {
  final String name;
  final String description;
  final String category;
  final String price;
  final String image;

  const Productcard(
      {required this.name,
      required this.description,
      required this.category,
      required this.price,
      required this.image,
      super.key});

  @override
  State<Productcard> createState() => _ProductcardState();
}

class _ProductcardState extends State<Productcard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.image,
              fit: BoxFit.cover,
              width: 1000,
              height: 120,
            ),
          ),
          Text(
            widget.name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(widget.category),
          Text('NPR.${widget.price}',
              style: TextStyle(
                  color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}
