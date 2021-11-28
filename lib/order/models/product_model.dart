import 'package:app/simple_exception.dart';

class ProductResponse {
  late String status;
  late String message;
  late List<Product> product;

  ProductResponse(this.status, this.message, this.product);

  ProductResponse.error(this.status, this.message);

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    ProductResponse productResponse;
    try {
      if (json['status'] == 'error') {
        throw SimpleException(json['message']);
      }

      // convert json array of object to List<Product>
      var productsList = json['data'] as List;
      var iterableProducts =
          productsList.map((product) => Product.fromJson(product));
      var listOfProducts = List<Product>.from(iterableProducts);

      productResponse =
          ProductResponse(json['status'], json['message'], listOfProducts);
    } catch (e) {
      productResponse = ProductResponse.error(json['status'], e.toString());
    }
    return productResponse;
  }

  @override
  String toString() {
    return "Data ProductResponse : $status, $message";
  }
}

class Product {
  late String id;
  late String productName;
  late String productImg;
  late String productSummary;

  Product(this.id, this.productName, this.productImg, this.productSummary);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['id'], json['product_nm'], json['product_img'],
        json['product_summary']);
  }

  @override
  String toString() {
    return "Data product loaded : $id, $productName, $productImg, $productSummary";
  }
}
