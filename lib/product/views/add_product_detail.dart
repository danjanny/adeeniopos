import 'package:app/authpos/models/user_model.dart';
import 'package:flutter/material.dart';

class AddProductDetail extends StatefulWidget {
  late User user;

  AddProductDetail({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddProductDetailState();
}

class _AddProductDetailState extends State<AddProductDetail> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    var bottom = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Tambah Detail Produk'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: Container(
                padding: const EdgeInsets.all(30),
                margin: const EdgeInsets.only(bottom: 30),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  hintText: "Isi nama produk anda",
                                  labelText: 'Nama Produk'),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Nama produk harus diisi';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Harga harus diisi", labelText: 'Harga'),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Harga produk harus diisi';
                                }
                                return null;
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                                hintText: "Deskripsi", labelText: 'Deskripsi'),
                            validator: (String? value) {
                              return null;
                            },
                            maxLines: null,
                          ),
                          const SizedBox(height: 20)
                        ],
                      ),
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                            child: ElevatedButton(
                                onPressed: () async {},
                                child: const Text('Tambah Produk',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))),
                            width: double.infinity,
                            height: 50))
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )
    );
  }
}
