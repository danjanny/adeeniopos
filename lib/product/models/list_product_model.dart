import 'package:app/simple_exception.dart';

class ListProductModelResponse {
  late String status;
  late String message;
  late List<Product> products;

  ListProductModelResponse(this.status, this.message, this.products);

  ListProductModelResponse.error(this.status, this.message);

  factory ListProductModelResponse.fromJson(Map<String, dynamic> json) {
    ListProductModelResponse listProductModelResponse;
    try {
      if (json['status'] == 'error') {
        throw SimpleException(json['message']);
      }
      var products = json['data'] as List;
      var iterableProducts =
          products.map((product) => Product.fromJson(product));
      var listOfProducts = List<Product>.from(iterableProducts);

      listProductModelResponse = ListProductModelResponse(
          json['status'], json['message'], listOfProducts);
    } catch (e) {
      listProductModelResponse =
          ListProductModelResponse.error(json['status'], e.toString());
    }
    return listProductModelResponse;
  }
}

class Product {
  late String companyId;
  late String productId;
  late String sku;
  late String productNm;
  late String productPrice;
  late String productImg;
  late String productSummary;
  late String imageNm;
  late List<String> productImages;

  Product(
      this.companyId,
      this.productId,
      this.sku,
      this.productNm,
      this.productPrice,
      this.productImg,
      this.productSummary,
      this.imageNm,
      this.productImages);

  factory Product.fromJson(Map<String, dynamic> json) {
    var productImages = json['product_images'] as List;
    var iterableProductImages =
        productImages.map((productImage) => productImage);
    var listOfProductImages = List<String>.from(iterableProductImages);

    return Product(
        json['company_id'],
        json['product_id'],
        json['sku'],
        json['product_nm'],
        json['product_price'],
        json['product_img'],
        json['product_summary'],
        json['image_nm'],
        listOfProductImages);
  }
}
