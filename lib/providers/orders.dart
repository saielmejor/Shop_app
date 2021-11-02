import 'package:flutter/foundation.dart';
import './cart.dart ';

//define the structure of the order
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products; //gets the list of items from the cart
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = []; //empty order list

  List<OrderItem> get orders {
    return [..._orders]; // takes item order items and moves it into a new list
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now()),
    );

    notifyListeners();
  }
}
