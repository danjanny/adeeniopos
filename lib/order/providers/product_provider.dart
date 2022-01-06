import 'dart:convert';

import 'package:app/api_endpoint.dart';
import 'package:app/authpos/models/user_model.dart';
import 'package:app/order/models/product_model.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:app/simple_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProductProvider extends ChangeNotifier {
  int get status => _status;
  final int _status = 1;

  int get itemSubtotal => _itemSubtotal;
  late int _itemSubtotal = 0;

  int? get totalRowCount => _totalRowCount;
  late int? _totalRowCount = 0;

  static Future<ProductResponse?> getProduct(User user, String queryFilterProduct) async {
    ProductResponse productResponse;
    try {
      // var productJsonResponse = await http
      //     .get(Uri.https(ApiEndpoint.plainDomain, ApiEndpoint.productUrl));

      // var productJsonResponse =
      //     await http.get(Uri.parse(ApiEndpoint.productIndexUrl));

      var queryParams = {'company_id': user.companyId, 'product_nm': queryFilterProduct};

      var uri = Uri.http(
          ApiEndpoint.plainDomain, ApiEndpoint.productIndexUrlNew, queryParams);

      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
      };

      var productJsonResponse = await http.get(uri, headers: headers);

      // var productResponse = await http.get(Uri.parse(ApiEndpoint.productUrl));

      var productResponseObj =
          ProductResponse.fromJson(jsonDecode(productJsonResponse.body));
      if (productResponseObj.status == 'error') {
        throw SimpleException(productResponseObj.message);
      }

      productResponse = productResponseObj;
    } catch (e) {
      productResponse = ProductResponse.error('error', e.toString());
    }

    return productResponse;
  }

  void calculateSubtotal(int itemPrice, int itemPcs) {
    _itemSubtotal = itemPrice * itemPcs;
    notifyListeners();
  }

  Future<int?> orderRowCount() {
    return OrderRepo().countOrderRow();
  }
}
