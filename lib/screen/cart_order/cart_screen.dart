import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/controller/cart_controller.dart';
import 'package:purer/controller/payment_controller.dart';
import 'package:purer/screen/checkout/confirm_order.dart';
import 'package:purer/screen/signin_signup/user/editAddress.dart';
import 'package:purer/widgets/format_money.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController cartController = Get.put(CartController());
  PaymentController paymentController = Get.put(PaymentController());
   AddressShowController addressShowController =
      Get.put(AddressShowController());

  late BitmapDescriptor customIcon;
  createMarker(context) {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
      configuration,
      'icons/ll.png',
    ).then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

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

  bool edit = false;

  @override
  Widget build(BuildContext context) {
    createMarker(context);
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
        title: const Text('ກະຕ່າ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        init: CartController(),
        builder: (context) => cartController.itemCount.toString() == '0'
            ? Container(
                height: 1,
              )
            : SafeArea(
                child: Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  width: screen,
                  height: 120,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ລວມມູນຄ່າ:',
                              style: TextStyle(
                                  color: Color(0xFF5D5D5D),
                                  fontSize: 17,
                                  fontFamily: 'noto_bold')),
                          GetBuilder<CartController>(
                              init: CartController(),
                              builder: (context) => Row(
                                    children: [
                                      Text(nFormat(cartController.totalAmount),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_bold')),
                                     const SizedBox(width: 8),
                                      const Text('ກີບ',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_bold')),
                                    ],
                                  ))
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: screen,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF293275)),
                            child: const Text('ສັ່ງຊື້',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFFFFFFF),
                                    fontFamily: 'noto_me')),
                            onPressed: () {
                              paymentController.addmoney('ຈ່າຍເງິນສົດປາຍທາງ');

                              addressShowController.statetList.length.toString() =='0' ? Get.to(EditAddress(lat: lat, long: long)) :
                              
                              Get.to(ConfirmOrder(
                                productbuynowl: [],  lat: addressShowController.statetList.isEmpty? double.parse('0.0'): addressShowController
                                          .statetList[0].latitiude,
                                      long:addressShowController.statetList.isEmpty? double.parse('0.0'): addressShowController
                                          .statetList[0].longtiude,
                              ));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: GetBuilder<CartController>(
                init: CartController(),
                builder: (context) => cartController.itemCount.toString() == '0'
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(height: 100),
                            Image.asset(
                              'icons/cart.png',
                              width: 70,
                            ),
                            SizedBox(height: 10),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: const Text('ທ່ານຍັງບໍ່ມິລາຍການໃນກະຕ່າ',
                                  style: TextStyle(
                                      color: Color(0xFF293275),
                                      fontSize: 12,
                                      fontFamily: 'noto_regular')),
                            )
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'ທ່ານມີ  ' +
                                      cartController.itemCount.toString() +
                                      '  ລາຍການໃນກະຕ່າ',
                                  style: const TextStyle(
                                      color: Color(0xFF5D5D5D),
                                      fontSize: 11,
                                      fontFamily: 'noto_semi')),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    edit = !edit;
                                  });
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: edit==false ? Row(
                                    children: const [
                                      Icon(
                                        Icons.edit_outlined,
                                        color: Color(0xFF293275),
                                        size: 20,
                                      ),
                                      Text('_ ແກ້ໄຂ',
                                          style: TextStyle(
                                              color: Color(0xFF293275),
                                              fontSize: 15,
                                              fontFamily: 'noto_semi')),
                                    ],
                                  ) :GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        edit =!edit;
                                      });
                                    },
                                    child: Container(
                                      child: const Icon(
                                            Icons.close,
                                            color: Color(0xFF293275),
                                            size: 25,
                                          ),
                                    ),
                                  )
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          GetBuilder<CartController>(
                              init: CartController(),
                              builder: (context) => Column(
                                    children: List.generate(
                                        cartController.items.length,
                                        (index) => Container(
                                              width: screen,
                                              margin:
                                                  EdgeInsets.only(bottom: 19),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          width: 89,
                                                          height: 89,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              color: Color(
                                                                  0xFFE5EFF9)),
                                                          child: Image.asset(
                                                              cartController
                                                                  .items.values
                                                                  .toList()[
                                                                      index]
                                                                  .image)),
                                                      SizedBox(width: 16),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              cartController
                                                                  .items.values
                                                                  .toList()[
                                                                      index]
                                                                  .name,
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF5D5D5D),
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      'noto_bold')),
                                                          Text(
                                                              cartController
                                                                  .items.values
                                                                  .toList()[
                                                                      index]
                                                                  .size,
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF5D5D5D),
                                                                  fontSize: 11,
                                                                  fontFamily:
                                                                      'noto_me')),
                                                          SizedBox(height: 13),
                                                          edit != false ? Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[index]
                                                                            .quantity >5) {
                                                                     cartController.delete(
                                                                          int.parse(cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .id),
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .id,
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .price,
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .name,
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .image,
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .quantity,
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[
                                                                                  index]
                                                                              .discription,
                                                                          cartController
                                                                              .items
                                                                              .values
                                                                              .toList()[index]
                                                                              .size);
                                                                    } else {
                                                                      
                                                                    }
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'icons/remove.png',
                                                                    width: 28,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    width: 12),
                                                                Text(
                                                                    cartController
                                                                        .items
                                                                        .values
                                                                        .toList()[
                                                                            index]
                                                                        .quantity
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Color(
                                                                            0xFF293275),
                                                                        fontFamily:
                                                                            'noto_bold')),
                                                                const SizedBox(
                                                                    width: 12),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    cartController.addItem(
                                                                        int.parse(cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .id),
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .id,
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .price,
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .name,
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .image,
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .quantity,
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[
                                                                                index]
                                                                            .discription,
                                                                        cartController
                                                                            .items
                                                                            .values
                                                                            .toList()[index]
                                                                            .size);
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                    'icons/add2.png',
                                                                    width: 24,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ) : Container(
                                                            height: 28,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                              nFormat(cartController
                                                                  .items.values
                                                                  .toList()[index]
                                                                  .price),
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Color(
                                                                      0xFF293275),
                                                                  fontFamily:
                                                                      'noto_bold')),
                                                         const SizedBox(width: 8),
                                                          const Text('ກີບ',
                                                              style: TextStyle(
                                                                  fontSize: 17,
                                                                  color: Color(0xFF293275),
                                                                  fontFamily:
                                                                      'noto_bold')),
                                                        ],
                                                      ),
                                                      SizedBox(height: 19),
                                                     edit!=false ? IconButton(onPressed: (){
                                                        cartController.removeitem(int.parse(cartController
                                                                  .items.values
                                                                  .toList()[index].id));
                                                      }, icon: Image.asset('icons/datete.png',width: 28,color: Color(
                                                                      0xFF293275),)) : Container()
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                  ))
                        ],
                      ),
              ))),
    );
  }
}
