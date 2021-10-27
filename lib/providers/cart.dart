import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  //define how cart looks like
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items; // map has a key and a values
  Map<String, CartItem> get items {
    //use getter to get the items
    return {..._items}; // use spread operator to get duplicate of items
  }

  //get item count
  int get itemCount {
    // gets the amount of products
    return _items.length;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // use contains key to get the key
      //change quantity
      //use the update method to get the existing cartItem and retrieves the id, title and price

      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      // this will add a new cart Item
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
  }
}
