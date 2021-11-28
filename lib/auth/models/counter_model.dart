import 'package:flutter/foundation.dart';

class CounterModel with ChangeNotifier {
  int _counter = 0;

  int get currentCount => _counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

}