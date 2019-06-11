import 'dart:io';

import 'package:formvalidation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:formvalidation/src/models/product_model.dart';

class ProductsBloc {
  final _productsController = BehaviorSubject<List<ProductModel>>();
  final _loadingController = BehaviorSubject<bool>();
  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;

  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);
  }

  void createProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  void updateProduct(ProductModel product) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct(String id) async {
    await _productsProvider.deleteProduct(id);
  }

  Future<String> uploadImage(File photo) async {
    _loadingController.sink.add(true);
    final url = await _productsProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return url;
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
}
