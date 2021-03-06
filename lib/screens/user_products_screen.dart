import 'package:flutter/material.dart ';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  //use routename

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context)async { 
     await Provider.of<Products>(context,listen: false).fetchAndSetProducts(); 
//  avoid unnecessary widget rebuild so add listen:false 
 
  }
  Widget build(BuildContext context) {
    //gets product data
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('YourProducts'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // this will got to the editProductScreen
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      //add app drawer
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh:()=> _refreshProducts(context) , // call as anonymous function because the function passes var context
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(
                  productsData.items[i].id,
                    productsData.items[i].title,
                     productsData.items[i].imageUrl),
                Divider(), //add a divider
              ],
            ),
          ),
        ),
      ),
    );
  }
}
