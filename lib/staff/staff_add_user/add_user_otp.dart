import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/staff/staff_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class StaffOTPScreen extends StatefulWidget {
  final phone;
  final name;
  final surname;
  final stateId;
  final districtId;
  final divisionId;
  final notes;
  final lat;
  final long;
  final day;
  const StaffOTPScreen({
    Key? key,
    required this.phone,
    required this.name,
    required this.surname,
    required this.stateId,
    required this.districtId,
    required this.divisionId,
    required this.notes,
    required this.lat,
    required this.long,
    required this.day,
  }) : super(key: key);

  @override
  State<StaffOTPScreen> createState() => _StaffOTPScreenState();
}

class _StaffOTPScreenState extends State<StaffOTPScreen> {
  AddressShowController addressShowController =
      Get.put(AddressShowController());
  DateTime date = DateTime.now();
  FirebaseAuth auth = FirebaseAuth.instance;
  final controller = Get.find<Controller>();
  String? varificationCode;
  String? token;
  String code1 = "";
  String sms = "";

  @override
  void initState() {
    super.initState();
    verifyPhneNumber();
  }

  verifyPhneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${'+85620' + widget.phone}",
      verificationCompleted: (PhoneAuthCredential credentail) async {
        siginPhone(credentail);
        await FirebaseAuth.instance
            .signInWithCredential(credentail)
            .then((value) {
          if (value.user != null) {
            print('555555555==========>' + '${value.user!.getIdToken()}');
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resentToken) {
        setState(() {
          varificationCode = vID;
          token = resentToken.toString();
          print('Token=====> ' + token.toString());
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          varificationCode = vID;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

  Future<void> siginPhone(PhoneAuthCredential phoneAuthCredential) async {
    try {
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      var firebaseAccessToken = await authResult.user!.getIdToken();
      print('firebaseAccessToken=====>' + firebaseAccessToken.toString());
    } catch (e) {
      print(e);
    }
  }

  var idUser;
  var phoneUser;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      var tokenaccess = await authCredential.user!.getIdToken();
      var tokenaccess1 = await authCredential.user!.getIdTokenResult();
      // print('User======>' + authCredential.user!.toString());
      print('tokenid=====>' + tokenaccess.toString());

      if (authCredential.user != null) {
        String _url = 'https://purer.cslox-th.ruk-com.la/api/OTP/login';
        var respone = await http.post(Uri.parse(_url), headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenaccess',
        });
        var jsonData = json.decode(respone.body);
        print('jsonData=====>' + jsonData.toString());
        if (respone.statusCode == 200) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('token', jsonData['token']);
          localStorage.setString('id', json.encode(jsonData['user']['id']));
          setState(() {
            idUser = json.encode(jsonData['user']['id']);
            phoneUser = json.encode(jsonData['user']['phone']);
          });
          update();
        }
      }
      //print('tokenacid555=====>' + tokenaccess1.toString());

      /////////////////////////////////////////////////

    } on FirebaseAuthException catch (e) {}
  }

  update() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'name': widget.name.toString(),
      'surname': widget.surname.toString(),
      'status': 'regular',
    };
    var res = await CallApi().postDataupDate(data, '${idUser}', token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      controller.onInit();
      Timer(Duration(seconds: 1), () {
        _insertAddress();
      });
      // print(body);
      // print('statusCode====>' + res.statusCode.toString());
    }
  }

  _insertAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? userid = preferences.getString('id');
    print(token);
    print(userid);

    var data = {
      "user_id": idUser.toString(),
      "division_id": widget.divisionId.toString(),
      "district_id": widget.districtId.toString(),
      "state_id": widget.stateId.toString(),
      "phone": phoneUser.toString(),
      "latitiude": widget.lat.toString(),
      "longtiude": widget.long.toString(),
      "notes": widget.notes.toString(),
    };
    var res = await CallApi().postDataaddress(data, 'address/insert', token);
    if (res.statusCode == 201) {
      AddressShowController addressShowController =
          Get.put(AddressShowController());
      addressShowController.onInit();
      Timer(Duration(seconds: 1), () {
        _addroder();
      });
    }
    // print(data);
    // print(token);
    // print('Response status: ${res.statusCode}');
  }

  _addroder() async {
    // showDialog(context: context, builder: (context) => dialog());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    var data = {
      "user_id": idUser.toString(),
      "division_id": widget.divisionId,
      "district_id": widget.districtId,
      "state_id": widget.stateId,
      "longitude_id": widget.long,
      "latitiude_id": widget.lat,
      "phone": phoneUser.toString(),
      "notes": widget.notes,
      "day": widget.day.toString(),
      "amount_cash": '',
      "order_month": DateFormat('LLLL').format(date),
      "order_year": DateFormat('y').format(date),
      "order_type": 'regular',
      'order_items': [
        {
          "image": products[0].image,
          "product_name": products[0].name,
          "size": products[0].size,
          "price": products[0].prict,
          "amount": '',
          "total_amount": '',
        }
      ],
    };
    var res =
        await CallApi().postDataOrder(data, 'order/insert/regularUser', token);
    var dataorder = json.decode(res.body);

    // print(res.body);
    // print('Response status: ${res.statusCode}');
    if (res.statusCode == 201) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StaffHome()));
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
                        'ສຳເລັດແລ້ວ',
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
      });
    }
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFE5EFF6),
      body: SingleChildScrollView(
          child: Stack(
        children: [
          Positioned(
              top: 50,
              left: 15,
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xff717171),
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Container(
              width: screen,
              child: Column(
                children: [
                  const SizedBox(height: 180),
                  Container(
                      width: 138,
                      height: 138,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          color: Color.fromARGB(255, 119, 185, 232)),
                      child: Image.asset('icons/logo.png')),
                  const SizedBox(height: 20),
                  const Text('ປ້ອນລະຫັດຢືນຢັນ',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 15,
                          fontFamily: 'noto_regular')),
                  const SizedBox(height: 20),
                  Container(
                    height: 40,
                    width: screen,
                    child: PinFieldAutoFill(
                      decoration: UnderlineDecoration(
                        gapSpace: 10,
                        textStyle: TextStyle(
                            color: Colors.grey.shade800,
                            fontFamily: 'branding4',
                            fontSize: 18),
                        lineHeight: 1,
                        lineStrokeCap: StrokeCap.square,
                        bgColorBuilder:
                            PinListenColorBuilder(Colors.white, Colors.white),
                        colorBuilder:
                            const FixedColorBuilder(Colors.transparent),
                      ),
                      codeLength: 6,
                      autoFocus: true,
                      onCodeChanged: (val) {
                        if (val!.length.toInt() == 6) {
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: varificationCode!,
                                  smsCode: val);
                          signInWithPhoneAuthCredential(phoneAuthCredential);
                          showDialog(
                              context: context, builder: (lono) => dialog3());
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
