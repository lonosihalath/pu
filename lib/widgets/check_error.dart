
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class Server_Error extends StatefulWidget {
  const Server_Error({Key? key}) : super(key: key);

  @override
  State<Server_Error> createState() => _Server_ErrorState();
}

class _Server_ErrorState extends State<Server_Error> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(milliseconds: 10), ()=> showLog());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold();
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
                    'ຂໍອະໄພ',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'noto_regular',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Center(
                        child: Text(
                      'ລະບົບປິດປັບປຸງຊົ່ວຄາວ',
                      style: TextStyle(fontSize: 14,fontFamily: 'noto_regular'),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(right: 15,left: 15),
                    width: 250,
                    height: 35.0,
                    child: RaisedButton(
                      onPressed: () async {
                        exit(0);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Color(0xFF293275),
                            // gradient: LinearGradient(
                            //   colors: [
                            //     Color(0xFF25C4F4),
                            //     Color(0xFF007CC4),
                            //   ],
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,
                            // ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: screen, minHeight: 50.0),
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
