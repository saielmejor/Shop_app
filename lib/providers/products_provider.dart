import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // var _showFavoritesOnly = false; //add favorite products filter
  //add a getter to get a list of items
  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items]; // return copy of items
  }

//another getter to get list of favorite items
  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

//   void showFavoritesOnly() {
//     _showFavoritesOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoritesOnly = false;
//     notifyListeners();
//   }

// // add a product findById
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
    // this will returns if the prod.id matches with argument id
  }

// add a fetch and set data products from the server
  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(Uri.parse(
          "https://shop-app-ff601-default-rtdb.firebaseio.com/products_provider.json"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = []; // creates empty list

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl']));
      });
      _items = loadedProducts;
      notifyListeners(); //execute a function for each id (the id of the product is the key ), prodData is the data inside the key
    } catch (error) {
      throw (error);
    }
  }

//expectation is to get a product  and generate an id
  //retruns nothing it returns void
  // we only care that future gets a type and it is a void because it wont return anything
  Future<void> addProduct(Product product) async {
    // use return to complete the future syntax
    try {
      final response = await http.post(
        Uri.parse(
            "https://shop-app-ff601-default-rtdb.firebaseio.com/products_provider.json"),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );
      print(json.decode(response.body));
      //register a function once the response is finished
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json
            .decode(response.body)['name'], // gets the name key from firebase
      );
      _items.add(newProduct);
      //_items.add(value);  dont add the item.add(value)
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }

    // add catch error at the end so it checks if there are error before and after the then method.
  }

  //send http  request and reads the database

  // sends a post request to url
  Future<void> updateProduct(String id, Product newProduct) async {
    // update product
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          "https://shop-app-ff601-default-rtdb.firebaseio.com/products_provider/$id.json";
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
