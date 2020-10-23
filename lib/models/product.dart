import 'package:flutter/material.dart';

class Product {
  String id;
  String name;
  String description;
  String activityTag;
  num price;
  Map<String, dynamic> picture;


  Product({
    @required this.id, @required this.name, @required this.description, @required this.activityTag, @required this.price, @required this.picture
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "activityTag": activityTag,
      "price": price,
      "picture": picture
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      activityTag: json['activityTag'],
      price: json['price'],
      picture: json['picture'],

    );
  }
}

// class Product {
//   final String id;
//   final String title;
//   final String description;
//   final double price;
//   final String image;
//   final String imagePath;
//   final bool isFavorite;
//   final String userEmail;
//   final String userId;

//   Product(
//       {@required this.id,
//       @required this.title,
//       @required this.description,
//       @required this.price,
//       @required this.image,
//       @required this.userEmail,
//       @required this.userId,
//       @required this.imagePath,
//       this.isFavorite = false});
// }
