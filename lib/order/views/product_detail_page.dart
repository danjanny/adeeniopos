import 'package:app/order/models/order_model.dart';
import 'package:app/order/models/product_model.dart';
import 'package:app/order/providers/product_provider.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:app/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';


class ProductDetailPage extends StatefulWidget {
  Product product;

  ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _formKey = GlobalKey<FormState>();

  final _itemPriceFormController = TextEditingController();
  final _itemPcsFormController = TextEditingController();
  final _itemNoteFormController = TextEditingController();

  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    var product = widget.product; // product detail object
    var productImg = product.productImg;
    return ChangeNotifierProvider(
        create: (context) => ProductProvider(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            title: const Text('Product Detail'),
          ),
          body: Container(
            color: Colors.white10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(productImg))),
                  ),
                ),
                Flexible(
                    flex: 3,
                    child: Consumer<ProductProvider>(
                        builder: (_, productProvider, __) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(product.productName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  productProvider.itemSubtotal == 0
                                      ? const Text('')
                                      : Text(
                                          Util.rupiahFormat(
                                              productProvider.itemSubtotal),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextFormField(
                                              controller:
                                                  _itemPriceFormController,
                                              onChanged: (value) {
                                                value = _formatNumber(value.replaceAll(',', ''));
                                                _itemPriceFormController.value = TextEditingValue(
                                                  text: value,
                                                  selection: TextSelection.collapsed(offset: value.length),
                                                );
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText: "Harga harus diisi",
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(Icons.money),
                                                  ),
                                                  labelText: 'Harga'),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'Username harus diisi';
                                                }
                                                return null;
                                              }),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              controller:
                                                  _itemPcsFormController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  hintText:
                                                      "Item pcs harus diisi",
                                                  prefixIcon: Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 1),
                                                    child: Icon(Icons
                                                        .add_shopping_cart_sharp),
                                                  ),
                                                  labelText: 'Pcs'),
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'Username harus diisi';
                                                }
                                                return null;
                                              }),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: _itemNoteFormController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                hintText: "Catatan",
                                                prefixIcon: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 1),
                                                  child:
                                                      Icon(Icons.note_outlined),
                                                ),
                                                labelText: 'Catatan'),
                                            validator: (String? value) {
                                              return null;
                                            },
                                            maxLines: null,
                                          ),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  var itemPrice = int.parse(
                                                      _itemPriceFormController
                                                          .text.replaceAll(',', ''));
                                                  var itemPcs = int.parse(
                                                      _itemPcsFormController
                                                          .text.replaceAll(',', ''));
                                                  productProvider
                                                      .calculateSubtotal(
                                                          itemPrice, itemPcs);
                                                },
                                                child: const Text('Hitung',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16)),
                                                // style: ElevatedButton.styleFrom(
                                                //     primary: Colors.indigoAccent),
                                              ),
                                              width: double.infinity,
                                              height: 50)
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    })),
                Flexible(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                          child: Consumer<ProductProvider>(
                              builder: (_, productProvider, __) {
                            return ElevatedButton(
                              onPressed: () async {
                                // init value of order model
                                var productId = int.parse(product.id);
                                var itemName = product.productName;
                                var itemPrice =
                                    int.parse(_itemPriceFormController.text.replaceAll(',', ''));
                                var itemPcs =
                                    int.parse(_itemPcsFormController.text.replaceAll(',', ''));
                                var itemNote = _itemNoteFormController.text;
                                var itemSubtotal = itemPrice * itemPcs;

                                // create order model
                                var orderData = Order(productId, itemName,
                                    itemPrice, itemPcs, itemNote, itemSubtotal);

                                // add order to cart, get last order id
                                var lastOrderId =
                                    await OrderRepo().addOrderToCart(orderData);
                                var totalOrderRow =
                                    productProvider.orderRowCount();

                                // if order successfully added to cart, back to product index
                                if (lastOrderId > 0) {
                                  Navigator.pop(context, totalOrderRow);
                                } else {
                                  // if not, show error toast
                                  Fluttertoast.showToast(
                                      msg: "Order item gagal ditambahkan");
                                }
                              },
                              child: const Text('Tambahkan ke Keranjang',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.indigoAccent),
                            );
                          }),
                          width: double.infinity,
                          height: 50),
                    ))
              ],
            ),
          ),
        ));
  }
}
