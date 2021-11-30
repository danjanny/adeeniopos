import 'dart:convert';

import 'package:app/order/models/order_customer_model.dart';
import 'package:app/order/models/order_model.dart';
import 'package:app/order/providers/order_provider.dart';
import 'package:app/order/providers/product_provider.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:app/util.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart' as blue;
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late ProgressDialog _pd;
  late List<BluetoothDevice> _devices;
  BluetoothDevice? selectedDevice;
  bool _connected = false;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  static const _locale = 'en';

  late String _dueDatePostServer;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  final _formKey = GlobalKey<FormState>();

  final _customerFormNameController = TextEditingController();

  final _phoneFormController = TextEditingController();

  final _dpFormController = TextEditingController();

  final _dueDateFormController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // block UI : show progress dialog
    // _pd = ProgressDialog(context: context);
    // _pd.show(
    //   msqFontWeight: FontWeight.normal,
    //   valuePosition: ValuePosition.right,
    //   borderRadius: 0,
    //   max: 100,
    //   barrierDismissible: true,
    //   msg: "Logging In",
    // );

    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          // _pd.close();
          setState(() {
            _connected = true;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          // _pd.close();
          setState(() {
            _connected = false;
          });
          break;
        default:
          // _pd.close();
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
      _devices.forEach((device) {
        bluetooth.connect(device);
        print(device.name);
      });
    });

    if (isConnected!) {
      setState(() {
        print(_connected);
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OrderProvider(),
      child: Consumer<OrderProvider>(builder: (_, orderProvider, __) {
        orderProvider.getTotalOrder(); // get summary of sales (Rp)
        orderProvider.getOrderList();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            title: const Text('Keranjang'),
          ),
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 250),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          padding: const EdgeInsets.all(30),
                          alignment: Alignment.center,
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                      controller: _customerFormNameController,
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Nama customer harus diisi",
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(Icons.person),
                                          ),
                                          labelText: 'Nama Customer'),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Nama customer harus diisi';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: _phoneFormController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "No HP harus diisi",
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(Icons.phone_android),
                                          ),
                                          labelText: 'No HP'),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'No HP harus diisi';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      readOnly: true,
                                      showCursor: false,
                                      controller: _dueDateFormController,
                                      keyboardType: TextInputType.number,
                                      onTap: () async {
                                        DateTime date = DateTime.now();
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

                                        date = (await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100)))!;

                                        var dayStr = date.day.toString();
                                        if(date.day < 10) {
                                          dayStr = "0" + dayStr;
                                        }

                                        var monStr = date.month.toString();
                                        if(date.month < 10) {
                                          monStr = "0" + monStr;
                                        }

                                        var yearStr = date.year.toString();
                                        setState(() {
                                          _dueDateFormController.text =
                                              "$dayStr/$monStr/$yearStr"; // ditampilkan di textformfield
                                          _dueDatePostServer =
                                              "$yearStr-$monStr-$dayStr"; // disimpan di server
                                        });
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Tanggal Selesai",
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child: Icon(Icons.date_range),
                                          ),
                                          labelText: 'Tanggal Selesai'),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Tanggal selesai harus diisi';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                      controller: _dpFormController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        value = _formatNumber(
                                            value.replaceAll(',', ''));
                                        _dpFormController.value =
                                            TextEditingValue(
                                          text: value,
                                          selection: TextSelection.collapsed(
                                              offset: value.length),
                                        );
                                      },
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "DP",
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(top: 1),
                                            child:
                                                Icon(Icons.attach_money_sharp),
                                          ),
                                          labelText: 'DP'),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'DP harus diisi';
                                        }
                                        return null;
                                      }),
                                ],
                              )),
                        ),
                        ...orderProvider.orders.map((order) => Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(25),
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(order.itemNm +
                                                " (" +
                                                order.itemPcs.toString() +
                                                " pcs)"),
                                            Text(Util.rupiahFormat(
                                                order.itemSubtotal)),
                                            IconButton(
                                                onPressed: () async {
                                                  orderProvider.removeItem(order
                                                      .id); // remove clicked item
                                                },
                                                icon: const Icon(Icons.delete))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: Text(order.itemNote,
                                                  style: const TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic)),
                                              margin: const EdgeInsets.only(
                                                  top: 15),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    indent: 15,
                                    endIndent: 15,
                                  )
                                ],
                              ),
                            )),
                      ],
                    )),
                  ],
                ),
              ),
              Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 230,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total', style: TextStyle(fontSize: 18)),
                            Text(Util.rupiahFormat(orderProvider.totalOrder),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                // validate
                                final form = _formKey.currentState;
                                if (!form!.validate()) {
                                  return;
                                }

                                _pd = ProgressDialog(context: context);
                                _pd.show(
                                  msqFontWeight: FontWeight.normal,
                                  valuePosition: ValuePosition.right,
                                  borderRadius: 0,
                                  max: 100,
                                  barrierDismissible: true,
                                  msg: "Send data to server",
                                );

                                // init data order
                                var customerNm =
                                    _customerFormNameController.text;
                                var customerPhone = _phoneFormController.text
                                    .replaceFirst('0', '+62');

                                var dateNow = DateTime.now();
                                var formatter = DateFormat('dd/MM/yyyy');
                                var formattedDateNow =
                                    formatter.format(dateNow);

                                var dueDate = _dueDatePostServer.toString();
                                var totalBayar = orderProvider.totalOrder;
                                var dp = int.parse(
                                    _dpFormController.text.replaceAll(',', ''));
                                var sisaBayar = totalBayar - dp;

                                // map order data
                                Map<String, String> orderData = {
                                  'customer_nm': customerNm,
                                  'customer_phone': customerPhone,
                                  'transaction_date': formattedDateNow,
                                  'due_date': dueDate,
                                  'total_bayar': totalBayar.toString(),
                                  'dp': dp.toString(),
                                  'sisa_bayar': sisaBayar.toString()
                                };

                                final prefs =
                                    await SharedPreferences.getInstance();
                                var userId = prefs.getString('id'); // user id

                                var orderCustomer = OrderCustomer(
                                    userId!,
                                    orderData['customer_nm']!,
                                    orderData['customer_phone']!,
                                    orderData['transaction_date']!,
                                    orderData['due_date']!,
                                    orderData['total_bayar']!,
                                    orderData['dp']!,
                                    orderData['sisa_bayar']!,
                                    orderProvider.orders);

                                print(orderCustomer.toString());
                                OrderSubmitResponse orderSubmitResponse =
                                    await OrderRepo().postData(orderCustomer);

                                if (orderSubmitResponse.status == "ok") {
                                  _pd.close();
                                  orderData['invoice_no'] = orderSubmitResponse.data.invoiceNo;

                                  // 1. print

                                  // 2. share nota to WA
                                  _shareNotaWhatsapp(
                                      context, orderData, orderProvider);
                                } else {
                                  Fluttertoast.showToast(msg: orderSubmitResponse.message);
                                }

                                //
                                // // if bluetooth has been connected
                                // if ((await bluetooth.isConnected)!) {
                                //   // print receipt
                                //   _printReceipt(orderProvider.orders,
                                //       orderProvider.totalOrder, dp, sisaBayar);
                                //
                                //   // remove all
                                //   var itemDeleted =
                                //       await OrderRepo().emptyCart();
                                //   Navigator.pop(context,
                                //       itemDeleted); // after finished - back to home
                                // }
                              },
                              child: const Text('Transaksi',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              // style: ElevatedButton.styleFrom(
                              //     primary: Colors.indigoAccent),
                            ),
                            width: double.infinity,
                            height: 50),
                        SizedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                var itemDeleted = await OrderRepo().emptyCart();
                                Navigator.pop(context, itemDeleted);
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent),
                            ),
                            width: double.infinity,
                            height: 50),
                      ],
                    ),
                  ))
            ],
            fit: StackFit.expand,
          ),
        );
      }),
    );
  }

  void _printReceipt(
      List<Order> orders, int totalOrder, int dp, int sisaBayar) {
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom('Mezisan', 0, 1);
    bluetooth.printNewLine();
    // logo
    // bluetooth.printImage();
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    for (var order in orders) {
      var itemName = "";
      if (order.itemNm.length < 5) {
        itemName = order.itemNm;
      } else {
        itemName = order.itemNm.substring(0, 6);
      }

      bluetooth.printLeftRight(
          itemName + " (" + order.itemPcs.toString() + "x)",
          Util.rupiahFormat(order.itemSubtotal),
          0);
    }
    // total
    bluetooth.printNewLine();
    bluetooth.printLeftRight("Total", Util.rupiahFormat(totalOrder), 0);
    bluetooth.printLeftRight("DP", Util.rupiahFormat(dp), 0);
    bluetooth.printLeftRight("Sisa", Util.rupiahFormat(sisaBayar), 0);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom('Terima kasih atas pesanan anda', 0, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
  }

  void _shareWhatsapp() {}

  void _postData(OrderProvider orderProvider, int dp, int sisaBayar) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id'); // user id
    var orders = orderProvider.orders; // orders
  }

  void _shareNotaWhatsapp(BuildContext context, Map<String, Object> orderData,
      OrderProvider orderProvider) async {
    var invoiceNo = orderData['invoice_no'];
    var customerNm = orderData['customer_nm'];
    var customerPhone = orderData['customer_phone'];
    var currentDate = orderData['transaction_date'];
    var totalBayar =
        Util.rupiahFormat(int.parse(orderData['total_bayar'].toString()));
    var dp = Util.rupiahFormat(int.parse(orderData['dp'].toString()));
    var sisaBayar =
        Util.rupiahFormat(int.parse(orderData['sisa_bayar'].toString()));

    // create content of text message / nota
    StringBuffer sb = StringBuffer();
    sb.write("Mezisan\n");
    sb.write("\n");
    sb.write("Invoice No : $invoiceNo\n");
    sb.write("Customer : $customerNm\n");
    sb.write("Tgl Transaksi : $currentDate\n");
    sb.write("---------------------------------------------\n");
    for (var order in orderProvider.orders) {
      var itemName = order.itemNm;
      var itemPcs = order.itemPcs.toString();
      var itemPrice = Util.rupiahFormat(int.parse(order.itemPrice.toString()));
      var itemSubtotal =
          Util.rupiahFormat(int.parse(order.itemSubtotal.toString()));
      sb.write("$itemName ($itemPcs pcs x $itemPrice) : $itemSubtotal\n");
    }
    sb.write("---------------------------------------------\n");
    sb.write("Tanggal Selesai : ${_dueDateFormController.text}\n");
    sb.write("Total Bayar : $totalBayar\n");
    sb.write("DP : $dp\n");
    sb.write("Sisa Bayar : $sisaBayar\n");
    sb.write("---------------------------------------------\n");
    sb.write("\n");
    sb.write("Terima kasih telah order di mezisan\n");

    // encode URI
    var message = Uri.encodeComponent(sb.toString());

    // launch WA
    var whatsappLaunchResponse =
        await launch('https://wa.me/$customerPhone?text=$message');

    // if launch WA sukses, back to product index
    if (whatsappLaunchResponse) {
      var itemDeleted = await OrderRepo().emptyCart();
      Navigator.pop(context, itemDeleted); // after finished - back to home
    }
  }
}
