import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/screen/signin_signup/user/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditName extends StatefulWidget {
  const EditName({Key? key}) : super(key: key);

  @override
  State<EditName> createState() => _EditNameState();
}

class _EditNameState extends State<EditName> {
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  final controller = Get.find<Controller>();

  @override
  void initState(){
    super.initState();
    setState(() {
      name.text = controller.photoList[0].name.toString();
      surname.text = controller.photoList[0].surname.toString();
    });
  }

  update() async {
     showDialog(
      barrierDismissible: false,
      context: context, builder: (lono)=> dialog3());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'name': name.text.toString(),
      'surname': surname.text.toString(),
    };
    var res = await CallApi().postDataupDate(data, '${id}', token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      controller.onInit();
      Timer(Duration(seconds: 2), () {
        // Navigator.pop(context);
        Navigator.pop(context);
       Navigator.pop(context);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => ProfileUser()));
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
        title: const Text('ຊື່ ແລະ ນາມສະກຸນ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
          width: screen,
          child: Container(
            width: screen,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                child: const Text('ບັນທຶກ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
                  update();
                },
              ),
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
                  children: [
                    Text('ຊື່',
                        style: TextStyle(
                            color: Color(0xFFB1B1B1),
                            fontSize: 15,
                            fontFamily: 'noto_regular')),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 20),
                  width: screen * 0.90,
                  height: 43,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                  child: Container(
                    width: screen * 0.90,
                    child: TextFormField(
                      controller: name,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'ຊື່',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5D5D5D),
                              fontFamily: 'noto_semi'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('ນາມສະກຸນ',
                        style: TextStyle(
                            color: Color(0xFFB1B1B1),
                            fontSize: 15,
                            fontFamily: 'noto_regular')),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.only(left: 10, top: 20),
                  width: screen * 0.90,
                  height: 43,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                  child: Container(
                    width: screen * 0.90,
                    child: TextFormField(
                      controller: surname,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                          hintText: 'ນາມສະກຸນ',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5D5D5D),
                              fontFamily: 'noto_semi'),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
