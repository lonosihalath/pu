import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/screen/signin_signup/user/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class EditPhone extends StatefulWidget {
  const EditPhone({Key? key}) : super(key: key);

  @override
  State<EditPhone> createState() => _EditPhoneState();
}

class _EditPhoneState extends State<EditPhone> {

  final controller = Get.find<Controller>();
  TextEditingController phone = TextEditingController();

   updatephone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'phone':'+85620'+ phone.text.toString(),
    };
    var res = await CallApi().postDataupDate(data, '${id}', token);
    var body = json.decode(res.body);
    print('statusCode====>' + res.statusCode.toString());
    if (res.statusCode == 201) {
      controller.onInit();
      Timer(Duration(seconds: 2), () {
        // Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProfileUser()));
      });
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
        title: const Text('ເບີໂທລະສັບ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin:const EdgeInsets.only(left: 24,right: 24,bottom: 20),
          width: screen,
          child:  Container(
                  width: screen,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                      child:const Text('ບັນທຶກ',style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'noto_me')),onPressed: (){
                                    updatephone();
                           
                                  },),
                  ),
                ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screen,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  children: const [
                    Text('ເບີໂທລະສັບ',
                        style: TextStyle(
                            color: Color(0xFFB1B1B1),
                            fontSize: 15,
                            fontFamily: 'noto_regular')),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      height: 43,
                      width: screen*0.23,
                     decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,border: Border.all(width: 1,color: Color(0xFFEBEBEB))),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(),
                                      child: Container(
                                       
                                          child: Image.asset(
                                        'icons/laos.png',
                                        width: 25,
                                      )),
                                    ),
                                    SizedBox(width: 5),
                                    Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: Container(child: Text('+85620', style: TextStyle(
                            color: Color(0xFF5D5D5D),
                            fontSize: 15,
                            fontFamily: 'noto_regular')))),
                                  ],
                                ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      padding:  EdgeInsets.only(left: 10,top: 20),
                      width: screen * 0.62,
                      height: 43,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,border: Border.all(width: 1,color: Color(0xFFEBEBEB))),
                      child: Container(
                        width: screen * 0.90,
                        child: TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                              hintText: 'ເບີໂທລະສັບ',
                              hintStyle:
                                  TextStyle(fontSize: 14, color: Color(0xFF5D5D5D),fontFamily: 'noto_semi'),
                              border: InputBorder.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}