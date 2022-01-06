import 'package:app/order/models/order_model.dart';
import 'package:app/simple_exception.dart';

class OrderSubmitResponse {
  late String status;
  late String message;
  late OrderSubmit data;

  OrderSubmitResponse(this.status, this.message, this.data);

  OrderSubmitResponse.error(this.status, this.message);

  factory OrderSubmitResponse.fromJson(Map<String, dynamic> json) {
    OrderSubmitResponse orderSubmitResponse;
    try {
      if (json['status'] == 'error') {
        throw SimpleException(json['message']);
      }

      var orderSubmit = OrderSubmit.fromJson(json['data']);
      orderSubmitResponse =
          OrderSubmitResponse(json['status'], json['message'], orderSubmit);
    } catch (e) {
      orderSubmitResponse =
          OrderSubmitResponse.error(json['status'], e.toString());
    }
    return orderSubmitResponse;
  }
}

class OrderSubmit {
  late String invoiceNo;

  OrderSubmit(this.invoiceNo);

  factory OrderSubmit.fromJson(Map<String, dynamic> json) {
    return OrderSubmit(json['invoice_no']);
  }

  @override
  String toString() {
    return "Data OrderSubmit : $invoiceNo";
  }
}

class OrderCustomer {
  late String userId;
  late String companyId;
  late String invoiceNo;
  late String customerNm;
  late String customerPhone;
  late String transactionDate;
  late String dueDate;
  late String totalBayar;
  late String dp;
  late String sisaBayar;
  late List<Order> orders;

  OrderCustomer(
      this.userId,
      this.companyId,
      this.customerNm,
      this.customerPhone,
      this.transactionDate,
      this.dueDate,
      this.totalBayar,
      this.dp,
      this.sisaBayar,
      this.orders);

  OrderCustomer.orderHistory(
      this.userId,
      this.invoiceNo,
      this.customerNm,
      this.customerPhone,
      this.transactionDate,
      this.dueDate,
      this.totalBayar,
      this.dp,
      this.sisaBayar,
      this.orders);

  @override
  String toString() {
    return "Data order : $userId, $customerNm, $customerPhone, $transactionDate, $dueDate, $totalBayar, $dp, $sisaBayar, ${orders.toString()}";
  }

  Map<String, Object> toJson() {
    // List<Order> to List<Map<String,Object>>
    List<Map<String, dynamic>> orderListMap =
        orders.map((order) => order.toMap()).toList();

    return {
      'user_id': userId,
      'company_id': companyId,
      'customer_nm': customerNm,
      'customer_phone': customerPhone,
      'transaction_date': transactionDate,
      'due_date': dueDate,
      'total_bayar': totalBayar,
      'dp': dp,
      'sisa_bayar': sisaBayar,
      'orders': orderListMap
    };
  }
}
