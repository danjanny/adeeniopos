// order page : kaos, umbul2, spanduk, banner, bendera

import 'package:app/authpos/models/user_model.dart';
import 'package:app/authpos/providers/auth_provider.dart';
import 'package:app/order/models/product_model.dart';
import 'package:app/order/providers/product_provider.dart';
import 'package:app/order/repos/order_repo.dart';
import 'package:app/order/views/cart_page.dart';
import 'package:app/order/views/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final GlobalKey<RefreshIndicatorState> _keyRefresh =
      GlobalKey<RefreshIndicatorState>();

  late int _totalRowOrder = 0;

  ProductResponse? _productResponse;

  @override
  void initState() {
    ProductProvider.getProduct().then((productResponse) {
      setState(() {
        _productResponse = productResponse;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ProductProvider(),
        child: Consumer<ProductProvider>(builder: (_, productProvider, __) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              title: const Text('Mezisan POS'),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 5, top: 5),
                  child: Stack(
                    children: [
                      IconButton(
                          onPressed: () async {
                            var logoutResponse =
                                await AuthProvider.userLogout();
                            if (logoutResponse == 1) {
                              // pop all screen, then go to first route
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                              Navigator.popAndPushNamed(context, '/login');
                            }
                          },
                          icon: const Icon(Icons.logout)),
                    ],
                  ),
                )
              ],
            ),
            body: Stack(children: [
              Container(
                margin: const EdgeInsets.only(bottom: 110),
                alignment: Alignment.center,
                child: FutureBuilder(
                    future: ProductProvider.getProduct(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        ProductResponse productResponseObj = snapshot.data;
                        if (productResponseObj.status == 'error') {
                          return RefreshIndicator(
                            key: _keyRefresh,
                            onRefresh: () => _refreshProducts(),
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                alignment: Alignment.center,
                                child: Text(productResponseObj.message),
                              ),
                            ),
                          );
                        } else {
                          return RefreshIndicator(
                            key: _keyRefresh,
                            onRefresh: () => _refreshProducts(),
                            child: ListView.builder(
                                itemCount: productResponseObj.product.length,
                                itemBuilder: (context, index) {
                                  var imgUrl = productResponseObj
                                      .product[index].productImg;

                                  return Container(
                                    margin: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Card(
                                      child: Container(
                                        margin: const EdgeInsets.all(25),
                                        child: ListTile(
                                            onTap: () {
                                              var product = productResponseObj
                                                  .product[index];
                                              Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetailPage(
                                                                  product:
                                                                      product)))
                                                  .then((value) {
                                                setState(() {
                                                  _totalRowOrder = value;
                                                });
                                              });
                                            },
                                            leading: CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  NetworkImage(imgUrl),
                                            ),
                                            title: Text(productResponseObj
                                                .product[index].productName)),
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                      }
                    }),
              ),
              FutureBuilder(
                future: OrderRepo().countOrderRow(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    var itemPcs = snapshot.data;
                    var itemPcsLabel = "";
                    if(itemPcs == 1) {
                      itemPcsLabel = itemPcs.toString() + ' item';
                    } else if(itemPcs > 1) {
                      itemPcsLabel = itemPcs.toString() + ' items';
                    }

                    if (snapshot.data > 0) {
                      return Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: SizedBox(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    var result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CartPage())).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Text('$itemPcsLabel \u22C5 Cek Keranjang',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  // style: ElevatedButton.styleFrom(
                                  //     primary: Colors.indigoAccent),
                                ),
                                width: double.infinity,
                                height: 50),
                          ));
                    } else {
                      return Container();
                    }
                  }
                },
              )
            ]),
          );
        }));
  }

  Widget example(BuildContext context) {
    // Flexible(
    //     flex: 1,
    //     child: Container(
    //       width: double.infinity,
    //       height: double.infinity,
    //       color: Colors.blue,
    //       alignment: Alignment.center,
    //       child: Container(),
    //     ))

    return Flexible(
      flex: 1,
      child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: ElevatedButton(
            onPressed: () async {
              var logoutResponse = await AuthProvider.userLogout();
              if (logoutResponse == 0) {
                // pop all screen, then go to first route
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.popAndPushNamed(context, '/login');
              }
            },
            child: const Text('Log out',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            style: ElevatedButton.styleFrom(primary: Colors.indigoAccent),
          ),
          width: double.infinity,
          height: 50),
    );
  }

  Future<ProductResponse?> _refreshProducts() async {
    ProductProvider.getProduct().then((productResponse) {
      setState(() {
        _productResponse = productResponse;
      });
    });
  }
}
