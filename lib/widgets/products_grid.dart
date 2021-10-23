import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';

import './product_item.dart';

// separate grid view
class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(
        context); // sets up a direct communication behind the widget
    final products = productsData.items; // gets the products item
    return GridView.builder(
        padding: const EdgeInsets.all(10.0), //add const to  not make rebuild
        itemCount: products.length, //load certain amount of products
        itemBuilder: (ctx, i) => ProductItem(
            products[i].id, products[i].title, products[i].imageUrl),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10) //make it to have a certain amount of column
        );
  }
}
