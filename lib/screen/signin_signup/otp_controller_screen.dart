import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/screen/home/homepage.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OTPScreen extends StatefulWidget {
  final phone;
  final name;
  final surname;
  const OTPScreen(
      {Key? key,
      required this.phone,
      required this.name,
      required this.surname})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());
  AddressShowController addressShowController =
      Get.put(AddressShowController());
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

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      String? _deviceToken = '@';

      try {
        _deviceToken = await FirebaseMessaging.instance.getToken();
        print('DeviceToken ======>: ' + _deviceToken.toString());
      } catch (lono) {
        print('no');
        print(lono.toString());
      }
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      var tokenaccess = await authCredential.user!.getIdToken();
      var tokenaccess1 = await authCredential.user!.getIdTokenResult();
      // print('User======>' + authCredential.user!.toString());
      print('tokenid=====>' + tokenaccess.toString());

      if (authCredential.user != null) {
        String _url = 'https://purer.cslox-th.ruk-com.la/api/OTP/login';
        var respone = await http.post(Uri.parse(_url), body: {
          'device_token': _deviceToken
        }, headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenaccess',
        });
        var jsonData = json.decode(respone.body);
        print('jsonData=====>' + jsonData.toString());
        if (respone.statusCode == 200) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.clear();
          localStorage.setString('token', jsonData['token']);
          localStorage.setString('id', json.encode(jsonData['user']['id']));
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
    };
    var res = await CallApi().postDataupDate(data, '${id}', token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      controller.onInit();
      stateController.onInit();
      districtController.onInit();
      divisionController.onInit();
      addressShowController.onInit();
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      });
      print(body);
      print('statusCode====>' + res.statusCode.toString());
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
                      cursor: Cursor(
                        width: 2,
                        height: 30,
                        color: Colors.blue,
                        radius: Radius.circular(1),
                        enabled: true,
                      ),
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

class OTPScreenSignIn extends StatefulWidget {
  final phone;
  const OTPScreenSignIn({
    Key? key,
    required this.phone,
  }) : super(key: key);

  @override
  State<OTPScreenSignIn> createState() => _OTPScreenSignInState();
}

class _OTPScreenSignInState extends State<OTPScreenSignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final controller = Get.find<Controller>();
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());
  AddressShowController addressShowController =
      Get.put(AddressShowController());
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
         //   print('555555555==========>' + '${value.user!.getIdToken()}');
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
         // print('Token=====> ' + token.toString());
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
     // print('firebaseAccessToken=====>' + firebaseAccessToken.toString());
    } catch (e) {
      print(e);
    }
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      String? _deviceToken = '@';
      try {
        _deviceToken = await FirebaseMessaging.instance.getToken();
        print('DeviceToken ======>: ' + _deviceToken.toString());
      } catch (lono) {
      //  print('no');
       // print(lono.toString());
      }
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      var tokenaccess = await authCredential.user!.getIdToken();
      var tokenaccess1 = await authCredential.user!.getIdTokenResult();
      // print('User======>' + authCredential.user!.toString());
      //print('tokenid=====>' + tokenaccess.toString());
      //print('tokenacid555=====>' + tokenaccess1.toString());

      if (authCredential.user != null) {
        String _url = 'https://purer.cslox-th.ruk-com.la/api/OTP/login';
        var respone = await http.post(Uri.parse(_url), body: {
          'device_token': _deviceToken
        }, headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $tokenaccess',
        });
        var jsonData = json.decode(respone.body);
        //print('jsonData=====>' + jsonData.toString());
        if (respone.statusCode == 200) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.clear();
          localStorage.setString('token', jsonData['token']);
          localStorage.setString('id', json.encode(jsonData['user']['id']));
          controller.onInit();
          stateController.onInit();
          districtController.onInit();
          divisionController.onInit();
          addressShowController.onInit();
      
            Navigator.pop(context);
            // Navigator.pop(context);
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          
        }
      }

      /////////////////////////////////////////////////

    } on FirebaseAuthException catch (e) {}
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
                      cursor: Cursor(
                        width: 2,
                        height: 30,
                        color: Colors.blue,
                        radius: Radius.circular(1),
                        enabled: true,
                      ),
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
                            barrierDismissible: false,
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
