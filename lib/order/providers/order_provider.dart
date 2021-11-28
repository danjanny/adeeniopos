import 'package:app/order/models/order_model.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:flutter/foundation.dart';

class OrderProvider extends ChangeNotifier {
  int get totalOrder => _totalOrder;
  int _totalOrder = 0;

  List<Order> get orders => _orders;
  List<Order> _orders = [];

  Future<void> getOrder() async {}

  void getTotalOrder() async {
    _totalOrder = await OrderRepo().getTotalOrder();
    _totalOrder ??= 0;
    notifyListeners();
  }

  void getOrderList() async {
    _orders = await OrderRepo().getOrderList();
    notifyListeners();
  }

  void removeItem(int id) async {
    await OrderRepo().removeItem(id);
    notifyListeners();
  }

  void postData() {

  }

}
