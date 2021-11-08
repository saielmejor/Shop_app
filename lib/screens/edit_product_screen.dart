import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Products '),
        ),
        //shows all the text inpuit
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  }, // this is the enter button in the soft keyboard
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  // you can change th the type of soft keyboard to numbers
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3, // allows a certain amount of text line
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,

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
                          // add this to show preview of image
                          onEditingComplete: () {
                            setState(() {});
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
