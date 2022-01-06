import 'package:app/order/models/order_history_model.dart';
import 'package:app/simple_exception.dart';

class ReportResponse {
  late String status;
  late String message;
  late String rangeDate;
  late PaymentSummary paymentSummary;
  late List<SalesSummary> salesSummary;
  late List<OrderHistory> orderHistory;

  ReportResponse(this.status, this.message, this.rangeDate, this.paymentSummary,
      this.salesSummary, this.orderHistory);

  ReportResponse.error(this.status, this.message);

  factory ReportResponse.fromJson(Map<String, dynamic> json) {
    ReportResponse reportResponse;
    try {
      if (json['message'] == 'error') {
        throw SimpleException(json['message']);
      }

      // Parsing json of payment_summary
      var paymentSummaryObj = PaymentSummary.fromJson(json['payment_summary']);

      // Parsing json of sales_summary to List<SalesSummary>
      var salesSummaryList = json['sales_summary'] as List;
      var iterableSalesSummary = salesSummaryList
          .map((salesSummary) => SalesSummary.fromJson(salesSummary));
      var listOfSalesSummary = List<SalesSummary>.from(iterableSalesSummary);

      // parsing json of order_history to List<OrderHistory>
      var orderHistoryList =
          json['order_history'] as List; // create List from JSONArray
      var iterableOrderHistory = orderHistoryList.map((orderHistory) =>
          OrderHistory.fromJson(orderHistory)); // map list item to OrderHistory
      var listOfOrderHistory = List<OrderHistory>.from(
          iterableOrderHistory); // create List<OrderHistory>

      reportResponse = ReportResponse(
          json['status'],
          json['message'],
          json['range_date'],
          paymentSummaryObj,
          listOfSalesSummary,
          listOfOrderHistory);
    } catch (e) {
      reportResponse = ReportResponse.error(json['status'], json['message']);
    }

    return reportResponse;
  }

  @override
  String toString() {
    return "Data ReportResponse : $status, $message";
  }
}

class PaymentSummary {
  late String total;
  late String sisaBayar;
  late String dp;
  late String orderCount;

  PaymentSummary(this.total, this.sisaBayar, this.dp, this.orderCount);

  factory PaymentSummary.fromJson(Map<String, dynamic> json) {
    return PaymentSummary(
        json['total'], json['sisa_bayar'], json['dp'], json['order_count']);
  }

  @override
  String toString() {
    return "Data PaymentSummary : $total, $sisaBayar, $dp, $orderCount";
  }
}

class SalesSummary {
  late String productId;
  late String itemNm;
  late String itemSubtotal;
  late String itemPcs;

  SalesSummary(this.productId, this.itemNm, this.itemSubtotal, this.itemPcs);

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    return SalesSummary(json['product_id'], json['item_nm'],
        json['item_subtotal'], json['item_pcs']);
  }

  @override
  String toString() {
    return "Data SalesSummary : $productId, $itemNm, $itemSubtotal, $itemPcs";
  }
}
