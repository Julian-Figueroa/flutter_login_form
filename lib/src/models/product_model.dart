import 'dart:convert';

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String id;
  String title;
  double value;
  bool available;
  String url;

  ProductModel({
    this.id,
    this.title = '',
    this.value = 0.0,
    this.available = true,
    this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => new ProductModel(
        id: json["id"],
        title: json["title"],
        value: json["value"],
        available: json["available"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "available": available,
        "url": url,
      };
}
