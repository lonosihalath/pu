import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:purer/screen/products/product.dart';

class KebTuknam extends StatefulWidget {
  const KebTuknam({Key? key}) : super(key: key);

  @override
  State<KebTuknam> createState() => _KebTuknamState();
}

class _KebTuknamState extends State<KebTuknam> {

  String _scanBarcode = '';

  List date =[];
  List idT = [];


  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print(_scanBarcode.toString());
      date.add(DateTime.now().toString());
      idT.add(_scanBarcode.toString());
    });
    print(date);
    print(idT);
  
  }
  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    return Scaffold(
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
        title: const Text('ເກັບຕຸກນໍ້າ',
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
                child: const Text('ຢືນຢັນ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
                 
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 100,
                child: Image.asset(products[0].image),
              ),
              Container(
                margin: EdgeInsets.only(top: 25),
                height: 50,
                child: Container(
                  width: screen *0.88,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 35,
                            child: Image.asset('images/barc.png',
                                color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          const Text('ສະແກນຕຸກ',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'noto_me')),
                        ],
                      ),
                      onPressed: () async {
                        scanBarcodeNormal();
                        //String googleUrl =
                        //'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}';
                        //await launchUrl(Uri.parse(googleUrl));
                      },
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      )),
    );
    
  }
}