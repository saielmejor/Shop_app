import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now(); 
   
    final url =
        "https://shop-app-ff601-default-rtdb.firebaseio.com/orders.json";

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(), 
          'products': cartProducts.map((cp)=> { 
            'id':cp.id, 
            'title':cp.title, 
            'quantity':cp.quantity,
            'price':cp.price, 
          }).toList()


        }));
         _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'], //obtains the id 
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
