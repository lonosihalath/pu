import 'package:flutter/material.dart';
import 'package:purer/screen/signin_signup/name-surname.dart';
import 'package:purer/screen/signin_signup/signin.dart';

class SignUpWidthPhone extends StatefulWidget {
  const SignUpWidthPhone({Key? key}) : super(key: key);

  @override
  State<SignUpWidthPhone> createState() => _SignUpWidthPhoneState();
}

class _SignUpWidthPhoneState extends State<SignUpWidthPhone> {
  TextEditingController phone = TextEditingController();
  bool checkPhone = false;
  bool checkPhone1 = false;
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
              right: screen*0.05,
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
                    const Text('?????????????????????????????????????????????????????????????????????',
                        style: TextStyle(
                            color: Color(0xFF5D5D5D),
                            fontSize: 15,
                            fontFamily: 'noto_regular')),
                    SizedBox(height: 30),
                    Container(
                      height: 70,
                      width: screen * 0.90,
                      child: TextFormField(
                          //focusNode: focusNod
                          onChanged: ((value) {}),
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          controller: phone,
                          style:
                              TextStyle(fontSize: 15, fontFamily: 'branding4'),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                             enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                            filled: true,
                            fillColor: Colors.white,
                            label: Container(
                              width: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'icons/laos.png',
                                    width: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Padding(
                                      padding: EdgeInsets.only(),
                                      child: Container(
                                          child: Text('+85620 ??????????????????????????????????????????',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                  fontFamily:
                                                      'noto_regular')))),
                                ],
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                    ),
                     checkPhone == true
                          ? Container(
                              width: screen * 0.90,
                              margin: EdgeInsets.only(),
                              child: Row(
                                children: [
                                  Text('????????????????????????????????????????????????????????????',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.red,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            )
                          : checkPhone1 == true
                              ? Container(
                                  width: screen * 0.90,
                                  margin: EdgeInsets.only(),
                                  child: Row(
                                    children: [
                                      Text('?????????????????????????????????????????????????????????????????????????????? 8 ??????',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontFamily: 'noto_regular')),
                                    ],
                                  ),
                                )
                              : SizedBox()
                  ],
                ),
              ),
              Positioned(
              left: screen*0.10,
             bottom: screen1*0.06,
              child: GestureDetector(
                onTap: (){
                   Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInWidthPhone()));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: screen * 0.85,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const Text('????????????????????????????????????????????? ?',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF293275),
                              fontFamily: 'noto_me')),
                  ),
                ),
              ),
            ),
            Positioned(
              right: screen*0.05,
              bottom: 20,
              child: Container(
                width: screen * 0.90,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                    child: Text('?????????????????????????????????????????????',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'noto_me')),
                    onPressed: () {
                         if (phone.text.isEmpty) {
                    setState(() {
                      checkPhone = true;
                      checkPhone1 = false;
                    });
                  }else{
                    if (phone.text.length < 8) {
                    setState(() {
                      checkPhone1 = true;
                      checkPhone = false;
                    });
                  }
                  }
    
                  if(phone.text.isNotEmpty && phone.text.length == 8){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NameSurname(phone: phone.text,)));
                  }
                    
                    },
                  ),
                ),
              ),
            ),
            
          ],
        )));
  }
}
