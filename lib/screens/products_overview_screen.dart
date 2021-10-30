import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../providers/products_provider.dart ';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MyShop'), actions: <Widget>[
        PopupMenuButton(
          onSelected: (FilterOptions selectedValue) {
            //use setState to rebuild the app when the data changes
            setState(() {
              if (selectedValue == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
                child: Text('Only Show Favorites'),
                value: FilterOptions.Favorites),
            PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
          ],
        ),
        //create a badge and set up a listener with cart
        Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            child: ch,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            //separate child so it does not rebuild every single time
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
              // using the navigator will allow you to go to another screen when
              //the user press on shopping Cart
            },
          ),
        )
      ]),
      body: ProductGridView(
          _showOnlyFavorites), //products grid is created in the products_grid file
    );
  }
}
