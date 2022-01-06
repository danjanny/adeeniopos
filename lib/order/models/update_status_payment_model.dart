import 'dart:convert';

import 'package:app/simple_exception.dart';

class UpdateStatusPaymentResponse {
  late String status;
  late String message;
  late OrderStatusPayment orderStatusPayment;

  UpdateStatusPaymentResponse(
      this.status, this.message, this.orderStatusPayment);

  UpdateStatusPaymentResponse.error(this.status, this.message);

  factory UpdateStatusPaymentResponse.fromJson(Map<String, dynamic> json) {
    UpdateStatusPaymentResponse updateStatusPaymentResponse;
    try {
      if (json['status'] == 'error') {
        throw SimpleException(json['message']);
      }

      var orderStatusPaymentObj = OrderStatusPayment.fromJson(json['data']);
      updateStatusPaymentResponse = UpdateStatusPaymentResponse(
          json['status'], json['message'], orderStatusPaymentObj);
    } catch (e) {
      updateStatusPaymentResponse =
          UpdateStatusPaymentResponse.error(json['status'], e.toString());
    }
    return updateStatusPaymentResponse;
  }

  @override
  String toString() {
    return "Data UpdateStatusPaymentResponse : $status, $message";
  }
}

class OrderStatusPayment {
  late String isPaid;
  late String transactionDate;

  OrderStatusPayment(this.isPaid, this.transactionDate);

  factory OrderStatusPayment.fromJson(Map<String, dynamic> json) {
    return OrderStatusPayment(json['is_paid'], json['transaction_date']);
  }

  @override
  String toString() {
    return "OrderStatusPayment : $isPaid, $transactionDate";
  }
}
