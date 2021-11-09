import 'package:flutter/material.dart';
import '../providers/product.dart';

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
  //creates an empty object
  @override
  //add a listener to control imageurl focus node
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
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
      // if the image Url loses focus it will still show the preview of the image url
      //as long as it has the image url
      setState(() {});
    }
  }

  void _saveForm() {
    //add logic to save the form if the user input is correct
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return; // returns nothing if its false
    }
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _form, // adding key to access the state of Form widget
            child: ListView(
              children: <Widget>[
                TextFormField(
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
                        id: null);
                  },
                  // this is the enter button in the soft keyboard
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
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
                        id: null);
                  },
                  // you can change th the type of soft keyboard to numbers
                ),
                TextFormField(
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
                        id: null);
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
                          border: Border.all(width: 1, color: Colors.grey),
                        ),
                        //checks if Image URL is empty or has text
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(_imageUrlController.text,
                                    fit: BoxFit.cover)),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Image URL '),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          controller: _imageUrlController,
                          onFieldSubmitted: (_) {
                            _saveForm();
                          },
                          validator:(value){ 
                            if(value.isEmpty){ 
                              return ' Please enter an image Url '; 
                            }if(!value.startsWith('http') && !value.startsWith('https')){ 
                              return ' Please enter a valid Url'; 
                            }return null; 
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
                                id: null);
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
