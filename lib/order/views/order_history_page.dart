import 'package:app/order/models/order_history_model.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:app/order/views/order_history_detail_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final _invoiceNoFormController = TextEditingController();

  String _invoiceNo = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Histori Order'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  color: Colors.white54,
                  child: TextField(
                    controller: _invoiceNoFormController,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (value) async {
                      setState(() {
                        _invoiceNo = value;
                      });
                    },
                    decoration: const InputDecoration(
                        hintText: 'Masukkan nomor invoice'),
                  ),
                )),
            Flexible(
                flex: 8,
                child: Container(
                    alignment: Alignment.center,
                    child: FutureBuilder(
                      future: OrderRepo.getOrderHistoryResponse(_invoiceNo),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          var orderHistoryResponse =
                              snapshot.data as OrderHistoryResponse;

                          if (orderHistoryResponse.status == 'error') {
                            return Text(orderHistoryResponse.message);
                          } else {
                            return Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    var orderHistory =
                                        orderHistoryResponse.data[index];

                                    Widget isPaidBadge;
                                    if (orderHistory.isPaid == "0") {
                                      isPaidBadge = Badge(
                                        elevation: 0,
                                        toAnimate: false,
                                        borderRadius: BorderRadius.circular(4),
                                        padding: const EdgeInsets.only(
                                            top: 20,
                                            bottom: 20,
                                            left: 33,
                                            right: 33),
                                        shape: BadgeShape.square,
                                        badgeColor: Colors.red,
                                        badgeContent: const Text('DP',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      );
                                    } else {
                                      isPaidBadge = Badge(
                                        toAnimate: false,
                                        elevation: 0,
                                        borderRadius: BorderRadius.circular(4),
                                        padding: const EdgeInsets.all(20),
                                        shape: BadgeShape.square,
                                        badgeColor: Colors.green,
                                        badgeContent: const Text('LUNAS',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                                    }

                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderHistoryDetailPage(
                                                      orderHistory:
                                                          orderHistory)),
                                        ).then((value) {
                                          setState(() {
                                          });
                                        });
                                      },
                                      title: Text(orderHistory.invoiceNo),
                                      subtitle: Text(orderHistory.customerNm),
                                      trailing: isPaidBadge,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider(
                                        indent: 20, endIndent: 20);
                                  },
                                  itemCount: orderHistoryResponse.data.length),
                            );
                          }
                        }
                      },
                    ))),
          ],
        ),
      ),
    );
  }
}
