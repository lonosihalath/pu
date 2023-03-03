import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/controller/cart_controller.dart';
import 'package:purer/screen/home/homepage.dart';
import 'package:purer/screen/order/order_hisory.dart';
import 'package:purer/screen/signin_signup/signin.dart';
import 'package:purer/screen/signin_signup/signup.dart';
import 'package:purer/screen/signin_signup/stafflogin/staff.dart';
import 'package:purer/screen/signin_signup/user/address.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/screen/signin_signup/user/profile.dart';
import 'package:purer/screen/signin_signup/user/setting.dart';
import 'package:purer/staff/staff_add_user/profile_photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final controller = Get.find<Controller>();
  final cartController = Get.find<CartController>();
  AddressShowController addressShowController =
      Get.put(AddressShowController());

  _Logout() async {
    //deleteData();
    Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) => dialog3()));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 1), () {
      Navigator.pop(context);
      preferences.clear();
      cartController.clear();
      controller.photoList.clear();
      addressShowController.onInit();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    });
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );

  Widget dialog() => CupertinoAlertDialog(
        title: Text('ອອກຈາກລະບົບ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        content: Text('ທ່ານຕ້ອງການອອກຈາກລະບົບ ຫຼື ບໍ່ ?'),
        actions: [
          CupertinoDialogAction(
            child: Text('ຕົກລົງ'),
            onPressed: () async {
              _Logout();
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
  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      child: SafeArea(
          top: false,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(25),
                    width: 500,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(30)),
                      color: Color(0xFFE5EFF6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        controller.photoList.isNotEmpty
                            ? Obx(() => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (lono) =>
                                                GalleryImageProfile(
                                                    image: controller
                                                        .photoList[0].profile
                                                        .toString())));
                                  },
                                  child: Container(
                                      width: 95,
                                      height: 95,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            controller.photoList[0].profile
                                                .toString(),
                                            fit: BoxFit.cover,
                                          ))),
                                ))
                            : Image.asset(
                                'icons/profile.png',
                                width: 100,
                              ),
                        SizedBox(height: 10),
                        controller.photoList.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                width: 176,
                                height: 46,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Color(0xFF293275)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignInWidthPhone()));
                                        },
                                        child: Text('ເຂົ້າສູ່ລະບົບ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'noto_me',
                                                fontSize: 15))),
                                    const Text('/',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'noto_me')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpWidthPhone()));
                                        },
                                        child: Text(
                                          'ສ້າງບັນຊີ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'noto_me',
                                              fontSize: 15),
                                        ))
                                  ],
                                ),
                              )
                            : Obx(() => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: screen,
                                      child: Text(
                                        controller.photoList[0].name.toString() +
                                            ' ' +
                                            controller.photoList[0].surname
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF293275),
                                            fontFamily: 'noto_bold',
                                            fontSize: 18),overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                   controller.photoList[0].phone.toString() =='null' ?Text(''): Container(
                                    width: screen,
                                     child: Text('ເບີໂທ: '+
                                        controller.photoList[0].phone.toString(),
                                        style: TextStyle(
                                            color: Color(0xFF5D5D5D),
                                            fontFamily: 'noto_me',
                                            fontSize: 14),overflow: TextOverflow.ellipsis,
                                      ),
                                   ),
                                  ],
                                ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
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
                          const Text('ປະຫວັດການສັ່ງຊື້',
                              style: TextStyle(
                                  color: Color(0xFF5D5D5D),
                                  fontFamily: 'noto_regular',
                                  fontSize: 15)),
                        ],
                      ),
                      onPressed: () {
                        if (controller.photoList.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (lono) => SignUpWidthPhone()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderHistoryScreen()));
                        }
                      },
                    ),
                  ),
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
                                'icons/account.png',
                                width: 20,
                              )),
                          SizedBox(width: 15),
                          Text('ໂປຣໄຟລ',
                              style: TextStyle(
                                  color: Color(0xFF5D5D5D),
                                  fontFamily: 'noto_regular',
                                  fontSize: 15)),
                        ],
                      ),
                      onPressed: () {
                        if (controller.photoList.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (lono) => SignUpWidthPhone()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileUser()));
                        }
                      },
                    ),
                  ),
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
                              padding: EdgeInsets.all(7),
                              child: Image.asset(
                                'icons/location.png',
                                width: 19,
                              )),
                          SizedBox(width: 15),
                          Text('ທີ່ຢູ່ຈັດສົ່ງ',
                              style: TextStyle(
                                  color: Color(0xFF5D5D5D),
                                  fontFamily: 'noto_regular',
                                  fontSize: 15)),
                        ],
                      ),
                      onPressed: () {
                        if (controller.photoList.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (lono) => SignUpWidthPhone()));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Address()));
                        }
                      },
                    ),
                  ),
                  // SizedBox(height: 15),
                  // Container(
                  //   width: screen,
                  //   height: 46,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         primary: Colors.white, elevation: 0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         SizedBox(width: 5),
                  //         Container(
                  //             width: 30,
                  //             padding: EdgeInsets.all(6),
                  //             child: Image.asset(
                  //               'icons/payment.png',
                  //               width: 19,
                  //             )),
                  //         SizedBox(width: 15),
                  //         Text('ຊ່ອງທາງການຈ່າຍເງິນ',
                  //             style: TextStyle(
                  //                 color: Color(0xFF5D5D5D),
                  //                 fontFamily: 'noto_regular',
                  //                 fontSize: 15)),
                  //       ],
                  //     ),
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Payments()));
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 15),
                  // Container(
                  //   width: screen,
                  //   height: 46,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         primary: Colors.white, elevation: 0),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         SizedBox(width: 5),
                  //         Container(
                  //             width: 30,
                  //             padding: EdgeInsets.all(6),
                  //             child: Image.asset(
                  //               'icons/account.png',
                  //               width: 20,
                  //             )),
                  //         SizedBox(width: 15),
                  //         Text('Staff',
                  //             style: TextStyle(
                  //                 color: Color(0xFF5D5D5D),
                  //                 fontFamily: 'noto_regular',
                  //                 fontSize: 15)),
                  //       ],
                  //     ),
                  //     onPressed: () {
                  //       if (controller.photoList.isEmpty) {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (lono) => SignInStaff()));
                  //       } else {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => SignInStaff()));
                  //       }
                  //     },
                  //   ),
                  // ),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Setting()));
                      },
                    ),
                  ),
                ],
              ),
             controller.photoList.isNotEmpty ? Positioned(
                bottom: 30,
                child: Container(
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
              ) : SizedBox()
            ],
          )),
    );
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
                      style: TextStyle(fontSize: 14, fontFamily: 'noto_regular',),
                      
                      textAlign: TextAlign.center,
                    )),
                  ),
                  SizedBox(
                    height: 10
                  ),
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
                              border: Border.all(width: 1,color: Colors.grey.shade300),
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
                      SizedBox(width:10),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        width: 95,
                        height: 35.0,
                        child: RaisedButton(
                          elevation: 0,
                          onPressed: () async {
                            _Logout();
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

}
