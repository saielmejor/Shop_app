import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';

//use stateful widget for managing all user input and this is better
//than using provider package
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController(); //adds a image controller
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: ' ', price: 0, description: ' ', imageUrl: '');

  //add default values in the text fiedl
//change the values to empty
  var _initValues = {
    'title': ' ',
    'description': ' ',
    'price': ' ',
    'imageUrl': ' ',
  };

// create another variable for default values

  //creates an empty object

  var _isInit = true; // add this so didependencies does not run all the time
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(
        _updateImageUrl); // removes imageurl focus node listener
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      //add validation for the image url
      if ((!_imageUrlController.text.startsWith('https') &&
              !_imageUrlController.text.startsWith('http')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg') &&
              !_imageUrlController.text.endsWith('.png'))) {
        return;
      }

      // if the image Url loses focus it will still show the preview of the image url
      //as long as it has the image url
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    //add logic to save the form if the user input is correct
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return; // returns nothing if its false
    }
    _form.currentState.save();
    //add a save for new products
    setState(() {
      _isLoading = true; // sets it to true
    });

    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false; // sets it to false once we are done with it
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
          // returns a future catch by catch error
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text('An error occurred'),
              content: Text('Something went wrong'),
              //add actions flat button
              actions: <Widget>[
                FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ]),
        );
      }
      // add catch error before the then method
      // because it will find any errors before then method is executed
// use finally which it will always run no matter if it
//succeeded or failed
       finally {
        setState(() {
          _isLoading = false; // sets it to false once we are done with it
        });
        Navigator.of(context).pop();
        //you need to accept a value thats why you use (_)
      }
      print('added product');
      //pops oout from the screen to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Products '),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
          ],
        ),
        //shows all the text inpuit
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            // this will show a circular spinner if its true
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form, // adding key to access the state of Form widget
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Please provide a value ';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        // this is the enter button in the soft keyboard
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return ' Please enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                        // you can change th the type of soft keyboard to numbers
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3, // allows a certain amount of text line
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return ' Please enter a description';
                          }
                          if (value.length <= 10) {
                            return ' Please enter at least 10 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },

                        // you can change th the type of soft keyboard to numbers
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(
                                top: 8,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                              ),
                              //checks if Image URL is empty or has text
                              child: _imageUrlController.text.isEmpty
                                  ? Text('Enter a URL')
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover)),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Image URL '),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return ' Please enter an image Url ';
                                  }
                                  if (!value.startsWith('http') &&
                                      !value.startsWith('https')) {
                                    return ' Please enter a valid Url';
                                  }
                                  if (!value.endsWith('.png') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.jpeg')) {
                                    return ' Please enter a valid image url ';
                                  }

                                  return null;
                                },

                                // add this to show preview of image
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                    title: _editedProduct.title,
                                    price: _editedProduct.price,
                                    description: _editedProduct.description,
                                    imageUrl: value,
                                    id: _editedProduct.id,
                                    isFavorite: _editedProduct.isFavorite,
                                  );
                                },
                                focusNode:
                                    _imageUrlFocusNode, // this will keep the focus to imageUrl
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              ));
  }
}
