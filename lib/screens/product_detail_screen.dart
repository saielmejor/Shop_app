import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

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
    final loadedProduct = Provider.of<Products>(context,listen:false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct
            .title), // this will change the app bar name depending on the name of each product
      ),
    );
  }
}
