import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/bloc/provider.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsBloc productsBloc;
  ProductModel product = new ProductModel();

  bool _saving = false;

  File photo;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;

    if (prodData != null) {
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takeImage,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showImage(),
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Product:',
      ),
      onSaved: (value) => product.title = value,
      validator: (value) {
        if (value.length < 3) {
          return ('Type the Product Name');
        } else {
          return null;
        }
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Price:',
      ),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Type only numbers';
        }
      },
    );
  }

  Widget _createButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Save'),
      icon: Icon(Icons.save),
      onPressed: (_saving) ? null : _submit,
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Available'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
            product.available = value;
          }),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _saving = true;
    });

    if (photo != null) {
      product.url = await productsBloc.uploadImage(photo);
    }

    if (product.id == null) {
      productsBloc.createProduct(product);
    } else {
      productsBloc.updateProduct(product);
    }

    setState(() {
      _saving = false;
    });
    showSnackBar('Product Saved');

    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showImage() {
    if (product.url != null) {
      return FadeInImage(
          image: NetworkImage(product.url),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.cover);
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  void _pickImage() async {
    _processImage(ImageSource.gallery);
  }

  void _takeImage() async {
    _processImage(ImageSource.camera);
  }

  _processImage(ImageSource source) async {
    photo = await ImagePicker.pickImage(source: source);
    if (photo != null) {
      product.url = null;
    }

    setState(() {});
  }
}
