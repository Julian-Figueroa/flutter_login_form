import 'package:formvalidation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:formvalidation/src/models/product_model.dart';

class ProductsBloc {
  final _productsController = BehaviorSubject<List<ProductModel>>();
  final _loadingController = BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

// Add values to the Stream
  void loadProducts() async {
    final products = await _productsProvider.loadProducts();

    _productsController.sink.add(products);
  }

  void addProduct(ProductModel product) async {
    await _productsProvider.createProduct(product);
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }
}
