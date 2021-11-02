import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  //we need to get certain data using a constructor

  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItem(this.id, this.productId, this.price, this.quantity, this.title);
//use positional constructor

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id), // you need to do define the key in cart screen
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$${price}'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total:\$${(price * quantity)}'),
              trailing: Text('$quantity x'),
            )),
      ),
    );
  }
}
