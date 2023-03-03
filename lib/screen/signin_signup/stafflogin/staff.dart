import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:get/get.dart';
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/staff/staff_add_user/controller-user/controller.dart';
import 'package:purer/staff/staff_api/order_api/controler.dart';
import 'package:purer/staff/staff_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInStaff extends StatefulWidget {
  const SignInStaff({Key? key}) : super(key: key);

  @override
  State<SignInStaff> createState() => _SignInStaffState();
}

class _SignInStaffState extends State<SignInStaff> {
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final staffcontroller = Get.put(StaffController());
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());
  StaffOrderController staffController = Get.put(StaffOrderController());
  StaffOrderController staffOrderController = Get.put(StaffOrderController());
  UserAllController userController = Get.put(UserAllController());
  bool checkemail = false;
  bool checkPassword = false;

  LoginTuck() async {
    staffcontroller.clear();
    var data = {
      "email": email.text.toString(),
      "password": password.text.toString(),
    };
    var res = await CallApi().postDataloginTuck(data, 'truck/login');
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      staffcontroller.addItem(
          body['token'].toString(),
          int.parse(body['admin']['id'].toString()),
          body['admin']['id'].toString(),
          body['admin']['name'].toString(),
          body['admin']['surname'].toString(),
          body['admin']['email'].toString(),
          body['admin']['phone'].toString(),
          body['admin']['type'].toString());

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', body['token']);
      stateController.onInit();
      districtController.onInit();
      divisionController.onInit();
      staffController.onInit();
      staffOrderController.onInit();
      userController.onInit();
     
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (lono) => StaffHome()));
      
    } else {
      Navigator.pop(context);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Container(
                  alignment: Alignment.center,
                  width: 350,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ອໍອະໄພ!',
                          style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 18,
                              fontFamily: 'noto_bold')),
                      Text('ອີເມວ ຫຼື ລະຫັດຜ່ານບໍ່ຖືກຕ້ອງ',
                          style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                      SizedBox(height: 25),
                      Container(
                        width: 150,
                        height: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            child: Text('ຕົງລົງ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'noto_regular')),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
    }

    print(body);
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );
  bool stutusRedEye1 = true;

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xFFE5EFF6),
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Container(
              width: screen,
              height: screen1,
            ),
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
            Positioned(
                left: screen * 0.72,
                child: Container(
                  width: screen * 0.50,
                  height: screen * 0.50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screen * 0.25),
                      color: Color(0xFF98caff)),
                )),
            Positioned(
                bottom: 20,
                right: screen * 0.60,
                child: Container(
                  width: screen * 0.65,
                  height: screen1 * 0.52,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(screen * 0.55),
                          bottomRight: Radius.circular(screen * 0.55)),
                      color: Color(0xFF98caff)),
                )),
            Positioned(
              right: screen * 0.05,
              child: Column(
                children: [
                  SizedBox(height: 180),
                  Container(
                      width: 138,
                      height: 138,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          color: Color(0xFF98caff)),
                      child: Image.asset('icons/logo.png')),
                  SizedBox(height: 20),
                  const Text('ເຂົ້າສູ່ລະບົບພະນັກງານ',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 15,
                          fontFamily: 'noto_regular')),
                  SizedBox(height: 30),
                  Container(
                    height: 50,
                    width: screen * 0.90,
                    child: TextFormField(
                        controller: email,
                        //focusNode: focusNode,
                        onChanged: ((value) {}),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'branding4'),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('ອີເມວ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'noto_regular')),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                  ),
                  checkemail == true
                      ? Container(
                          width: screen * 0.90,
                          margin: EdgeInsets.only(),
                          child: Row(
                            children: [
                              Text('ກະລຸນາປ້ອນອີເມວ',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontFamily: 'noto_regular')),
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 15),
                  Container(
                    height: 50,
                    width: screen * 0.90,
                    child: TextFormField(
                        obscureText: stutusRedEye1,
                        controller: password,
                        //focusNode: focusNode,
                        onChanged: ((value) {}),
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                            fontSize: 15, fontFamily: 'branding4'),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          label: const Text('ລະຫັດຜ່ານ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'noto_regular')),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: stutusRedEye1
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                stutusRedEye1 = !stutusRedEye1;
                              });
                            },
                          ),
                        )),
                  ),
                  checkPassword == true
                      ? Container(
                          width: screen * 0.90,
                          margin: EdgeInsets.only(),
                          child: Row(
                            children: [
                              Text('ກະລຸນາປ້ອນລະຫັດຜ່ານ',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontFamily: 'noto_regular')),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Positioned(
              right: screen * 0.05,
              bottom: 20,
              child: Container(
                width: screen * 0.90,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                    child: const Text('ເຂົ້າສູ່ລະບົບ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'noto_me')),
                    onPressed: () {
                      if (email.text.isEmpty && password.text.isEmpty) {
                        setState(() {
                          checkemail = true;
                          checkPassword = true;
                        });
                      }
                      if (email.text.isEmpty) {
                        setState(() {
                          checkemail = true;
                        });
                      } else {
                        setState(() {
                          checkemail = false;
                        });
                      }
                      ////////////////////////////////////////////////////////////
                      if (password.text.isEmpty) {
                        setState(() {
                          checkPassword = true;
                        });
                      } else {
                        setState(() {
                          checkPassword = false;
                        });
                      }
                      if (email.text.isNotEmpty && password.text.isNotEmpty) {
                        showDialog(
                            barrierDismissible: false,
                            context: context, builder: (lono) => dialog3());
                        setState(() {
                          checkPassword = false;
                          checkemail = false;
                        });
                        LoginTuck();
                      }
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) =>StaffHome()));
                    },
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
