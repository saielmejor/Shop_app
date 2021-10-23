import 'package:flutter/material.dart';

import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
//add property
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: id, // pushNamed routeName with argument as id
              //can be done because it is define as a property
            ); // add product-detail
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover, //fit everything in the bvox
          ),
        ),
        //add a footer to displa y text in the bottom of the picture
        footer: GridTileBar(
            backgroundColor: Colors.black87, // add a background color
            leading: IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            ),
            title: Text(title, textAlign: TextAlign.center),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {},
              color: Theme.of(context).accentColor,
            )),
      ),
    );
  }
}
