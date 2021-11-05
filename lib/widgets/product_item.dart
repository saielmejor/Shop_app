import 'package:flutter/material.dart';
//import the provider.dart file
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';

import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
//add property
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,
        listen: false); // interested on a single product
    final cart = Provider.of<Cart>(context, listen: false);
    //use false because we dont want the product item to update when the cart changes

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id, // pushNamed routeName with argument as id
              //can be done because it is define as a property
            ); // add product-detail
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover, //fit everything in the bvox
          ),
        ),
        //add a footer to displa y text in the bottom of the picture
        footer: GridTileBar(
            backgroundColor: Colors.black87, // add a background color
            leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        //favorite will be shown if not it will be empty
                      ),
                      onPressed: () {
                        product
                            .toggleFavoriteStatus(); // calls the toggleFavoriteStatus method
                      },
                      color: Theme.of(context).accentColor,
                    )),
            title: Text(product.title, textAlign: TextAlign.center),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
                //include a info popup
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added item to cart!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            )),
      ),
    );
  }
}
