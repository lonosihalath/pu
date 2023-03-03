import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/controller/cart_controller.dart';
import 'package:purer/controller/order_controller.dart';
import 'package:purer/screen/cart_order/cart_screen.dart';
import 'package:purer/screen/detail/detail_product.dart';
import 'package:purer/screen/home/drawer.dart';
import 'package:purer/screen/order/order_pending.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/screen/signin_signup/signin.dart';
import 'package:purer/screen/signin_signup/signup.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:purer/widgets/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  CartController cartController = Get.put(CartController());
  OrderController orderController = Get.put(OrderController());
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());
  AddressShowController addressShowController =
      Get.put(AddressShowController());

  @override
  void initState() {
    ordershow();
    super.initState();
  }

  List data = [];
  bool loading = true;

  ordershow() async {
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
       // print(data);
      });
    }
  }

  final controller = Get.find<Controller>();
  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        toolbarHeight: 75,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
                builder: (context) => Container(
                      margin: EdgeInsets.only(left: screen * 0.045),
                      child: IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            //print(controller.photoList[0].phone);
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Image.asset(
                            'icons/menu.png',
                            width: 40,
                          )),
                    )),
            Image.asset(
              'icons/logo.png',
              width: 108,
            ),
            Container(
              margin: EdgeInsets.only(right: screen * 0.045),
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () async {
                    // final translator = GoogleTranslator();
                    // var translation = await translator
                    //     .translate("ວັນອາທິດ", to: 'en');
                    // print(translation);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartScreen()));
                  },
                  icon: Stack(children: [
                    Image.asset(
                      'icons/shopcart.png',
                      width: 40,
                    ),
                    GetBuilder<CartController>(
                        init: CartController(),
                        builder: (context) =>
                            cartController.itemCount.toString() == '0'
                                ? Text('')
                                : Positioned(
                                    right: 0,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.red),
                                      child: Text(
                                        cartController.itemCount.toString(),
                                        style: TextStyle(
                                            fontSize: 8, fontFamily: 'noto_me'),
                                      ),
                                    )))
                  ])),
            )
          ],
        ),
      ),
      bottomNavigationBar: loading == true
          ? Text('')
          : Container(
              margin: EdgeInsets.only(bottom: 18),
              color: Colors.white,
              child: data.length.toString() != '0'
                  ? SafeArea(
                      child: GetBuilder<OrderController>(
                          init: OrderController(),
                          builder: (context) => data.length.toString() != '0'
                              ? GestureDetector(
                                  onTap: () {
                                    Get.to(OrderPendingScreen());
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10),
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    width: screen,
                                    height: 85,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFF293275),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: const [
                                            Text(
                                                'ທ່ານມີອໍເດີ້ທີ່ກຳລັງດຳເນີນການຢູ່',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontFamily: 'noto_me'))
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Container(
                                              width: 32.39,
                                              child: Image.asset(
                                                  'icons/carshiping.png'),
                                            ),
                                            Container(
                                              height: 10,
                                              margin: EdgeInsets.only(left: 10),
                                              width: screen * 0.16,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.white),
                                            ),
                                            Container(
                                              height: 10,
                                              margin: EdgeInsets.only(left: 10),
                                              width: screen * 0.16,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color(0xFF7C82AC)),
                                            ),
                                            Container(
                                              height: 10,
                                              margin: EdgeInsets.only(left: 10),
                                              width: screen * 0.16,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color(0xFF7C82AC)),
                                            ),
                                            Container(
                                              height: 10,
                                              margin: EdgeInsets.only(left: 10),
                                              width: screen * 0.16,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Color(0xFF7C82AC)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  width: screen,
                                  height: 0.0,
                                )))
                  : SizedBox(),
            ),
      body: WillPopScope(
         onWillPop: () async => false,
        child: SafeArea(
          child: SingleChildScrollView(
              child: Container(
            child: Column(
              children: [
                BrannerSlider(),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: screen * 0.05),
                        child: Row(
                          children: [
                            Text('ສິນຄ້າຂອງເຮົາ',
                                style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 20,
                                    fontFamily: 'noto_bold'))
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Wrap(
                            runSpacing: screen * 0.045,
                            spacing: screen * 0.045,
                            children: List.generate(
                                products.length,
                                (index) => InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () {
                                        if (controller.photoList.isEmpty) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Detailproduct(
                                                        product: products
                                                            .where((element) =>
                                                                element.id ==
                                                                products[index]
                                                                    .id)
                                                            .toList(),
                                                      )));
                                        } else {
                                          if (controller.photoList[0].status
                                                      .toString() ==
                                                  'regular' &&
                                              products[index].size.toString() ==
                                                  'ຂະໜາດ 20 L') {
                                            showDialog(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15)),
                                                      backgroundColor:
                                                          Colors.white,
                                                      content: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 400,
                                                        height: 230,
                                                        child: Column(
                                                          children: [
                                                            Text('ຂໍອະໄພ!',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF5D5D5D),
                                                                    fontSize: 18,
                                                                    fontFamily:
                                                                        'noto_bold')),
                                                            SizedBox(height: 5),
                                                            Text(
                                                                'ທ່ານມີສິນຄ້ານີ້ຢູ່ໃນຄິວ ${data[0]['attributes']['day'].toString()} ແລ້ວ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF5D5D5D),
                                                                    fontSize: 15,
                                                                    fontFamily:
                                                                        'noto_me')),
                                                            SizedBox(height: 5),
                                                            Text(
                                                                'ຖ້າທ່ານຕ້ອງການນໍ້າເພີ່ມກະລຸນາຕິດຕໍ່ຫາແັອດມິນ',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xFF5D5D5D),
                                                                    fontSize: 15,
                                                                    fontFamily:
                                                                        'noto_me')),
                                                            SizedBox(height: 5),
                                                            Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    String
                                                                        googleUrl =
                                                                        'whatsapp://send?phone=+8562054444481&text=ສະບາຍດີ';
                                                                    await launchUrl(
                                                                        Uri.parse(
                                                                            googleUrl));
                                                                  },
                                                                  child: const Text(
                                                                      'ໂທລະສັບ:  ' +
                                                                          '02054444481' +
                                                                          '    ',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF293275),
                                                                          fontSize:
                                                                              16,
                                                                          fontFamily:
                                                                              'noto_regular')),
                                                                ),
                                                                GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    String
                                                                        googleUrl =
                                                                        'whatsapp://send?phone=+8562056677603&text=ສະບາຍດີ';
                                                                    await launchUrl(
                                                                        Uri.parse(
                                                                            googleUrl));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    child: Image
                                                                        .asset(
                                                                            'icons/wa.png'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(height: 20),
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.68,
                                                              height: 45,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Color(
                                                                                  0xFF293275),
                                                                          elevation:
                                                                              0),
                                                                  child: Text(
                                                                      'ຕົກລົງ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14,
                                                                          fontFamily:
                                                                              'noto_regular')),
                                                                  onPressed:
                                                                      () async {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                          } else {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Detailproduct(
                                                          product: products
                                                              .where((element) =>
                                                                  element.id ==
                                                                  products[index]
                                                                      .id)
                                                              .toList(),
                                                        )));
                                          }
                                        }
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Color(0xFFE5EFF9)),
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          width: screen * 0.43,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Column(
                                            children: [
                                              Hero(
                                                tag: products[index].image,
                                                child: Container(
                                                  width: screen,
                                                  height: screen1 * 0.20,
                                                  padding: products[index]
                                                              .image
                                                              .toString() ==
                                                          'images/purer4.png'
                                                      ? const EdgeInsets.only(
                                                          left: 13,
                                                          right: 13,
                                                          top: 25)
                                                      : const EdgeInsets.all(0),
                                                  child: Image.asset(
                                                      products[index].image),
                                                ),
                                              ),
                                              const SizedBox(height: 12),
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      products[index].name,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Color(0xff5D5D5D),
                                                          fontFamily:
                                                              'noto_regular'),
                                                    ),
                                                    Text(
                                                      products[index].size,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Color(0xff5D5D5D),
                                                          fontFamily:
                                                              'noto_regular'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Container(
                                                height: 30,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              top: 5),
                                                          child: Text(
                                                            nFormat(
                                                                products[index]
                                                                    .prict),
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xFF293275),
                                                                fontFamily:
                                                                    'copo_bold'),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 7),
                                                        Text(
                                                          'ກີບ',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Color(
                                                                  0xFF293275),
                                                              fontFamily:
                                                                  'noto_semi'),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 25,
                                                      margin: EdgeInsets.only(
                                                          left: 25),
                                                      child: IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            if (controller
                                                                .photoList
                                                                .isEmpty) {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (lono) =>
                                                                              SignUpWidthPhone()));
                                                            } else {
                                                              if (controller
                                                                          .photoList[
                                                                              0]
                                                                          .status
                                                                          .toString() ==
                                                                      'regular' &&
                                                                  products[index]
                                                                          .size
                                                                          .toString() ==
                                                                      'ຂະໜາດ 20 L') {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                              shape:
                                                                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                                                              backgroundColor:
                                                                                  Colors.white,
                                                                              content:
                                                                                  Container(
                                                                                alignment: Alignment.center,
                                                                                width: 400,
                                                                                height: 230,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text('ຂໍອະໄພ!', style: TextStyle(color: Color(0xFF5D5D5D), fontSize: 18, fontFamily: 'noto_bold')),
                                                                                    SizedBox(height: 5),
                                                                                    Text('ທ່ານມີສິນຄ້ານີ້ຢູ່ໃນຄິວ ${data[0]['attributes']['day'].toString()} ແລ້ວ', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF5D5D5D), fontSize: 15, fontFamily: 'noto_me')),
                                                                                    SizedBox(height: 5),
                                                                                    Text('ຖ້າທ່ານຕ້ອງການນໍ້າເພີ່ມກະລຸນາຕິດຕໍ່ຫາແັອດມິນ', textAlign: TextAlign.start, style: TextStyle(color: Color(0xFF5D5D5D), fontSize: 15, fontFamily: 'noto_me')),
                                                                                    SizedBox(height: 5),
                                                                                    Row(
                                                                                      children: [
                                                                                        GestureDetector(
                                                                                          onTap: () async {
                                                                                            String googleUrl = 'whatsapp://send?phone=${data[0]['phone'].toString()}&text=ສະບາຍດີ';
                                                                                            await launchUrl(Uri.parse(googleUrl));
                                                                                          },
                                                                                          child: Text('ໂທລະສັບ:  ' + '02054444481' + '    ', style: TextStyle(color: Color(0xFF293275), fontSize: 16, fontFamily: 'noto_regular')),
                                                                                        ),
                                                                                        GestureDetector(
                                                                                          onTap: () async {
                                                                                            String googleUrl = 'whatsapp://send?phone=+8562056677603&text=ສະບາຍດີ';
                                                                                            await launchUrl(Uri.parse(googleUrl));
                                                                                          },
                                                                                          child: Container(
                                                                                            width: 40,
                                                                                            height: 40,
                                                                                            child: Image.asset('icons/wa.png'),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                    SizedBox(height: 20),
                                                                                    Container(
                                                                                      width: MediaQuery.of(context).size.width * 0.68,
                                                                                      height: 45,
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        child: ElevatedButton(
                                                                                          style: ElevatedButton.styleFrom(primary: Color(0xFF293275), elevation: 0),
                                                                                          child: Text('ຕົກລົງ', style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'noto_regular')),
                                                                                          onPressed: () async {
                                                                                            Navigator.pop(context);
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ));
                                                              } else {
                                                                if (controller
                                                                    .photoList
                                                                    .isEmpty) {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder:
                                                                              (lono) =>
                                                                                  SignUpWidthPhone()));
                                                                } else {
                                                                  cartController.addItem(
                                                                      products[
                                                                              index]
                                                                          .id,
                                                                      products[
                                                                              index]
                                                                          .id,
                                                                      products[
                                                                              index]
                                                                          .prict,
                                                                      products[
                                                                              index]
                                                                          .name,
                                                                      products[
                                                                              index]
                                                                          .image,
                                                                      5,
                                                                      products[
                                                                              index]
                                                                          .discription,
                                                                      products[
                                                                              index]
                                                                          .size);
                                                                  showDialog(
                                                                      barrierDismissible:
                                                                          false,
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        Future.delayed(
                                                                            Duration(
                                                                                seconds: 1),
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(true);
                                                                        });
                                                                        return AlertDialog(
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          shape: RoundedRectangleBorder(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(20)),
                                                                          content:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            width:
                                                                                201,
                                                                            height:
                                                                                90,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              children: [
                                                                                Image.asset('icons/check.png', width: 40),
                                                                                SizedBox(height: 10),
                                                                                const Text(
                                                                                  'ເພີ່ມເຂົ້າກະຕ່າສຳເລັດແລ້ວ',
                                                                                  style: TextStyle(fontSize: 15, fontFamily: 'branding4', color: Color(0xFF4D4D4F)),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        );
                                                                      });
                                                                }
                                                              }
                                                            }
                                                          },
                                                          icon: Image.asset(
                                                              'icons/add.png',
                                                              width: 20)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 50)
              ],
            ),
          )),
        ),
      ),
    );
  }
}
