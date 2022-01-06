import 'dart:io';

import 'package:app/api_endpoint.dart';
import 'package:app/authpos/models/user_model.dart';
import 'package:app/product/repos/product_repo.dart';
import 'package:app/product/views/product_list_page.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class AddProductImagePage extends StatefulWidget {
  late User user;

  AddProductImagePage({Key? key, required this.user}) : super(key: key);

  @override
  State<AddProductImagePage> createState() => _AddProductImagePageState();
}

class _AddProductImagePageState extends State<AddProductImagePage> {
  final ImagePicker _picker = ImagePicker();

  final List<String> _imgList = [];

  static const _locale = 'en';

  final _productPriceController = TextEditingController();
  final _productNmController = TextEditingController();
  final _productDescController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 5, top: 5),
              child: IconButton(
                  icon: const Icon(Icons.library_books),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListPage(user: user)),
                    );
                  }),
            ),
          ],
          elevation: 0,
          leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Tambah Produk'),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      // padding: const EdgeInsets.all(100),
                      color: Colors.white,
                      child: _imgList.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(80),
                              child: Column(
                                children: const [
                                  Icon(Icons.upload_file, size: 32),
                                  SizedBox(height: 10),
                                  Text(
                                    'Upload image produk anda',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : CarouselSlider(
                              options: CarouselOptions(viewportFraction: 1),
                              items: _imgList.map((imgUrl) {
                                var index = _imgList.indexOf(imgUrl);
                                return GestureDetector(
                                    onTap: () {
                                      int imgIndex = _imgList.indexOf(imgUrl);
                                      _showRemoveImageDialog(context, imgIndex);
                                      print('show dialog option to remove');
                                    },
                                    child: Stack(
                                      children: [
                                        Image.file(File(imgUrl),
                                            fit: BoxFit.cover, width: 500),
                                        index == 0
                                            ? Center(
                                                child: Badge(
                                                toAnimate: false,
                                                elevation: 0,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                padding: const EdgeInsets.only(
                                                    top: 20,
                                                    bottom: 20,
                                                    left: 33,
                                                    right: 33),
                                                shape: BadgeShape.square,
                                                badgeColor: Colors.red,
                                                badgeContent: const Text(
                                                    'Featured',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ))
                                            : Container()
                                      ],
                                    ));
                              }).toList())),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    color: Colors.white10,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 3,
                            child: GestureDetector(
                              child: Column(
                                children: const [
                                  Icon(Icons.camera_alt),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Camera')
                                ],
                              ),
                              onTap: () async {
                                XFile? cameraImg = await _picker.pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: 12);
                                setState(() {
                                  _imgList.add(cameraImg!.path);
                                });
                              },
                            ),
                          ),
                          const Flexible(
                              flex: 3,
                              child: VerticalDivider(
                                color: Colors.grey,
                              )),
                          Flexible(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () async {
                                List<XFile>? multiImg = await _picker
                                    .pickMultiImage(imageQuality: 12);
                                var multiImgPath = multiImg!
                                    .map((xFile) => xFile.path)
                                    .toList();
                                setState(() {
                                  _imgList.addAll(multiImgPath);
                                });
                              },
                              child: Column(
                                children: const [
                                  Icon(Icons.photo),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Gallery')
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.only(bottom: 30),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _productNmController,
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
                            controller: _productPriceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Harga harus diisi",
                                labelText: 'Harga'),
                            onChanged: (value) {
                              value = _formatNumber(value.replaceAll(',', ''));
                              _productPriceController.value = TextEditingValue(
                                text: value,
                                selection: TextSelection.collapsed(
                                    offset: value.length),
                              );
                            },
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
                          controller: _productDescController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              hintText: "Deskripsi", labelText: 'Deskripsi'),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Harga produk harus diisi';
                            }
                            return null;
                          },
                          maxLines: null,
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                  ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.all(30),
                      child: SizedBox(
                          child: ElevatedButton(
                              onPressed: () async {
                                // validate
                                final form = _formKey.currentState;

                                // if textfield is not validate && image product is empty
                                if (!form!.validate() && _imgList.isEmpty) {
                                  return;
                                }

                                var fields = {
                                  'company_id': user.companyId,
                                  'product_nm': _productNmController.text,
                                  'product_price': _productPriceController.text,
                                  'product_summary': _productDescController.text
                                };

                                var postProductDataResponse =
                                    await ProductRepo.postProductData(
                                        _imgList, fields);

                                if (postProductDataResponse.status == 'ok') {
                                  Fluttertoast.showToast(
                                      msg: postProductDataResponse.message);
                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: postProductDataResponse.message);
                                }
                              },
                              child: const Text('Tambah Produk',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                          width: double.infinity,
                          height: 50))
                ],
              ),
            ),
          ),
        ));
  }

  void _showRemoveImageDialog(BuildContext context, int imgIndex) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Info'),
              content: const Text('Hapus photo ini ?'),
              actions: [
                TextButton(onPressed: () {}, child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _imgList.removeAt(imgIndex);
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Ok'))
              ],
            ));
  }
}
