import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/controller/buynow_model.dart';
import 'package:http/http.dart' as http;
import 'package:purer/controller/payment_controller.dart';
import 'package:purer/screen/order/tacking_done.dart';
import 'package:purer/screen/order/tacking_pending.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../checkout/confirm_order.dart';

class OrderPendingScreen extends StatefulWidget {
  const OrderPendingScreen({Key? key}) : super(key: key);

  @override
  State<OrderPendingScreen> createState() => _OrderPendingScreenState();
}

class _OrderPendingScreenState extends State<OrderPendingScreen> {
  final controller = Get.find<Controller>();
  PaymentController paymentController = Get.put(PaymentController());
  AddressShowController addressShowController =
      Get.put(AddressShowController());
  bool loading = true;

  @override
  void initState() {
    Ordershow();
    super.initState();
  }

  Map<int, BuynowItem> productbuynow = {};

  void addItembuy(int productId, String image, String name, int quantity,
      int price, String size, String discription) {
    clear();
    productbuynow.putIfAbsent(
      productId,
      () => BuynowItem(
          id: productId,
          name: name,
          quantity: quantity,
          price: price,
          image: image,
          size: size,
          discription: discription),
    );
  }

  void clear() {
    productbuynow = {};
  }

  List data = [];

  Ordershow() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? id = sharedPreferences.getString('id');
    String? token = sharedPreferences.getString('token');
    var response = await http.get(
        Uri.parse('https://purer.cslox-th.ruk-com.la/api/order/show/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body)['data']
            .where((p0) =>
                p0['attributes']['status'].toString() == 'Pending' ||
                p0['attributes']['status'].toString() == 'Confirmed' ||
                p0['attributes']['status'].toString() == 'Processing')
            .toList();
        loading = false;
        print(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          margin: const EdgeInsets.only(left: 22),
          child: IconButton(
              padding: const EdgeInsets.all(0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff717171),
              )),
        ),
        title: const Text('?????????????????????????????????????????????????????????????????????',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(left: 22, right: 22),
        child: loading == true
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Column(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      const Text('???????????????????????????',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 17,
                              fontFamily: 'noto_me')),
                    ],
                  ),
                ),
              )
            : data.isEmpty
                ? Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, top: 150),
                      child: const Text('???????????????????????????????????????????????????????????????????????????',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                    ),
                  )
                : Column(
                    children: [
                      Column(
                        children: List.generate(
                            data.length,
                            (index) => Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          //
                                          child: Column(
                                            children: List.generate(
                                              data[index]['attributes']
                                                      ['order_item']
                                                  .length,
                                              (index1) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (lono) =>
                                                                  OrderSatatusPending(
                                                                      order: data[
                                                                          index])));
                                                    },
                                                    child: Container(
                                                      width: screen,
                                                      color: Colors.white,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              bottom: 10),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                  width: 89,
                                                                  height: 89,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                      color: const Color(
                                                                          0xFFE5EFF9)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Image.asset(data[index]['attributes']['order_item'][index1]['attributes']
                                                                            [
                                                                            'image']
                                                                        .toString()),
                                                                  )),
                                                              const SizedBox(
                                                                  width: 15),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    data[index]['attributes']['order_item'][index1]['attributes']
                                                                            [
                                                                            'product_name']
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Color(
                                                                            0xFF293275),
                                                                        fontSize:
                                                                            15,
                                                                        fontFamily:
                                                                            'noto_semi'),
                                                                  ),
                                                                  Text(
                                                                      data[index]['attributes']['order_item'][index1]['attributes']
                                                                              [
                                                                              'size']
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          color: Color(
                                                                              0xFF293275),
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              'noto_semi')),
                                                                  const SizedBox(
                                                                      height:
                                                                          20),
                                                                  data[index]['attributes']['order_item'][index1]['attributes']['amount']
                                                                              .toString() !=
                                                                          'null'
                                                                      ? Text(
                                                                          '???????????????: ' +
                                                                              data[index]['attributes']['order_item'][index1]['attributes']['amount']
                                                                                  .toString(),
                                                                          style: const TextStyle(
                                                                              color: Color(0xFF293275),
                                                                              fontSize: 10,
                                                                              fontFamily: 'noto_semi'))
                                                                      : const Text(''),
                                                                ],
                                                              ),
                                                            ],
                                                          ),

                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      nFormat(int.parse(data[index]['attributes']['order_item'][index1]
                                                                              [
                                                                              'attributes']
                                                                          [
                                                                          'price'])),
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Color(
                                                                            0xFF293275),
                                                                        fontSize:
                                                                            17,
                                                                        fontFamily:
                                                                            'copo_bold',
                                                                      )),
                                                                  const Text(
                                                                      '  ?????????',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFF293275),
                                                                        fontSize:
                                                                            17,
                                                                        fontFamily:
                                                                            'noto_semi',
                                                                      )),
                                                                ],
                                                              ),
                                                              Text(
                                                                  data[index]['attributes']
                                                                          [
                                                                          'order_date']
                                                                      .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Color(
                                                                        0xFFC7C7C7),
                                                                    fontSize:
                                                                        10,
                                                                    fontFamily:
                                                                        'noto_semi',
                                                                  )),
                                                              const SizedBox(
                                                                  height: 10),
                                                              // GestureDetector(
                                                              //   child:
                                                              //       Container(
                                                              //     height: 26,
                                                              //     width: 114,
                                                              //     decoration:
                                                              //         BoxDecoration(
                                                              //       borderRadius:
                                                              //           BorderRadius.circular(
                                                              //               10),
                                                              //       color: Color(
                                                              //           0xFF293275),
                                                              //     ),
                                                              //     child: Center(
                                                              //       child: Text(
                                                              //           '??????????????????????????????????????????',
                                                              //           style:
                                                              //               TextStyle(
                                                              //             color:
                                                              //                 Colors.white,
                                                              //             fontSize:
                                                              //                 10,
                                                              //             fontFamily:
                                                              //                 'noto_semi',
                                                              //           )),
                                                              //     ),
                                                              //   ),
                                                              //   onTap: (() {
                                                              //     addItembuy(
                                                              //         int.parse(data[index]['id']
                                                              //             .toString()),
                                                              //         data[index]['attributes']['order_item'][index1]['attributes']['image']
                                                              //             .toString(),
                                                              //         data[index]['attributes']['order_item'][index1]['attributes']['product_name']
                                                              //             .toString(),
                                                              //         int.parse(
                                                              //             data[index]['attributes']['order_item'][index1]['attributes']['amount']
                                                              //                 .toString()),
                                                              //         int.parse(
                                                              //             data[index]['attributes']['order_item'][index1]['attributes']['price']
                                                              //                 .toString()),
                                                              //         data[index]['attributes']['order_item'][index1]['attributes']
                                                              //                 ['size']
                                                              //             .toString(),
                                                              //         '5555');
                                                              //     Get.to(
                                                              //         ConfirmOrder(
                                                              //       productbuynowl:
                                                              //           productbuynow
                                                              //               .values
                                                              //               .toList(),
                                                              //       lat: addressShowController
                                                              //               .statetList
                                                              //               .isEmpty
                                                              //           ? double.parse(
                                                              //               '0.0')
                                                              //           : addressShowController
                                                              //               .statetList[0]
                                                              //               .latitiude,
                                                              //       long: addressShowController
                                                              //               .statetList
                                                              //               .isEmpty
                                                              //           ? double.parse(
                                                              //               '0.0')
                                                              //           : addressShowController
                                                              //               .statetList[0]
                                                              //               .longtiude,
                                                              //     ));
                                                              //   }),
                                                              // )
                                                            ],
                                                          ),

                                                          // Text(data[index]['attributes']['latitiude_id'].toString()),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),
                                    Container(
                                      height: 1.5,
                                      width: screen,
                                      color: const Color(0xFFEBEBEB),
                                    )
                                  ],
                                )),
                      )
                    ],
                  ),
      )),
    );
  }
}
