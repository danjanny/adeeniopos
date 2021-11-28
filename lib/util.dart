import 'package:intl/intl.dart';

class Util {
  static String rupiahFormat(int value) {
    var formatter = NumberFormat('#,###,000');
    return "Rp " + formatter.format(value);
  }

  static String textFormFieldRupiahFormat(int value) {
    var formatter = NumberFormat('###,###,###,###');
    return formatter.format(value);


  }
}
