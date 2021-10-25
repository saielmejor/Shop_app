import 'package:flutter/foundation.dart';

import 'products_provider.dart';

//create footprint for products
class Product with ChangeNotifier {
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
    this.isFavorite = false, // set default value false meaning not true
  });
  void toggleFavoriteStatus() {
    isFavorite =
        !isFavorite; // it will toggle true if its favorite otherwise it will be false
    notifyListeners(); 
  }
}
