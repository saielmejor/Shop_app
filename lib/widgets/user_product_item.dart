import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width:
              100, // wrap the row with container to assign a width to the row and avoid error
          child: Row(children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
                //you use arguments in navigator to search for the correct product
              },
              color: Theme.of(context).primaryColor,
            ),
            //use to clear the product
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async{
                  try {
                  await  Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                    print('delete products');
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                        content: Text(
                      'Deleting failed',
                      textAlign: TextAlign.center,
                    )));
                  }

                  // dont listen to changes
                },
                color: Theme.of(context).errorColor),
          ]),
        ));
  }
}
