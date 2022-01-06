import 'package:app/authpos/models/user_model.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatefulWidget {
  late User user;

  ProductListPage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text('List Produk'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Text('List Produk'),
        ));
  }
}
