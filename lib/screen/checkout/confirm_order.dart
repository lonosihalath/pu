import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/controller/buynow_model.dart';
import 'package:purer/controller/cart_controller.dart';
import 'package:purer/controller/order_controller.dart';
import 'package:purer/controller/payment_controller.dart';
import 'package:purer/screen/home/homepage.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/screen/signin_signup/user/editAddress.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class ConfirmOrder extends StatefulWidget {
  final List<BuynowItem> productbuynowl;
  final lat;
  final long;
  const ConfirmOrder(
      {Key? key,
      required this.productbuynowl,
      required this.lat,
      required this.long})
      : super(key: key);

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  Completer<GoogleMapController> _controller = Completer();
  AddressShowController addressShowController =
      Get.find<AddressShowController>();
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

  late Marker markers;
  @override
  void initState() {
    totaldiposit();
    getCurrentLocation();
    addressShowController.statetList.isEmpty ? null : setdata();
    super.initState();
    markers = Marker(
      markerId: MarkerId('1'),
      position: LatLng(double.parse(widget.lat), double.parse(widget.long)),
      infoWindow: InfoWindow(
          title: 'ທີ່ຢູ່ຂອງທ່ານ',
          onTap: () {
            print('Tap');
          }),
    );
  }

  bool state = false;
  bool statemaps = false;

  final controller = Get.find<Controller>();
  DateTime date = DateTime.now();

  final translator = GoogleTranslator();

  String totaldiposits = '';
  String amountdiposits = '';

  List idaddorder = [];

  totaldiposit() {
    widget.productbuynowl.isEmpty
        ? List.generate(
            cartController.items.length,
            (index1) => List.generate(
                    cartController.items.values
                        .toList()
                        .where((element) =>
                            element.size.toString() == 'ຂະໜາດ 20 L')
                        .toList()
                        .length, (index) {
                  setState(() {
                    totaldiposits =
                        '${int.parse('50000') * int.parse(cartController.items.values.toList()[index1].quantity.toString())}';
                    amountdiposits = cartController.items.values
                        .toList()[index1]
                        .quantity
                        .toString();
                  });
                }))
        : List.generate(
            widget.productbuynowl.length,
            (index) => setState(() {
                  if (widget.productbuynowl[0].size.toString() ==
                      'ຂະໜາດ 20 L') {
                    totaldiposits =
                        '${int.parse('50000') * int.parse(widget.productbuynowl[0].quantity.toString())}';
                    amountdiposits =
                        widget.productbuynowl[0].quantity.toString();
                  }
                }));

    print('===>D: ' + totaldiposits);
    print('===>D: ' + amountdiposits);
  }

  _addroder() async {
    final translator = GoogleTranslator();
    var translation =
        await translator.translate(DateFormat('EEEE').format(date), to: 'lo');
    // showDialog(context: context, builder: (context) => dialog());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var data = {
      "user_id": controller.photoList[0].id.toString(),
      "division_id": nameDivision.toString(),
      "district_id": nameDistrict.toString(),
      "state_id": nameState.toString(),
      "longitude_id": addressShowController.statetList[0].longtiude.toString(),
      "latitiude_id": addressShowController.statetList[0].latitiude.toString(),
      "phone": controller.photoList[0].phone.toString(),
      "notes": addressShowController.statetList[0].notes.toString(),
      "day": translation.toString(),
      "amount_cash": cartController.totalAmount.toString(),
      "order_month": DateFormat('LLLL').format(date),
      "order_year": DateFormat('y').format(date),
      "order_type": controller.photoList[0].status.toString(),
      "deposit_order_normal_price": totaldiposits.toString(),
      'order_items': List.generate(
          cartController.items.length,
          (index) => {
                "image": cartController.items.values
                    .toList()[index]
                    .image
                    .toString(),
                "product_name":
                    cartController.items.values.toList()[index].name.toString(),
                "size":
                    cartController.items.values.toList()[index].size.toString(),
                "price": cartController.items.values
                    .toList()[index]
                    .price
                    .toString(),
                "amount": cartController.items.values
                    .toList()[index]
                    .quantity
                    .toString(),
                "total_amount": int.parse(cartController.items.values
                        .toList()[index]
                        .price
                        .toString()) *
                    int.parse(cartController.items.values
                        .toList()[index]
                        .quantity
                        .toString()),
              }),
    };
    var res =
        await CallApi().postDataOrder(data, 'order/insert/normalUser', token);

    print(res.body);
    print(token);
    print('Response status1: ${res.statusCode}');
    if (res.statusCode == 201) {
        setState(() {
        idaddorder.add(jsonDecode(res.body)['order']['id'].toString());
      });
      insertDeposit();
      update();
      showLog();
      //updatediposit_status();
    }
  }

  ///////////////////////////////////////////////////////////////////////////////
  _addroderbuynow() async {
    final translator = GoogleTranslator();
    var translation =
        await translator.translate(DateFormat('EEEE').format(date), to: 'lo');
    // showDialog(context: context, builder: (context) => dialog());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var data = {
      "user_id": controller.photoList[0].id.toString(),
      "division_id": nameDivision.toString(),
      "district_id": nameDistrict.toString(),
      "state_id": nameState.toString(),
      "longitude_id": addressShowController.statetList[0].longtiude.toString(),
      "latitiude_id": addressShowController.statetList[0].latitiude.toString(),
      "phone": controller.photoList[0].phone.toString(),
      "notes": addressShowController.statetList[0].notes.toString(),
      "day": translation.toString(),
      "amount_cash":
          '${int.parse(widget.productbuynowl[0].price.toString()) * int.parse(widget.productbuynowl[0].quantity.toString())}',
      "order_month": DateFormat('LLLL').format(date),
      "order_year": DateFormat('y').format(date),
      "order_type": 'normal',
      "deposit_order_normal_price": totaldiposits.toString(),
      'order_items': List.generate(
          widget.productbuynowl.length,
          (index) => {
                "image": widget.productbuynowl[0].image.toString(),
                "product_name": widget.productbuynowl[0].name.toString(),
                "size": widget.productbuynowl[0].size.toString(),
                "price": widget.productbuynowl[0].price.toString(),
                "amount": widget.productbuynowl[0].quantity.toString(),
                "total_amount":
                    int.parse(widget.productbuynowl[0].price.toString()) *
                        int.parse(widget.productbuynowl[0].quantity.toString()),
              }),
    };
    var res =
        await CallApi().postDataOrder(data, 'order/insert/normalUser', token);

    // print(res.body);
    // print(token);
    // print('Response status1: ${res.statusCode}');
    if (res.statusCode == 201) {
      setState(() {
        idaddorder.add(jsonDecode(res.body)['order']['id'].toString());
      });
      insertDeposit();
      update();
      showLog();
      //updatediposit_status();
    }
    // if (controller.photoList[0].status == 'regular') {
    //   var res1 = await CallApi()
    //       .postDataOrder(data, 'order/insert/regularUser', token);
    //   var res2 =
    //       await CallApi().postDataOrder(data, 'order/insert/normalUser', token);
    //   var dataorder = json.decode(res1.body);

    //   print(res1.body);
    //   print(res2.body);
    //   print(token);
    //   print('Response status1: ${res1.statusCode}');
    //   print('Response status2: ${res2.statusCode}');
    //   if (res1.statusCode == 201 && res2.statusCode == 201) {
    //     showLog();
    //   }
    // } else {
    //   var res =
    //       await CallApi().postDataOrder(data, 'order/insert/normalUser', token);

    //   print(res.body);
    //   print(token);
    //   print('Response status1: ${res.statusCode}');
    //   if (res.statusCode == 201) {
    //     showLog();
    //   }
    // }
  }

  insertDeposit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
   // print('null!!!!');
    var data = {
      'user_id': controller.photoList[0].id.toString(),
      'order_id': idaddorder[0].toString(),
      'approver_name': 'Purer',
      'approver_surname': 'Purer',
      'customer_signature': '',
      'price': totaldiposits.toString(),
      'amount_bottle':amountdiposits.toString(),
    };
    var res = await CallApi().postDatadeposit(data, 'deposit/insert', token);
    // print('statusCode====>' + res.statusCode.toString());
    // print('statusCode====>' + res.body.toString());
    var body = json.decode(res.body);
  }

  Future showLog() {
    return Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'icons/check.png',
                      width: 40,
                    ),
                    SizedBox(height: 10),
                    const Text(
                      'ທ່ານສັ່ງຊື້ເລັດແລ້ວ',
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
      cartController.clear();
    });
  }

  Future getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
  }

  late double lat =
      double.parse(addressShowController.statetList[0].latitiude.toString());
  late double long =
      double.parse(addressShowController.statetList[0].longtiude.toString());

  void deeplink() async {
    var reponse = await http.get(Uri.parse(
        'comgooglemaps://?saddr=&daddr=$lat,$long&directionsmode=driving'));
    print(reponse.body);
  }

  var nameState;
  var nameDistrict;
  var nameDivision;

  update() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'deposit_status': 'ມັດຈຳແລ້ວ',
    };
    var res = await CallApi().postDataupDate(data, id, token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      // print(body);
      // print('statusCode====>' + res.statusCode.toString());
    }
  }

  setdata() {
    List.generate(
        stateController.statetList.length,
        (index) => stateController.statetList[index].id.toString() ==
                addressShowController.statetList[0].stateId.toString()
            ? setState(() {
                nameState =
                    stateController.statetList[index].stateName!.toString();
                print('===> ${nameState}');
              })
            : null);
    List.generate(
        districtController.statetList.length,
        (index) => districtController.statetList[index].id.toString() ==
                addressShowController.statetList[0].districtId.toString()
            ? setState(() {
                nameDistrict = districtController
                    .statetList[index].districtName!
                    .toString();
                print('===> ${nameDistrict}');
              })
            : null);

    List.generate(
        divisionController.statetList.length,
        (index) => divisionController.statetList[index].id.toString() ==
                addressShowController.statetList[0].divisionId.toString()
            ? setState(() {
                nameDivision = divisionController
                    .statetList[index].divisionName!
                    .toString();
                print('===> ${nameDivision}');
              })
            : null);
    List.generate(addressShowController.statetList.where((p0) => false).length,
        (index) => null);
  }

  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());

  CartController cartController = Get.put(CartController());
  PaymentController paymentController = Get.put(PaymentController());
  OrderController orderController = Get.put(OrderController());

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );

  updatediposit_status() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'deposit_status': 'ມັດຈຳແລ້ວ',
    };
    var res = await CallApi().postDataupDate(data, '${id}', token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      controller.onInit();
      print(body);
      print('statusCode====>' + res.statusCode.toString());
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
          title: const Text('ຢືນຢັນການສັ່ງຊື້',
              style: TextStyle(
                  color: Color(0xFF293275),
                  fontSize: 18,
                  fontFamily: 'noto_semi')),
          centerTitle: true,
        ),
        bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              margin: EdgeInsets.only(bottom: 18),
              padding: const EdgeInsets.only(left: 24, right: 24),
              width: screen,
              height: 210,
              child: Column(
                children: [
                  Container(
                    height: 110,
                    child: widget.productbuynowl.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(
                                cartController.items.length,
                                (index) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // ignore: prefer_interpolation_to_compose_strings
                                        Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            cartController.items.values
                                                    .toList()[index]
                                                    .name +
                                                '  ' +
                                                cartController.items.values
                                                    .toList()[index]
                                                    .size +
                                                ' ' +
                                                '(x${cartController.items.values.toList()[index].quantity})',
                                            style: const TextStyle(
                                                color: Color(0xFF5D5D5D),
                                                fontSize: 15,
                                                fontFamily: 'noto_regular')),
                                        Text(
                                            nFormat(cartController.items.values
                                                        .toList()[index]
                                                        .price *
                                                    cartController.items.values
                                                        .toList()[index]
                                                        .quantity) +
                                                '  ກີບ',
                                            style: TextStyle(
                                                color: Color(0xFF5D5D5D),
                                                fontSize: 15,
                                                fontFamily: 'noto_regular')),
                                      ],
                                    )),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // ignore: prefer_interpolation_to_compose_strings
                                  Text(
                                      widget.productbuynowl[0].name +
                                          '  ' +
                                          widget.productbuynowl[0].size +
                                          ' ' +
                                          '(x${widget.productbuynowl[0].quantity})',
                                      style: const TextStyle(
                                          color: Color(0xFF5D5D5D),
                                          fontSize: 15,
                                          fontFamily: 'noto_regular')),
                                  Text(
                                      nFormat(widget.productbuynowl[0].price *
                                              widget
                                                  .productbuynowl[0].quantity) +
                                          '  ກີບ',
                                      style: TextStyle(
                                          color: Color(0xFF5D5D5D),
                                          fontSize: 15,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            ],
                          ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: screen,
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
                            widget.productbuynowl.isEmpty
                                ? GetBuilder<CartController>(
                                    init: CartController(),
                                    builder: (context) => Row(
                                          children: [
                                            Text(
                                                nFormat(
                                                    cartController.totalAmount),
                                                style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xFF293275),
                                                    fontFamily: 'noto_bold')),
                                            SizedBox(width: 8),
                                            const Text('ກີບ',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xFF293275),
                                                    fontFamily: 'noto_bold')),
                                          ],
                                        ))
                                : Row(
                                    children: [
                                      Text(
                                          nFormat(
                                              widget.productbuynowl[0].price *
                                                  widget.productbuynowl[0]
                                                      .quantity),
                                          style: const TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_bold')),
                                      SizedBox(width: 8),
                                      const Text('ກີບ',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_bold')),
                                    ],
                                  )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          width: screen,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF293275)),
                              child: Text('ສັ່ງຊື້',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: 'noto_me')),
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                    context: context,
                                    builder: (lono) => dialog3());
                                widget.productbuynowl.isEmpty
                                    ? _addroder()
                                    : _addroderbuynow();
                                // if (widget.productbuynowl.isEmpty) {
                                //   List.generate(
                                //       cartController.items.length,
                                //       (index) => {
                                //             orderController.addItem(
                                //                 Random()
                                //                     .nextInt(1000000000 + 1),
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .id,
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .price,
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .name,
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .image,
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .quantity,
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .discription,
                                //                 cartController.items.values
                                //                     .toList()[index]
                                //                     .size)
                                //           });

                                //   print(orderController.items.length);
                                // } else {
                                //   orderController.addItem(
                                //       Random().nextInt(1000000000 + 1),
                                //       widget.productbuynowl[0].id,
                                //       widget.productbuynowl[0].price,
                                //       widget.productbuynowl[0].name,
                                //       widget.productbuynowl[0].image,
                                //       widget.productbuynowl[0].quantity,
                                //       widget.productbuynowl[0].discription,
                                //       widget.productbuynowl[0].size);
                                //   print(orderController.items.length);
                                // }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ທີ່ຢູ່ຈັດສົ່ງ',
                          style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 15,
                              fontFamily: 'noto_semi')),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditAddress(
                                        lat: lat,
                                        long: long,
                                      )));
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.add,
                              color: Color(0xFF293275),
                              size: 20,
                            ),
                            Text('ເພີ່ມທີ່ຢູ່',
                                style: TextStyle(
                                    color: Color(0xFF293275),
                                    fontSize: 15,
                                    fontFamily: 'noto_semi')),
                          ],
                        ),
                      )
                    ],
                  ),
                  //SizedBox(height: screen1 * 0.35),
                  SizedBox(height: screen1 * 0.38),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ວິທີຈ່າຍເງິນ',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 15,
                              fontFamily: 'noto_semi')),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.to(ditMoney());
                      //   },
                      //   child: Row(
                      //     children: const [
                      //       Icon(
                      //         Icons.edit_outlined,
                      //         color: Color(0xFF293275),
                      //         size: 20,
                      //       ),
                      //       Text('_ ແກ້ໄຂ',
                      //           style: TextStyle(
                      //               color: Color(0xFF293275),
                      //               fontSize: 15,
                      //               fontFamily: 'noto_semi')),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GetBuilder<PaymentController>(
                      init: PaymentController(),
                      builder: (context) => Row(
                            children: [
                              Image.asset(
                                paymentController.items[0]!.paymentname
                                            .toString() ==
                                        'ຈ່າຍເງິນສົດປາຍທາງ'
                                    ? 'icons/money.png'
                                    : 'icons/onepay.jpg',
                                width: paymentController.items[0]!.paymentname
                                            .toString() ==
                                        'ຈ່າຍເງິນສົດປາຍທາງ'
                                    ? 25
                                    : 35,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                  paymentController.items[0]!.paymentname
                                      .toString(),
                                  style: const TextStyle(
                                      color: Color(0xFF5D5D5D),
                                      fontSize: 15,
                                      fontFamily: 'noto_me'))
                            ],
                          ))
                ],
              ),
            )),
            addressShowController.statetList.isEmpty
                ? Text('ທ່ານຍັງບໍ່ທັນມາທີ່ຢູ່',
                    style: TextStyle(
                        color: Color(0xFF293275),
                        fontSize: 15,
                        fontFamily: 'noto_semi'))
                : Obx(() {
                    if (addressShowController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 24, right: 24),
                                alignment: Alignment.center,
                                width: screen,
                                height: screen1 * 0.33,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GoogleMap(
                                      // onTap: (pos) {
                                      //   lat = pos.latitude;
                                      //   long = pos.longitude;
                                      //   setState(() {
                                      //     markers = Marker(
                                      //       markerId: MarkerId('1'),
                                      //       position: pos,
                                      //     );
                                      //   });
                                      // },
                                      markers: {markers},
                                      mapType: statemaps == false
                                          ? MapType.normal
                                          : MapType.hybrid,
                                      initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              double.parse(widget.lat),
                                              double.parse(widget.long)),
                                          zoom: 16),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 13),
                          Container(
                            margin: EdgeInsets.only(left: 24),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('ທີ່ຢູ່ຈັດສົ່ງ',
                                        style: TextStyle(
                                            color: Color(0xFF293275),
                                            fontSize: 15,
                                            fontFamily: 'noto_semi')),
                                    SizedBox(height: 5),
                                    Text(
                                      nameState +
                                          ', ' +
                                          nameDistrict +
                                          ', ' +
                                          nameDivision
                                      //  addressShowController.statetList[0].notes
                                      ,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF5D5D5D),
                                          fontFamily: 'noto_bold'),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    }
                  }),

            //     : Positioned(
            //         top: 55,
            //         child: Container(
            //           padding: EdgeInsets.only(left: 24, right: 24),
            //           alignment: Alignment.center,
            //           width: screen,
            //           height: screen1 * 0.33,
            //          child: Container(
            //           width: screen,
            //            decoration: const BoxDecoration(color: Color(0xFFE5EFF9)),
            //            child: Column(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               CircularProgressIndicator(),
            //               SizedBox(height: 5),
            //               Text('ກຳລັງໂຫຼດ',style: TextStyle(color: Color(0xFF293275),
            //                                 fontSize: 15, fontFamily: 'noto_me'))
            //             ],
            //            ),
            //          ),
            //         ),
            //       ),
          ],
        ));
  }
}
