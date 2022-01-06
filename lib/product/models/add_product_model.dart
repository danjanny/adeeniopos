class AddProductResponse {
  late String status;
  late String message;

  AddProductResponse(this.status, this.message);

  factory AddProductResponse.fromJson(Map<String, dynamic> json) {
    var productResponse = AddProductResponse(json['status'], json['message']);
    return productResponse;
  }
}


