import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/controller/buynow_model.dart';
import 'package:purer/controller/cart_controller.dart';
import 'package:purer/controller/payment_controller.dart';
import 'package:purer/screen/cart_order/cart_screen.dart';
import 'package:purer/screen/checkout/confirm_order.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/screen/signin_signup/signin.dart';
import 'package:purer/screen/signin_signup/signup.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/screen/signin_signup/user/editAddress.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:get/get.dart';

class Detailproduct extends StatefulWidget {
  final List<Procudt> product;
  const Detailproduct({Key? key, required this.product}) : super(key: key);

  @override
  State<Detailproduct> createState() => _DetailproductState();
}

class _DetailproductState extends State<Detailproduct> {
  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  double lat = 0.0;
  double long = 0.0;
  CartController cartController = Get.put(CartController());
  int qty = 5;

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

  PaymentController paymentController = Get.put(PaymentController());
  AddressShowController addressShowController =
      Get.put(AddressShowController());
  final controller = Get.find<Controller>();

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
        title: Image.asset(
          'icons/logo.png',
          width: 108,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
                icon: Stack(children: [
                  Image.asset(
                    'icons/shopcart.png',
                    width: 36,
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
                                        borderRadius: BorderRadius.circular(8),
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screen * 0.41,
                  height: 46,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFFE5EFF9), elevation: 0),
                      child: const Text('ເພີ່ມເຂົ້າກະຕ່າ',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                      onPressed: () {
                        if (controller.photoList.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (lono) => SignUpWidthPhone()));
                        } else {
                          cartController.addItem(
                            widget.product[0].id,
                            widget.product[0].id,
                            widget.product[0].prict,
                            widget.product[0].name,
                            widget.product[0].image,
                            qty,
                            widget.product[0].discription,
                            widget.product[0].size,
                          );
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.of(context).pop(true);
                                });
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  content: Container(
                                    alignment: Alignment.center,
                                    width: 201,
                                    height: 90,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'icons/check.png',
                                          width: 40,
                                        ),
                                        SizedBox(height: 10),
                                        const Text(
                                          'ເພີ່ມເຂົ້າກະຕ່າສຳເລັດແລ້ວ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'branding4',
                                              color: Color(0xFF4D4D4F)),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  width: screen * 0.41,
                  height: 46,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF293275), elevation: 0),
                      child: const Text('ສັ່ງຊື້',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                      onPressed: () {
                        if (controller.photoList.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (lono) => SignUpWidthPhone()));
                        } else {
                          addItembuy(
                              widget.product[0].id,
                              widget.product[0].image,
                              widget.product[0].name,
                              qty,
                              widget.product[0].prict,
                              widget.product[0].size,
                              widget.product[0].discription);
                          paymentController.addmoney('ຈ່າຍເງິນສົດປາຍທາງ');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      addressShowController.statetList.isEmpty
                                          ? EditAddress(lat: lat, long: long)
                                          : ConfirmOrder(
                                              productbuynowl:
                                                  productbuynow.values.toList(),
                                              lat: addressShowController
                                                      .statetList.isEmpty
                                                  ? double.parse('0.0')
                                                  : addressShowController
                                                      .statetList[0].latitiude,
                                              long: addressShowController
                                                      .statetList.isEmpty
                                                  ? double.parse('0.0')
                                                  : addressShowController
                                                      .statetList[0].longtiude,
                                            )));
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: widget.product[0].image,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    width: screen,
                    height: screen1 * 0.40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE5EFF9)),
                    child: Image.asset(
                      widget.product[0].image,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Text(widget.product[0].name,
                      style: const TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 22,
                          fontFamily: 'noto_bold')),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: screen,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 14),
                              child: Text(
                                nFormat(widget.product[0].prict),
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xFF293275),
                                    fontFamily: 'copo_bold'),
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(
                              'ກີບ',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xFF293275),
                                  fontFamily: 'noto_semi'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (qty > 5) {
                                    setState(() {
                                      qty--;
                                    });
                                  }
                                },
                                icon: Image.asset(
                                  'icons/remove.png',
                                )),
                            const SizedBox(width: 5),
                            Text(qty.toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_bold')),
                            const SizedBox(width: 5),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    qty++;
                                  });
                                },
                                icon: Image.asset(
                                  'icons/add2.png',
                                  width: 28,
                                )),
                          ],
                        )
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: const Text('ລາຍລະອຽດ',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 22,
                          fontFamily: 'noto_bold')),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(widget.product[0].discription,
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 14,
                          fontFamily: 'noto_regular')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
