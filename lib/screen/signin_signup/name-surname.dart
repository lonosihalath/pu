import 'package:flutter/material.dart';
import 'package:purer/screen/signin_signup/otp_controller_screen.dart';

class NameSurname extends StatefulWidget {
  final phone;
  const NameSurname({Key? key, required this.phone}) : super(key: key);

  @override
  State<NameSurname> createState() => _NameSurname();
}

class _NameSurname extends State<NameSurname> {
  bool checkName = false;
  bool checkSurname = false;
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
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
                  const Text('ປ້ອນຊື່ ແລະ ນາມສະກຸນ',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 15,
                          fontFamily: 'noto_regular')),
                  SizedBox(height: 15),
                  //     Padding(
                  //         padding:  EdgeInsets.only(right: screen*.89,),
                  //       child: Row(
                  //   children: [
                  //       Text('ຊື່',
                  //           style: TextStyle(
                  //               color: Color(0xFFB1B1B1),
                  //               fontSize: 15,
                  //               fontFamily: 'noto_regular')),
                  //   ],
                  // ),
                  //  ),
                  //SizedBox(height: 8),
                  Container(
                    height: 50,
                    width: screen * 0.90,
                    child: TextFormField(
                        //focusNode: focusNode,
                        onChanged: ((value) {}),
                        keyboardType: TextInputType.name,
                        controller: name,
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
                          label: const Text('ປ້ອນຊື່',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'noto_regular')),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                  ),
                  checkName == true
                      ? Container(
                          width: screen * 0.90,
                          margin: EdgeInsets.only(),
                          child: Row(
                            children: [
                              Text('ກະລຸນາປ້ອນຊື່',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontFamily: 'noto_regular')),
                            ],
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 13),
                  //     Padding(
                  //         padding:  EdgeInsets.only(right: screen*.76),
                  //       child: Row(
                  //   children: [
                  //       Text('ນາມສະກຸນ',
                  //           style: TextStyle(
                  //               color: Color(0xFFB1B1B1),
                  //               fontSize: 15,
                  //               fontFamily: 'noto_regular')),
                  //   ],
                  // ),
                  //     ),
                  // SizedBox(height: 8),
                  Container(
                    height: 50,
                    width: screen * 0.90,
                    child: TextFormField(
                        //focusNode: focusNode,
                        onChanged: ((value) {}),
                        keyboardType: TextInputType.name,
                        controller: surname,
                        style: TextStyle(fontSize: 15, fontFamily: 'branding4'),
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
                          label: Text('ປ້ອນນາມສະກຸນ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontFamily: 'noto_regular')),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )),
                  ),
                  checkSurname == true
                      ? Container(
                          width: screen * 0.90,
                          margin: EdgeInsets.only(),
                          child: Row(
                            children: [
                              Text('ກະລຸນາປ້ອນນາມສະກຸນ',
                                  style: TextStyle(
                                      fontSize: 12,
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
                    child: Text('ສົ່ງລະຫັດຢືນຢັນ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'noto_me')),
                    onPressed: () {
                      if (name.text.isEmpty) {
                        setState(() {
                          checkName = true;
                        });
                      } else {
                        setState(() {
                          checkName = false;
                        });
                      }
                      if (surname.text.isEmpty) {
                        setState(() {
                          checkSurname = true;
                        });
                      } else {
                        setState(() {
                          checkSurname = false;
                        });
                      }
                      if (name.text.isNotEmpty && surname.text.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                      phone: widget.phone,
                                      name: name.text,
                                      surname: surname.text,
                                    )));
                        setState(() {
                          checkName = false;
                          checkSurname = false;
                        });
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        )));
  }
}
