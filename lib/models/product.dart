import 'package:flutter/foundation.dart';

//create footprint for products
class Product {
  final String
      id; //expect to get the id from the server and generate in the app
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; // this is bool because favorite is changeable

  //add constructions
// use named argument by using curlky brackets

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite=false,// set default value false meaning not true 
  });
}
