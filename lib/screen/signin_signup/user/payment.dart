import 'package:flutter/material.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  int value = 1;
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
        title: const Text('ຊ່ອງທາງການຈ່າຍເງິນ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24,bottom: 18),
          height: 60,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            width: screen,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                child: Text('ບັນທຶກ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
               
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmOrder()));
                },
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          children: [
             Stack(
              children: [
                GestureDetector(
                    onTap: (){
                     setState(() {
                        value = 1;
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    width: screen,
                    height: 50,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(
                            width: 50,
                            padding: EdgeInsets.all(7),
                            child: Image.asset('icons/money.png')),
                        const SizedBox(width: 10),
                        // ignore: prefer_const_constructors
                        Text('ຈ່າຍເງິນສົດປາຍທາງ',
                            style: const TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 15,
                                fontFamily: 'noto_me'))
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 1,
                  child: Radio(
                      activeColor: Colors.lightBlue,
                      value: 1,
                      groupValue: value,
                      onChanged: (int? val) {
                        print(val);
                        setState(() {
                          value = val!.toInt();
                        });
                      }),
                )
              ],
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                GestureDetector(
                  onTap: (){
                     setState(() {
                        value = 2;
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    width: screen,
                    height: 50,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.grey.shade300, width: 0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Container(
                            width: 50,
                            padding: EdgeInsets.all(3),
                            child: Image.asset('icons/onepay.jpg')),
                        const SizedBox(width: 10),
                        // ignore: prefer_const_constructors
                        Text('BCEL One Pay',
                            style: const TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 15,
                                fontFamily: 'noto_me'))
                      ],
                    ),
                  ),
                ),
                 Positioned(
                  right: 0,
                  top: 1,
                  child: Radio(
                      activeColor: Colors.lightBlue,
                      value: 2,
                      groupValue: value,
                      onChanged: (int? val) {
                        print(val);
                        setState(() {
                        value = val!.toInt();
                        });
                      }),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}