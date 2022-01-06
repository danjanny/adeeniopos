import 'package:app/simple_exception.dart';
import 'dart:convert';

class OrderHistoryResponse {
  late String status;
  late String message;
  late List<OrderHistory> data;

  OrderHistoryResponse(this.status, this.message, this.data);

  OrderHistoryResponse.error(this.status, this.message);

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    OrderHistoryResponse orderHistoryResponse;
    try {
      if (json['status'] == 'error') {
        throw SimpleException(json['message']);
      }

      var orderHistoryList = json['data'] as List; // create List from JSONArray

      var iterableOrderHistory = orderHistoryList.map((orderHistory) =>
          OrderHistory.fromJson(orderHistory)); // map list item to OrderHistory

      var listOfOrderHistory = List<OrderHistory>.from(
          iterableOrderHistory); // create List<OrderHistory>

      orderHistoryResponse = OrderHistoryResponse(
          json['status'], json['message'], listOfOrderHistory);
    } catch (e) {
      orderHistoryResponse =
          OrderHistoryResponse.error(json['status'], e.toString());
    }
    return orderHistoryResponse;
  }

  @override
  String toString() {
    return "Data OrderHistoryResponse : $status, $message";
  }
}

class OrderHistory {
  late String id;
  late String customerNm;
  late String customerPhone;
  late String invoiceNo;
  late String total;
  late String sisaBayar;
  late String dp;
  late String isPaid;
  late String tgl;
  late String modifiedAt;
  late List<OrderHistoryDetail> orderHistoryDetailList;

  OrderHistory(
      this.id,
      this.customerNm,
      this.customerPhone,
      this.invoiceNo,
      this.total,
      this.sisaBayar,
      this.dp,
      this.isPaid,
      this.tgl,
      this.modifiedAt,
      this.orderHistoryDetailList);

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    // JSONArray to List<OrderHistoryDetail>
    var orderDetailList =
        json['order_detail'] as List; // create List from JSONArray
    var iterableOrderDetail = orderDetailList.map((orderDetail) =>
        OrderHistoryDetail.fromJson(
            orderDetail)); // map list item to OrderHistoryDetail
    var listOfOrderDetail = List<OrderHistoryDetail>.from(
        iterableOrderDetail); // create List<OrderHistoryDetail>

    return OrderHistory(
        json['id'],
        json['customer_nm'],
        json['customer_phone'],
        json['invoice_no'],
        json['total'],
        json['sisa_bayar'],
        json['dp'],
        json['is_paid'],
        json['tgl'],
        json['modified_at'],
        listOfOrderDetail);
  }

  @override
  String toString() {
    return "Data OrderHistory : $id, $customerNm, $invoiceNo, ${orderHistoryDetailList.length}";
  }
}

class OrderHistoryDetail {
  late String itemNm;
  late String itemPrice;
  late String pcs;
  late String itemNote;
  late String itemSubtotal;
  late String createdAt;

  OrderHistoryDetail(this.itemNm, this.itemPrice, this.pcs, this.itemNote,
      this.itemSubtotal, this.createdAt);

  factory OrderHistoryDetail.fromJson(Map<String, dynamic> json) {
    return OrderHistoryDetail(
        json['item_nm'],
        json['item_price'],
        json['item_pcs'],
        json['item_note'],
        json['item_subtotal'],
        json['created_at']);
  }
}
