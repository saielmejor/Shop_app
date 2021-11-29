import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite; //coipies opld status
    isFavorite =
        !isFavorite; // it will toggle true if its favorite otherwise it will be false
    notifyListeners();
    //emply optimistic updating
    final url =
        "https://shop-app-ff601-default-rtdb.firebaseio.com/products_provider/$id.json";
    try {
      final response = await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavorite': isFavorite, // stores the new value from locally
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus); // sets old value to old staus
        notifyListeners();
      }
    } catch (error) {
      _setFavValue(oldStatus);
      notifyListeners();
    }
  }
}
