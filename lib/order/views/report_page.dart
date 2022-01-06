import 'package:app/authpos/models/user_model.dart';
import 'package:app/authpos/providers/auth_provider.dart';
import 'package:app/order/models/report_model.dart';
import 'package:app/order/providers/product_provider.dart';
import 'package:app/order/providers/report_provider.dart';
import 'package:app/order/views/order_history_detail_page.dart';
import 'package:app/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportPage extends StatefulWidget {
  late User user;

  ReportPage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _startDateFormController = TextEditingController();

  late String _startDatePostServer;

  final _endDateFormController = TextEditingController();

  String? _endDatePostServer;

  late Map<String, String> _queryParams;

  final GlobalKey<RefreshIndicatorState> _keyRefresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _queryParams = {
      'user_id': widget.user.id,
      'company_id': widget.user.companyId
    };
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    return ChangeNotifierProvider(
        create: (context) => ReportProvider(),
        child: Consumer<ReportProvider>(builder: (_, reportProvider, __) {
          // http request with user_id
          reportProvider.getReport(_queryParams);
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text('Admin POS',
                  style: TextStyle(color: Colors.black)),
              actions: [
                IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black),
                    onPressed: () async {
                      var logoutResponse = await AuthProvider.userLogout();
                      if (logoutResponse == 1) {
                        // pop all screen, then go to first route
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.popAndPushNamed(context, '/login');
                      }
                    })
              ],
            ),
            body: Container(
                child: reportProvider.reportResponse == null
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        key: _keyRefresh,
                        onRefresh: () async {
                          setState(() {
                            _queryParams = {
                              'user_id': user.id,
                              'company_id': user.companyId
                            };
                          });
                          await reportProvider.getReport(_queryParams);
                        },
                        child: reportProvider.reportResponse!.status == 'error'
                            ? SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Center(
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text(reportProvider
                                            .reportResponse!.message),
                                      )),
                                ),
                              )
                            // SHOW DATA
                            : SingleChildScrollView(
                                child: Container(
                                  color: Colors.white10,
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      reportProvider
                                                  .reportResponse!.rangeDate ==
                                              ''
                                          ? Container()
                                          : Container(
                                              alignment: Alignment.center,
                                              margin: const EdgeInsets.only(
                                                  left: 15,
                                                  right: 15,
                                                  bottom: 10,
                                                  top: 20),
                                              child: Text(reportProvider
                                                  .reportResponse!.rangeDate),
                                            ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15,
                                            right: 15,
                                            bottom: 10,
                                            top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Container(
                                              padding: const EdgeInsets.all(30),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Total'),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      Util.rupiahFormat(int
                                                          .parse(reportProvider
                                                              .reportResponse!
                                                              .paymentSummary
                                                              .total)),
                                                      style:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                ],
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(30),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('DP'),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      Util.rupiahFormat(int
                                                          .parse(reportProvider
                                                              .reportResponse!
                                                              .paymentSummary
                                                              .dp)),
                                                      style:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                ],
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Container(
                                              padding: const EdgeInsets.all(30),
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Sisa Bayar'),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      Util.rupiahFormat(int
                                                          .parse(reportProvider
                                                              .reportResponse!
                                                              .paymentSummary
                                                              .sisaBayar)),
                                                      style:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                ],
                                              ),
                                            )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Container(
                                              color: Colors.white,
                                              padding: const EdgeInsets.all(30),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Item Terjual'),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      reportProvider
                                                              .reportResponse!
                                                              .paymentSummary
                                                              .orderCount +
                                                          " pcs",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16)),
                                                ],
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      // list order history transaksi
                                      Expanded(
                                        child: Container(
                                            margin: const EdgeInsets.all(10),
                                            child: ListView.separated(
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  var orderItem = reportProvider
                                                      .reportResponse!
                                                      .orderHistory[index];
                                                  return Container(
                                                    child: ListTile(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OrderHistoryDetailPage(
                                                                      orderHistory:
                                                                          orderItem)),
                                                        ).then((value) {
                                                          setState(() {});
                                                        });
                                                      },
                                                      title: Text(
                                                          orderItem.invoiceNo),
                                                      trailing: Text(
                                                          orderItem.customerNm),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return const Divider(
                                                    indent: 25,
                                                    endIndent: 25,
                                                  );
                                                },
                                                itemCount: reportProvider
                                                    .reportResponse!
                                                    .orderHistory
                                                    .length)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: 120,
              height: 60,
              child: FloatingActionButton.extended(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => filterDialog());
                  },
                  label: Row(
                    children: const [
                      Icon(Icons.filter_list_alt),
                      SizedBox(width: 5),
                      Text('Filter')
                    ],
                  )),
            ),
          );
        }));
  }

  Widget filterDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: const Text('Report Filter',
                    style: TextStyle(fontSize: 20))),
            Column(
              children: [
                TextFormField(
                    readOnly: true,
                    showCursor: false,
                    controller: _startDateFormController,
                    keyboardType: TextInputType.number,
                    onTap: () async {
                      DateTime date = DateTime.now();
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)))!;

                      var dayStr = date.day.toString();
                      if (date.day < 10) {
                        dayStr = "0" + dayStr;
                      }

                      var monStr = date.month.toString();
                      if (date.month < 10) {
                        monStr = "0" + monStr;
                      }

                      var yearStr = date.year.toString();

                      _startDateFormController.text =
                          "$dayStr/$monStr/$yearStr"; // ditampilkan di textformfield
                      _startDatePostServer =
                          "$yearStr-$monStr-$dayStr"; // disimpan di server
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Start Date",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(Icons.date_range),
                        ),
                        labelText: 'Start Date'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Start Date harus diisi';
                      }
                      return null;
                    }),
                TextFormField(
                    readOnly: true,
                    showCursor: false,
                    controller: _endDateFormController,
                    keyboardType: TextInputType.number,
                    onTap: () async {
                      DateTime date = DateTime.now();
                      FocusScope.of(context).requestFocus(FocusNode());

                      date = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100)))!;

                      var dayStr = date.day.toString();
                      if (date.day < 10) {
                        dayStr = "0" + dayStr;
                      }

                      var monStr = date.month.toString();
                      if (date.month < 10) {
                        monStr = "0" + monStr;
                      }

                      var yearStr = date.year.toString();

                      _endDateFormController.text =
                          "$dayStr/$monStr/$yearStr"; // ditampilkan di textformfield
                      _endDatePostServer =
                          "$yearStr-$monStr-$dayStr"; // disimpan di server
                    },
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "End Date",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(Icons.date_range),
                        ),
                        labelText: 'End Date'),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'End Date harus diisi';
                      }
                      return null;
                    }),
              ],
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel')),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _queryParams['start_date'] = _startDatePostServer;
                        });

                        // if end_date is filled
                        if (_endDateFormController.text != "") {
                          _queryParams['end_date'] = _endDatePostServer!;
                        } else {
                          // if end_date is empty
                          if (_queryParams.containsKey('end_date')) {
                            _queryParams.remove('end_date');
                          }
                        }

                        Navigator.pop(context);

                        _startDateFormController.text = '';
                        _endDateFormController.text = '';
                      },
                      child: const Text('Ok')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _initReport() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    _queryParams = {'id': userId!};
  }
}
