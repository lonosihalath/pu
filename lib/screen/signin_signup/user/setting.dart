import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool isChecked = true;
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
        title: const Text('ຕັ້ງຄ່າ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, top: 10,right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('ພາສາ',
                    style: TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 15,
                        fontFamily: 'noto_regular')),
              ],
            ),
            Row(
              children: [
                Container(
                  height: 40,
                  width: screen * 0.65,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xFFEBEBEB)),
                      borderRadius: BorderRadius.circular(7)),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Image.asset(
                        'icons/laos.png',
                        width: 24,
                      ),
                      SizedBox(width: 10),
                      Text('ລາວ',
                          style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Row(
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF293275),
                      size: 20,
                    ),
                    Text('_ ແກ້ໄຂ',
                        style: TextStyle(
                            color: Color(0xFF293275),
                            fontSize: 15,
                            fontFamily: 'noto_semi')),
                  ],
                )
              ],
            ),
            SizedBox(height: 14),
            Container(
              height: 40,
                  width:screen,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xFFEBEBEB)),
                      borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        children: [
                           Checkbox(
                          
              checkColor: Colors.white,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
                      Text('ຮັບການແຈ້ງເຕືອນ',
                          style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                        ],
                      ),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
