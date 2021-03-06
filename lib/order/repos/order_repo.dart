import 'dart:convert';

import 'package:app/api_endpoint.dart';
import 'package:app/order/models/order_customer_model.dart';
import 'package:app/order/models/order_history_model.dart';
import 'package:app/order/models/order_model.dart';
import 'package:app/order/models/update_status_payment_model.dart';
import 'package:app/simple_exception.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:http/http.dart' as http;

class OrderRepo {
  static OrderRepo? _productRepo;
  static Database? _database;

  final String orderTable = 'mzn_order';

  OrderRepo._createObject();

  factory OrderRepo() {
    _productRepo ??= OrderRepo._createObject(); // if null
    return _productRepo!;
  }

  Future<Database?> initDb() async {
    var mezisanposDb = openDatabase(
        join(await getDatabasesPath(), 'mezisanpos.db'),
        version: 1,
        onCreate: _createDb);
    return mezisanposDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE mzn_order (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      product_id INTEGER(11),
      item_nm TEXT,
      item_price INTEGER(11),
      item_pcs INTEGER(11),
      item_note TEXT,
      item_subtotal INTEGER(11)
    )
    ''');
  }

  Future<Database?> get database async {
    _database ??= await initDb();
    return _database;
  }

  Future<int> addOrderToCart(Order order) async {
    Database? db = await database;
    var lastId = db!.insert(orderTable, order.toMap());
    return lastId;
  }

  Future<int?> countOrderRow() async {
    Database? db = await database;
    int? count = Sqflite.firstIntValue(
        await db!.rawQuery("SELECT COUNT(*) FROM $orderTable"));
    return count;
  }

  Future<int> getTotalOrder() async {
    Database? db = await database;
    var result =
        await db!.rawQuery("SELECT SUM(item_subtotal) FROM $orderTable");
    int value = result[0]["SUM(item_subtotal)"] as int;
    return value;
  }

  Future<int?> emptyCart() async {
    Database? db = await database;
    return await db!.delete(orderTable);
  }

  Future<List<Order>> getOrderList() async {
    List<Order> orders = [];
    Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(orderTable);
    orders = List.generate(
        maps.length,
        (index) => Order.fetch(
            maps[index]['id'],
            maps[index]['product_id'],
            maps[index]['item_nm'],
            maps[index]['item_price'],
            maps[index]['item_pcs'],
            maps[index]['item_note'],
            maps[index]['item_subtotal']));
    return orders;
  }

  Future<int?> removeItem(int id) async {
    Database? db = await database;
    return await db!.delete(orderTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<OrderSubmitResponse> postData(OrderCustomer orderCustomer) async {
    // print(orderCustomer.toJson());
    OrderSubmitResponse orderSubmitResponse;
    try {
      var orderResponse = await http.post(Uri.parse(ApiEndpoint.orderUrl),
          body: {"data": jsonEncode(orderCustomer)});

      var orderSubmitResponseObj =
          OrderSubmitResponse.fromJson(jsonDecode(orderResponse.body));
      if (orderSubmitResponseObj.status == "error") {
        throw SimpleException(orderSubmitResponseObj.message);
      }

      orderSubmitResponse = orderSubmitResponseObj;
    } catch (e) {
      orderSubmitResponse = OrderSubmitResponse.error("error", e.toString());
    }

    return orderSubmitResponse;
  }

  static Future<UpdateStatusPaymentResponse> updatePaymentStatus(
      Map<String, dynamic> statusPaymentData) async {
    UpdateStatusPaymentResponse updateStatusPaymentResponse;
    try {
      var updateStatusResponse = await http.post(
          Uri.parse(ApiEndpoint.updatePaymentStatusUrl),
          body: {"data": jsonEncode(statusPaymentData)});

      var updateStatusResponseObj = UpdateStatusPaymentResponse.fromJson(
          jsonDecode(updateStatusResponse.body));

      if (updateStatusResponseObj.status == "error") {
        throw SimpleException(updateStatusResponseObj.message);
      }
      updateStatusPaymentResponse = updateStatusResponseObj;
    } catch (e) {
      updateStatusPaymentResponse =
          UpdateStatusPaymentResponse.error('error', e.toString());
    }

    return updateStatusPaymentResponse;
  }

  static Future<OrderHistoryResponse> getOrderHistoryResponse(
      String invoiceNo) async {
    OrderHistoryResponse orderHistoryResponse;

    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id'); // user id

    var queryParams = {'user_id': userId, 'invoice_no': invoiceNo};

    try {
      var uri = Uri.http(
          ApiEndpoint.plainDomain, ApiEndpoint.orderHistoryUrl, queryParams);

      Map<String, String> headers = {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
      };

      var orderHistoryHttpResponse = await http.get(uri, headers: headers);

      var orderHistoryResponseObj = OrderHistoryResponse.fromJson(
          jsonDecode(orderHistoryHttpResponse.body));

      if (orderHistoryResponseObj.status == 'error') {
        throw SimpleException(orderHistoryResponseObj.message);
      }

      orderHistoryResponse = orderHistoryResponseObj;
    } catch (e) {
      orderHistoryResponse = OrderHistoryResponse.error("error", e.toString());
    }

    return orderHistoryResponse;
  }
}
