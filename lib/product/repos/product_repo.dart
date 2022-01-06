import 'dart:convert';
import 'dart:io';

import 'package:app/api_endpoint.dart';
import 'package:app/product/models/add_product_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProductRepo {
  static Future<AddProductResponse> postProductData(
      List<String> imgList, Map<String, String> fields) async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiEndpoint.addProductUrl));

    List<http.MultipartFile> newList = [];
    for (var img in imgList) {
      File imgFile = File(img);
      var stream = http.ByteStream(imgFile.openRead());
      var length = await imgFile.length();
      var multipartFile = http.MultipartFile(
          "imagefile[]", stream.cast(), length,
          filename: basename(imgFile.path));
      newList.add(multipartFile);
    }

    // add image
    request.files.addAll(newList);

    // add fields
    request.fields.addAll(fields);

    var response = await request.send(); // send request
    var body = await response.stream.bytesToString();

    var addProductResponseObj = AddProductResponse.fromJson(jsonDecode(body));
    return addProductResponseObj;
  }
}
