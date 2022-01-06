import 'dart:convert';

import 'package:app/api_endpoint.dart';
import 'package:app/authpos/models/user_model.dart';
import 'package:app/product/models/list_product_model.dart';
import 'package:http/http.dart' as http;

class ProductListProvider {
  List<Product> get products => _products;
  final List<Product> _products = [];

  static Future<void> getListProduct(User user) async {
    var queryParams = {'company_id': user.companyId};

    var uri = Uri.http(
        ApiEndpoint.plainDomain, ApiEndpoint.productListUrl, queryParams);

    Map<String, String> headers = {
      'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'
    };

    var productResponse = await http.get(uri, headers: headers);

    var productResponseObj = ListProductModelResponse.fromJson(jsonDecode(productResponse.body));
  }
}
