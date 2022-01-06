import 'package:app/order/models/order_history_model.dart';
import 'package:app/order/models/update_status_payment_model.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:app/util.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistoryDetailPage extends StatelessWidget {
  OrderHistory? orderHistory;

  late ProgressDialog _pd;

  OrderHistoryDetailPage({Key? key, required this.orderHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget isPaidBadge;
    if (orderHistory!.isPaid == "0") {
      isPaidBadge = Badge(
        toAnimate: false,
        elevation: 0,
        borderRadius: BorderRadius.circular(4),
        padding:
            const EdgeInsets.only(top: 20, bottom: 20, left: 33, right: 33),
        shape: BadgeShape.square,
        badgeColor: Colors.red,
        badgeContent: const Text('DP',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    } else {
      isPaidBadge = Badge(
        elevation: 0,
        toAnimate: false,
        borderRadius: BorderRadius.circular(4),
        padding: const EdgeInsets.all(20),
        shape: BadgeShape.square,
        badgeColor: Colors.green,
        badgeContent:
            const Text('LUNAS', style: TextStyle(color: Colors.white)),
      );
    }

    var total = Util.rupiahFormat(int.parse(orderHistory!.total));
    var dp = Util.rupiahFormat(int.parse(orderHistory!.dp));
    var sisaBayar = Util.rupiahFormat(int.parse(orderHistory!.sisaBayar));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Order Histori Detail'),
      ),
      body: Container(
        color: Colors.white12,
        child: Column(
          children: [
            Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(orderHistory!.invoiceNo,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        isPaidBadge
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(orderHistory!.tgl)
                  ],
                )),
            Flexible(
                flex: 7,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Nama Customer
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Customer',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff939292),
                                  )),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(orderHistory!.customerNm),
                                  Text(orderHistory!.customerPhone)
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          indent: 18,
                          endIndent: 18,
                          color: Colors.grey,
                        ),
                        // Order Detail / Item
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Order Item',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff939292),
                                  )),
                              const SizedBox(height: 25),
                              ...orderHistory!.orderHistoryDetailList
                                  .map((orderItem) => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(orderItem.itemNm +
                                                    " (" +
                                                    Util.rupiahFormat(int.parse(
                                                        orderItem.itemPrice)) +
                                                    "x" +
                                                    orderItem.pcs +
                                                    " pcs)"),
                                              ),
                                              Text(Util.rupiahFormat(int.parse(
                                                  orderItem.itemSubtotal)))
                                            ],
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5, bottom: 10),
                                              alignment: Alignment.centerLeft,
                                              child: Text(orderItem.itemNote,
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontStyle:
                                                          FontStyle.italic))),
                                          const SizedBox(height: 20),
                                        ],
                                      ))
                            ],
                          ),
                        ),
                        const Divider(
                          indent: 18,
                          endIndent: 18,
                          color: Colors.grey,
                        ),
                        // Detail Pembayaran
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Detail Pembayaran',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xff939292),
                                  )),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [const Text('DP'), Text(dp)],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Sisa Bayar'),
                                  Text(sisaBayar)
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [const Text('Total'), Text(total)],
                              ),
                              const SizedBox(height: 20),
                              // TGL LUNAS
                              orderHistory!.isPaid == "0" ? Container() : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [const Text('Tanggal Lunas'), Text(orderHistory!.modifiedAt)],
                              ),
                            ],
                          ),
                        ),
                        orderHistory!.isPaid == "0"
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                child: SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _pd = ProgressDialog(context: context);
                                        _pd.show(
                                          msqFontWeight: FontWeight.normal,
                                          valuePosition: ValuePosition.right,
                                          borderRadius: 0,
                                          max: 100,
                                          barrierDismissible: true,
                                          msg: "Send data to server",
                                        );

                                        var statusPaymentData = {
                                          'invoice_no': orderHistory!.invoiceNo
                                        };

                                        var updatePaymentStatusObj =
                                            await OrderRepo.updatePaymentStatus(
                                                statusPaymentData);

                                        _pd.close();

                                        if (updatePaymentStatusObj.status ==
                                            'error') {
                                          Fluttertoast.showToast(
                                              msg: updatePaymentStatusObj
                                                  .message);
                                        } else {
                                          _shareNotaWhatsapp(
                                              context,
                                              orderHistory!,
                                              updatePaymentStatusObj);
                                        }
                                      },
                                      child: const Text('ORDER LUNAS',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                    ),
                                    width: double.infinity,
                                    height: 50),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _shareNotaWhatsapp(BuildContext context, OrderHistory orderHistory,
      UpdateStatusPaymentResponse updateStatusPaymentResponse) async {
    var invoiceNo = orderHistory.invoiceNo;
    var customerNm = orderHistory.customerNm;
    var customerPhone = orderHistory.customerPhone;

    // phone : get leading 0 or + or 6
    var leadingPhoneNo = customerPhone.substring(0, 1);
    if (leadingPhoneNo == "0") {
      var phone = customerPhone.substring(1);
      customerPhone = "+62" + phone;
    }

    var currentDate =
        updateStatusPaymentResponse.orderStatusPayment.transactionDate;
    var totalBayar = Util.rupiahFormat(int.parse(orderHistory.total));
    var dp = Util.rupiahFormat(int.parse(orderHistory.dp));
    var sisaBayar = Util.rupiahFormat(int.parse(orderHistory.sisaBayar));

    var status = "";
    if (updateStatusPaymentResponse.orderStatusPayment.isPaid == "0") {
      status = "BELUM LUNAS";
    } else {
      status = "LUNAS";
    }

    // create content of text message / nota
    StringBuffer sb = StringBuffer();
    sb.write("Mezisan\n");
    sb.write("\n");
    sb.write("Invoice No : $invoiceNo\n");
    sb.write("Customer : $customerNm\n");
    sb.write("Tgl Transaksi : $currentDate\n");
    sb.write("---------------------------------------------\n");
    for (var order in orderHistory.orderHistoryDetailList) {
      var itemName = order.itemNm;
      var itemPcs = order.pcs.toString();
      var itemPrice = Util.rupiahFormat(int.parse(order.itemPrice.toString()));
      var itemSubtotal =
          Util.rupiahFormat(int.parse(order.itemSubtotal.toString()));
      sb.write("$itemName ($itemPcs pcs x $itemPrice) : $itemSubtotal\n");
    }
    sb.write("---------------------------------------------\n");
    sb.write("Total Bayar : $totalBayar\n");
    sb.write("DP : $dp\n");
    sb.write("Sisa Bayar : $sisaBayar\n");
    sb.write("Status : $status\n");
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
      await OrderRepo().emptyCart();
      Navigator.pop(context); // after finished - back to home
    }
  }
}
