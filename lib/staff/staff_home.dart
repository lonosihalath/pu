// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/screen/home/homepage.dart';
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/staff/detail_user2.dart';
import 'package:purer/staff/history_status_done.dart';
import 'package:purer/staff/staff_add_user/add_user.dart';
import 'package:purer/staff/staff_add_user/controller-user/controller.dart';
import 'package:purer/staff/staff_api/_staf_modeladdress.dart';
import 'package:purer/staff/staff_api/order_api/controler.dart';
import 'package:purer/staff/staff_detail_order_normal.dart';
import 'package:get/get.dart';
import 'package:purer/staff/staff_detail_order_regular.dart';
import 'package:purer/staff/staff_maps_all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class StaffHome extends StatefulWidget {
  const StaffHome({Key? key}) : super(key: key);

  @override
  State<StaffHome> createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  @override
  void initState() {
  relodad();
    super.initState();
    // resApi();
    // userdata();
    //userController.onInit();

    // staffController.items.values.toList()[0].name.toString() == 'sub_admin'
    //     ? userdata()
    //     : resApi();
    getCurrentLocation();
  }

  List data = [];

  bool isLoading = true;
  relodad() {
    setState(() {
      isLoading = true;
    });
    resApi();
  }

  resApi() async {
    DateTime date = DateTime.now();
    var day = DateFormat('EEEE').format(date);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String? token = sharedPreferences.getString('token');
    final staffcontroller = Get.put(StaffController());

    ///////// -- Truck 1 ກນ 1648
    String normal = 'https://purer.cslox-th.ruk-com.la/api/truck/view';

    ///////// -- Truck 1 ບສ 8899
    ///
    String urlTuck1_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday1';
    String urlTuck1_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday1';
    String urlTuck1_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday1';
    String urlTuck1_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday1';
    String urlTuck1_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday1';
    String urlTuck1_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday1';

    ///////// -- Truck 2 ກດ 2377

    String urlTuck2_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday2';
    String urlTuck2_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday2';
    String urlTuck2_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday2';
    String urlTuck2_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday2';
    String urlTuck2_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday2';
    String urlTuck2_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday2';

    ///////// -- Truck 3 ບບ 1689
    ///
    String urlTuck3_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday3';
    String urlTuck3_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday3';
    String urlTuck3_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday3';
    String urlTuck3_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday3';
    String urlTuck3_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday3';
    String urlTuck3_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday3';

    ///////// -- Truck 5 ກບ 2465

    String urlTuck5_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday5';
    String urlTuck5_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday5';
    String urlTuck5_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday5';
    String urlTuck5_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday5';
    String urlTuck5_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday5';
    String urlTuck5_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday5';

    var response = await http.get(
        Uri.parse(staffController.items.values.toList()[0].name == 'ກນ 1648'
            ? normal
            : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                    day == 'Monday'
                ? urlTuck1_Monday
                : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                        day == 'Tuesday'
                    ? urlTuck1_Tuesday
                    : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                            day == 'Wednesday'
                        ? urlTuck1_Wednesday
                        : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                                day == 'Thursday'
                            ? urlTuck1_Thursday
                            : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                                    day == 'Friday'
                                ? urlTuck1_Friday
                                : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                                        day == 'Saturday'
                                    ? urlTuck1_Saturday
                                    /////////////////////////////////////////////////////////////////////////////////////////////////
                                    : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                            day == 'Monday'
                                        ? urlTuck2_Monday
                                        : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                                day == 'Tuesday'
                                            ? urlTuck2_Tuesday
                                            : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                                    day == 'Wednesday'
                                                ? urlTuck2_Wednesday
                                                : staffController.items.values
                                                                .toList()[0]
                                                                .name ==
                                                            'ກດ 2377' &&
                                                        day == 'Thursday'
                                                    ? urlTuck2_Thursday
                                                    : staffController.items.values
                                                                    .toList()[0]
                                                                    .name ==
                                                                'ກດ 2377' &&
                                                            day == 'Friday'
                                                        ? urlTuck2_Friday
                                                        : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                                                day == 'Saturday'
                                                            ? urlTuck2_Saturday
                                                            /////////////////////////////////////////////////////////////////////////////////////////////////
                                                            : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Monday'
                                                                ? urlTuck3_Monday
                                                                : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Tuesday'
                                                                    ? urlTuck3_Tuesday
                                                                    : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Wednesday'
                                                                        ? urlTuck3_Wednesday
                                                                        : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Thursday'
                                                                            ? urlTuck3_Thursday
                                                                            : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Friday'
                                                                                ? urlTuck3_Friday
                                                                                : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Saturday'
                                                                                    ? urlTuck3_Saturday
                                                                                    /////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                    : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Monday'
                                                                                        ? urlTuck5_Monday
                                                                                        : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Tuesday'
                                                                                            ? urlTuck5_Tuesday
                                                                                            : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Wednesday'
                                                                                                ? urlTuck5_Wednesday
                                                                                                : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Thursday'
                                                                                                    ? urlTuck5_Thursday
                                                                                                    : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Friday'
                                                                                                        ? urlTuck5_Friday
                                                                                                        : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Saturday'
                                                                                                            ? urlTuck5_Saturday
                                                                                                            : 'https://google.com.th'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}',
        });
    var jsonString = jsonDecode(response.body)['data'];
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        data = jsonString;
      });
    }

    print('====>' + data.toString());
  }

  final controller = Get.find<Controller>();

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  StaffController staffController = Get.put(StaffController());
  StaffOrderController staffOrderController = Get.put(StaffOrderController());
  UserAllController userController = Get.put(UserAllController());

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      userController.onInit();
    });
  }

  Future<dynamic> showLog() {
    double screen = MediaQuery.of(context).size.width;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              height: 180,
              // width: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'ອອກຈາກລະບົບ',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'noto_bold',
                        color: Colors.grey.shade800),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                        child: Text(
                      'ທ່ານຕ້ອງການອອກຈາກລະບົບ ຫຼື ບໍ່ ?',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'noto_regular',
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 95,
                        height: 35.0,
                        child: RaisedButton(
                          elevation: 0,
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.grey.shade300),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: screen, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "ຍົກເລີກ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontFamily: 'noto_regular',
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        width: 95,
                        height: 35.0,
                        child: RaisedButton(
                          elevation: 0,
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.clear();
                            controller.clear();
                            stateController.onInit();
                            districtController.onInit();
                            divisionController.onInit();
                            staffController.clear();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                color: Color(0xFF293275),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: screen, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "ຕົກລົງ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'noto_regular',
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: 140,
                // top: screen*0.45,
                // left: screen*0.36,
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                      //border: Border.all(width: 3,color: Colors.lightBlue)
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          'icons/logoapp.jpg',
                          fit: BoxFit.cover,
                        )),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget dialog() => CupertinoAlertDialog(
        title: Text('ອອກຈາກລະບົບ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        content: Text('ທ່ານຕ້ອງການອອກຈາກລະບົບ ຫຼື ບໍ່ ?'),
        actions: [
          CupertinoDialogAction(
            child: Text('ຕົກລົງ'),
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.clear();
              controller.clear();
              stateController.onInit();
              districtController.onInit();
              divisionController.onInit();
              staffController.clear();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Homepage()));
            },
          ),
          CupertinoDialogAction(
            child: Text('ຍົກເລີກ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );

  bool isLoadinguser = true;
  List datauserall = [];
  // userdata() async {
  //   final response = await http.get(
  //       Uri.parse('https://purer.cslox-th.ruk-com.la/api/user/show/regular'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer ${staffController.items.values.toList()[0].token}',
  //       });
  //   print('55555' + response.statusCode.toString());
  //   var json = jsonDecode(response.body);
  //   print(json);
  //   if (response.statusCode == 201) {
  //     datauserall = json;
  //     setState(() {
  //       isLoadinguser = false;
  //     });
  //   }
  // }

  StaffController_add staffController_add = Get.put(StaffController_add());
  DistrictController districtController = Get.put(DistrictController());
  StateController stateController = Get.put(StateController());
  DivisionController divisionController = Get.put(DivisionController());

  double lat = 0.0;
  double long = 0.0;
  var namedistrict;
  var statedata;
  var iddistrict;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 100,
              elevation: 0,
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 24, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                        builder: (context) => Container(
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () =>
                                      Scaffold.of(context).openDrawer(),
                                  icon: Image.asset(
                                    'icons/menu.png',
                                    width: 40,
                                  )),
                            )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          staffController.items.values
                                      .toList()[0]
                                      .name
                                      .toString() ==
                                  'sub_admin'
                              ? isLoadinguser = true
                              : isLoading = true;
                        });
                        resApi();
                      },
                      child: Image.asset(
                        'icons/logo.png',
                        width: 108,
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     ClipRRect(
                    //       borderRadius: BorderRadius.circular(35),
                    //       child: Image.asset(
                    //         'icons/logoapp.jpg',
                    //         width: 70,
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     const Text('ປ້າຍລົດ: 5881',
                    //         style: TextStyle(
                    //             color: Color(0xFF293275),
                    //             fontSize: 18,
                    //             fontFamily: 'noto_semi')),
                    //   ],
                    // ),
                    staffController.items.values.toList()[0].name.toString() !=
                            'sub_admin'
                        ? GestureDetector(
                            onTap: () {
                              data.isEmpty
                                  ? showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        Future.delayed(Duration(seconds: 1),
                                            () {
                                          Navigator.of(context).pop(true);
                                        });
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          content: Container(
                                            alignment: Alignment.center,
                                            width: 201,
                                            height: 90,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Text(
                                                  'ຂໍອະໄພ !',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'noto_me',
                                                      color: Color(0xFF4D4D4F)),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'ຍັງບໍ່ທັນມີອໍເດີ້',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: 'noto_me',
                                                      color: Color(0xFF4D4D4F)),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (lono) => StaffMaps(
                                                dataorder: data,
                                              )));
                            },
                            child: Container(
                                margin: EdgeInsets.only(right: screen * 0.035),
                                child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: Color(0xFF293275),
                                    ),
                                    width: 41,
                                    height: 41,
                                    child: Image.asset(
                                      'icons/location.png',
                                      color: Colors.white,
                                    ))),
                          )
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                isLoadinguser = true;
                              });
                              userController.onInit();
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 41,
                              height: 41,
                              child: Icon(
                                Icons.refresh,
                                size: 40,
                                color: Color(0xFF293275),
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
            drawer: Drawer(
              backgroundColor: Colors.white,
              child: SafeArea(
                  child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(25),
                        width: 500,
                        height: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.asset(
                                    'icons/logoapp.jpg',
                                    width: 70,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                staffController.items.values
                                            .toList()[0]
                                            .name
                                            .toString() ==
                                        'sub_admin'
                                    ? Text(
                                        'ຊື່: ' +
                                            staffController.items.values
                                                .toList()[0]
                                                .name
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF293275),
                                            fontSize: 18,
                                            fontFamily: 'noto_semi'))
                                    : Text(
                                        'ປ້າຍລົດ: ' +
                                            staffController.items.values
                                                .toList()[0]
                                                .name
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF293275),
                                            fontSize: 18,
                                            fontFamily: 'noto_semi')),
                              ],
                            ),
                          ],
                        ),
                      ),
                      staffController.items.values
                                  .toList()[0]
                                  .name
                                  .toString() !=
                              'sub_admin'
                          ? SizedBox(
                              width: screen,
                              height: 46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white, elevation: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                        width: 30,
                                        padding: EdgeInsets.all(6),
                                        child: Image.asset(
                                          'icons/history.png',
                                          width: 19,
                                        )),
                                    SizedBox(width: 15),
                                    const Text('ປະຫວັດການສົ່ງ',
                                        style: TextStyle(
                                            color: Color(0xFF5D5D5D),
                                            fontFamily: 'noto_regular',
                                            fontSize: 15)),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StaffHistoryStatusDone()));
                                },
                              ),
                            )
                          : SizedBox(),
                      // SizedBox(height: 15),
                      staffController.items.values
                                  .toList()[0]
                                  .name
                                  .toString() ==
                              'sub_admin'
                          ? Container(
                              margin: EdgeInsets.only(top: 15),
                              width: screen,
                              height: 46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white, elevation: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 2),
                                    Container(
                                        width: 30,
                                        child: Icon(Icons.person_add,
                                            color: Color(0xFF293275))),
                                    SizedBox(width: 15),
                                    Text('ເພີ່ມລູກຄ້າ',
                                        style: TextStyle(
                                            color: Color(0xFF5D5D5D),
                                            fontFamily: 'noto_regular',
                                            fontSize: 15)),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              StaffAddNameSurname()));
                                },
                              ),
                            )
                          : SizedBox(),

                      staffController.items.values
                                  .toList()[0]
                                  .name
                                  .toString() !=
                              'sub_admin'
                          ? Container(
                              margin: EdgeInsets.only(top: 15),
                              width: screen,
                              height: 46,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white, elevation: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                        width: 30,
                                        padding: EdgeInsets.all(6),
                                        child: Image.asset(
                                          'icons/settings.png',
                                          width: 19,
                                        )),
                                    SizedBox(width: 15),
                                    Text('ຕັ້ງຄ່າ',
                                        style: TextStyle(
                                            color: Color(0xFF5D5D5D),
                                            fontFamily: 'noto_regular',
                                            fontSize: 15)),
                                  ],
                                ),
                                onPressed: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=> Setting()));
                                },
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 15),
                      Container(
                        width: screen,
                        height: 46,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white, elevation: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5),
                              Container(
                                  width: 30,
                                  padding: EdgeInsets.all(6),
                                  child: Image.asset(
                                    'icons/logout.png',
                                    width: 19,
                                  )),
                              SizedBox(width: 15),
                              Text('ອອກຈາກລະບົບ',
                                  style: TextStyle(
                                      color: Color(0xFF5D5D5D),
                                      fontFamily: 'noto_regular',
                                      fontSize: 15)),
                            ],
                          ),
                          onPressed: () {
                            showLog();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
            ),
            // ignore: sort_child_properties_last
            body: RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 30),
                    child:
                        staffController.items.values
                                    .toList()[0]
                                    .name
                                    .toString() !=
                                'sub_admin'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text('ອໍເດີ້ຂອງມື້ນີ້',
                                      style: TextStyle(
                                          color: Color(0xFF5D5D5D),
                                          fontSize: 18,
                                          fontFamily: 'noto_bold')),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  isLoading == true
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 100),
                                          child: Center(
                                            child: Column(
                                              children: const [
                                                CircularProgressIndicator(),
                                                SizedBox(height: 10),
                                                Text('ກຳລັງໂຫຼດ',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF293275),
                                                        fontSize: 17,
                                                        fontFamily: 'noto_me')),
                                              ],
                                            ),
                                          ),
                                        )
                                      : data.isEmpty
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: 50),
                                                child: Text('ຍັງບໍ່ມີອໍເດີ້',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF293275),
                                                        fontSize: 18,
                                                        fontFamily: 'noto_me')),
                                              ),
                                            )
                                          : Column(
                                              children: List.generate(
                                                data.length,
                                                (index) => Stack(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      width: width,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      13)),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              // Text('ອໍເດີ້ຜູ້ໃຊ້ໄອດີ: '+ data[index]['attributes']['user_id'] .toString(),
                                                              //     style: TextStyle(
                                                              //         color: Color(0xFF5D5D5D),
                                                              //         fontSize: 14,
                                                              //         fontFamily: 'noto_regular')),
                                                              Text(
                                                                  data[index]['attributes']
                                                                          [
                                                                          'order_no']
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF5D5D5D),
                                                                      fontSize:
                                                                          14,
                                                                      fontFamily:
                                                                          'noto_regular')),
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 130,
                                                                height: 26,
                                                                decoration: BoxDecoration(
                                                                    color: data[index]['attributes']['status'].toString() ==
                                                                            'Confirmed'
                                                                        ? Color(
                                                                            0xFFE9F9E1)
                                                                        : Color(
                                                                            0xFFFFE6E9),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8)),
                                                                child: Text(
                                                                    data[index]['attributes']
                                                                            [
                                                                            'status']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: data[index]['attributes']['status'].toString() ==
                                                                                'Confirmed'
                                                                            ? Color(
                                                                                0xFF64D435)
                                                                            : Color(
                                                                                0xFFFF3A4E),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'noto_regular')),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.home,
                                                                  size: 20,
                                                                  color: Color(
                                                                      0xFF293275)),
                                                              SizedBox(
                                                                  width: 10),
                                                              Container(
                                                                  width: width *
                                                                      0.65,
                                                                  child: Text(
                                                                      data[index]['attributes']['state_id'].toString() +
                                                                          ', ' +
                                                                          data[index]['attributes']['district_id']
                                                                              .toString() +
                                                                          ', ' +
                                                                          data[index]['attributes']['division_id']
                                                                              .toString(),
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xFF5D5D5D),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'noto_regular'))),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(Icons.phone,
                                                                  size: 20,
                                                                  color: Color(
                                                                      0xFF293275)),
                                                              SizedBox(
                                                                  width: 10),
                                                              Container(
                                                                width: width *
                                                                    0.65,
                                                                child: Text(
                                                                    data[index]['attributes']
                                                                            [
                                                                            'phone']
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF5D5D5D),
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            'noto_regular')),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                        bottom: 10,
                                                        right: 10,
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 130,
                                                            height: 35,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              child: Container(
                                                                width: 130,
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          primary:
                                                                              Color(0xFF293275)),
                                                                  child: const Text(
                                                                      'ເບິ່ງລາຍລະອຽດ',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              'noto_regular')),
                                                                  onPressed:
                                                                      () {
                                                                    if (staffController
                                                                            .items
                                                                            .values
                                                                            .toList()[0]
                                                                            .name
                                                                            .toString() !=
                                                                        "ກນ 1648") {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => StaffDetailOrder(
                                                                                    data: data[index],
                                                                                  )));
                                                                    } else {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => StaffDetailOrderNormal(
                                                                                    data: data[index],
                                                                                  )));
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            ))),
                                                    Container(
                                                      width: screen,
                                                      height: 0.8,
                                                      color: Color(0xFFD6D6D6),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Center(
                                      //   child: Text('ສະເພາະພະນັກງານເກັບຂໍ້ມູນ',
                                      //       style: TextStyle(
                                      //           color: Color(0xFF293275),
                                      //           fontSize: 15,
                                      //           fontFamily: 'noto_me')),
                                      // ),
                                      SizedBox(height: 10),
                                      const Text('ຂໍ້ມູນລູກຄ້າ',
                                          style: TextStyle(
                                              color: Color(0xFF5D5D5D),
                                              fontSize: 18,
                                              fontFamily: 'noto_bold')),
                                      SizedBox(height: 10),
                                      Obx(()=> Text(
                                          'ຈຳນວນລູກຄ້າທັງໝົດ ' +
                                              userController.statetList.length.toString() +
                                              ' ຄົນ',
                                          style: const TextStyle(
                                              color: Color(0xFF293275),
                                              fontSize: 16,
                                              fontFamily: 'noto_me'))),
                                      SizedBox(height: 25),
                                      Obx((){
                                        if(userController.isLoading.value){
                                          return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 100),
                                              child: Center(
                                                child: Column(
                                                  children: const [
                                                    CircularProgressIndicator(),
                                                    SizedBox(height: 10),
                                                    Text('ກຳລັງໂຫຼດ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF293275),
                                                            fontSize: 17,
                                                            fontFamily:
                                                                'noto_me')),
                                                  ],
                                                ),
                                              ),
                                            );
                                        }else{
                                          return Column(
                                              children: List.generate(
                                                  userController.statetList.length,
                                                  (index) => GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      StaffDetailUser2(
                                                                          userAll:userController.statetList[index])));
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  bottom: 13),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: const Color(
                                                                  0xFFE5EFF9)),
                                                          width: width,
                                                          padding:const
                                                              EdgeInsets.all(10),
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
                                                                    width: 70,
                                                                    height: 70,
                                                                    child: ClipRRect(
                                                                        borderRadius: BorderRadius.circular(35),
                                                                        child: Image.network(
                                                                          userController.statetList[index].profile.toString(),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                                  ),
                                                                  const SizedBox(
                                                                      width:
                                                                          10),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        width: screen *
                                                                            0.30,
                                                                        child:
                                                                            Text(
                                                                          '${userController.statetList[index].name.toString()} ' +
                                                                              '${userController.statetList[index].surname.toString()}',
                                                                          style: const TextStyle(
                                                                              color: Color(0xFF293275),
                                                                              fontSize: 12,
                                                                              fontFamily: 'noto_me'),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    userController.statetList[index].phone.toString()=='null' ?SizedBox():  Text(
                                                                          'ເບີໂທ: ' +
                                                                              '${userController.statetList[index].phone.toString()}',
                                                                          style: const TextStyle(
                                                                              color: Color(0xFF293275),
                                                                              fontSize: 12,
                                                                              fontFamily: 'noto_me')),
                                                                      Text(
                                                                          'ປະເພດ: ' +
                                                                              '${userController.statetList[index].type.toString()}',
                                                                          style: const TextStyle(
                                                                              color: Color(0xFF293275),
                                                                              fontSize: 12,
                                                                              fontFamily: 'noto_me')),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                              Text(
                                                                  '${userController.statetList[index].userId.toString()}',
                                                                  style: const TextStyle(
                                                                      color: Color(
                                                                          0xFF293275),
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          'noto_me')),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                            );
                                        }
                                      }
                                      ),
                                      // ),
                                      // isLoadinguser == true
                                      
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             top: 100),
                                      //         child: Center(
                                      //           child: Column(
                                      //             children: [
                                      //               CircularProgressIndicator(),
                                      //               SizedBox(height: 10),
                                      //               Text('ກຳລັງໂຫຼດ',
                                      //                   style: TextStyle(
                                      //                       color: Color(
                                      //                           0xFF293275),
                                      //                       fontSize: 17,
                                      //                       fontFamily:
                                      //                           'noto_me')),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : Column(
                                      //         children: List.generate(
                                      //             datauserall.length,
                                      //             (index) => GestureDetector(
                                      //                   onTap: () {
                                      //                     Navigator.push(
                                      //                         context,
                                      //                         MaterialPageRoute(
                                      //                             builder: (context) =>
                                      //                                 StaffDetailUser2(
                                      //                                     data:
                                      //                                         datauserall[index])));
                                      //                   },
                                      //                   child: Container(
                                      //                     margin:
                                      //                         EdgeInsets.only(
                                      //                             bottom: 13),
                                      //                     decoration: BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     10),
                                      //                         color: Color(
                                      //                             0xFFE5EFF9)),
                                      //                     width: width,
                                      //                     padding:
                                      //                         EdgeInsets.all(
                                      //                             10),
                                      //                     child: Row(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment
                                      //                               .start,
                                      //                       mainAxisAlignment:
                                      //                           MainAxisAlignment
                                      //                               .spaceBetween,
                                      //                       children: [
                                      //                         Row(
                                      //                           crossAxisAlignment:
                                      //                               CrossAxisAlignment
                                      //                                   .start,
                                      //                           children: [
                                      //                             Container(
                                      //                               width: 70,
                                      //                               height: 70,
                                      //                               child: ClipRRect(
                                      //                                   borderRadius: BorderRadius.circular(35),
                                      //                                   child: Image.network(
                                      //                                     datauserall[index]['profile']
                                      //                                         .toString(),
                                      //                                     fit: BoxFit
                                      //                                         .cover,
                                      //                                   )),
                                      //                             ),
                                      //                             SizedBox(
                                      //                                 width:
                                      //                                     10),
                                      //                             Column(
                                      //                               crossAxisAlignment:
                                      //                                   CrossAxisAlignment
                                      //                                       .start,
                                      //                               children: [
                                      //                                 Container(
                                      //                                   width: screen *
                                      //                                       0.30,
                                      //                                   child:
                                      //                                       Text(
                                      //                                     '${datauserall[index]['name'].toString()} ' +
                                      //                                         '${datauserall[index]['surname'].toString()}',
                                      //                                     style: TextStyle(
                                      //                                         color: Color(0xFF293275),
                                      //                                         fontSize: 12,
                                      //                                         fontFamily: 'noto_me'),
                                      //                                     overflow:
                                      //                                         TextOverflow.ellipsis,
                                      //                                   ),
                                      //                                 ),
                                      //                               datauserall[index]['phone'].toString()=='null' ?SizedBox():  Text(
                                      //                                     'ເບີໂທ: ' +
                                      //                                         '${datauserall[index]['phone'].toString()}',
                                      //                                     style: TextStyle(
                                      //                                         color: Color(0xFF293275),
                                      //                                         fontSize: 12,
                                      //                                         fontFamily: 'noto_me')),
                                      //                                 Text(
                                      //                                     'ປະເພດ: ' +
                                      //                                         '${datauserall[index]['type'].toString()}',
                                      //                                     style: TextStyle(
                                      //                                         color: Color(0xFF293275),
                                      //                                         fontSize: 12,
                                      //                                         fontFamily: 'noto_me')),
                                      //                               ],
                                      //                             )
                                      //                           ],
                                      //                         ),
                                      //                         Text(
                                      //                             '${datauserall[index]['user_id'].toString()}',
                                      //                             style: TextStyle(
                                      //                                 color: Color(
                                      //                                     0xFF293275),
                                      //                                 fontSize:
                                      //                                     13,
                                      //                                 fontFamily:
                                      //                                     'noto_me')),
                                      //                       ],
                                      //                     ),
                                      //                   ),
                                      //                 )),
                                      //       )
                                    ],
                                  ),
                                ],
                              ),
                  ),
                ))),
        onWillPop: () async => false);
  }

  // districtName(District district) => district.districtName.toString();
  // sataetName(State1 state) => state.stateName.toString();
  // divisiontName(Division division) => division.divisionName.toString();
}
