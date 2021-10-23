import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title, this.price);
  //use name route instead

  static const routeName = '/product-detail';
  // we need a central state amnagement system
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments
        as String; // gets the id from pushNamed
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
