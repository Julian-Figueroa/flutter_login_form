import 'dart:convert';
import 'dart:io';

import 'package:formvalidation/src/shared/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:formvalidation/src/models/product_model.dart';

class ProductsProvider {
  final String _url = 'https://flutter-misc.firebaseio.com';
  final String _urlBack =
      'https://api.cloudinary.com/v1_1/ianfiguer/image/upload?upload_preset=cygjn7qc';

  final _prefs = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productModelToJson(product));

    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productModelToJson(product));

    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);

    final List<ProductModel> products = new List();

    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductModel.fromJson(prod);

      prodTemp.id = id;

      products.add(prodTemp);
    });

    return products;
  }

  Future<int> deleteProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);

    final decodedData = json.decode(resp.body);
    print(decodedData);
    return 1;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(_urlBack);

    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));
    
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Something went wrong: $resp.body');
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];

  }
}
