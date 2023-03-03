import 'dart:typed_data';

import 'package:flutter/material.dart';

class BillDeposit extends StatelessWidget {
  final Uint8List bytes;
  const BillDeposit({Key? key, required this.bytes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
        title: const Text('ໃບບິນມັດຈຳ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Image.memory(bytes))
          ],
        ),
      ),
    );
  }
}