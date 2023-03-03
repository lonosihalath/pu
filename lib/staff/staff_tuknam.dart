import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:purer/controller/buynow_model.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/staff/signature_customer.dart';
import 'package:get/get.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TuknamScreen extends StatefulWidget {
  final image;
  final name;
  final surname;
  final int qty;
  final data;
  const TuknamScreen(
      {Key? key,
      required this.image,
      required this.data,
      required this.name,
      required this.surname,
      required this.qty})
      : super(key: key);

  @override
  State<TuknamScreen> createState() => _TuknamScreenState();
}

class _TuknamScreenState extends State<TuknamScreen> {
  TextEditingController touknam1 = TextEditingController();
  String _scanBarcode = '';

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
      qty++;
    });
    print(_scanBarcode);
  }

  int qty = 0;
  int prict = 50000;
  int jumnuanTuk = 0;
  bool checkname = false;
  bool checksurname = false;
  bool qtytuknam = false;
  bool checksignature = false;

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  final staffcontroller = Get.put(StaffController());

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    surname.text = widget.surname;
    jumnuanTuk = widget.qty;
  }

  int totall = 0;

  Map<int, BuynowItem> productbuynow = {};

  void addItem(int productId, id, int price, String name, String image,
      int quantity, String discription, size) {
    if (productbuynow.containsKey(productId)) {
      removeitem(productId);
    } else {
      productbuynow.putIfAbsent(
        productId,
        () => BuynowItem(
            id: id,
            image: image,
            name: name,
            price: price,
            quantity: quantity,
            discription: discription,
            size: size),
      );
    }
    print('5555555555' + productbuynow.length.toString());

    setState(() {
      totall = price * productbuynow.length;
    });
  }

  void removeitem(int productId) {
    productbuynow.remove(productId);
  }

  void tuknam() {
    List.generate(productbuynow.length, (index) => insertTuckname(index));
  }

  insertTuckname(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var data = {
      "bottle_id": productbuynow.values.toList()[index].id,
      "order_id": widget.data['id'].toString(),
      "user_id": widget.data['attributes']['user_id'].toString(),
    };

    var res = await CallApi().postDataOrder(data, 'bottle/insert',
        '${staffcontroller.items.values.toList()[0].token}');
    var dataorder = json.decode(res.body);
    print(dataorder);
  }

  insertDeposit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print('null!!!!');
    var data = {
      'user_id': widget.data['attributes']['user_id'].toString(),
      'order_id': widget.data['id'].toString(),
      'approver_name':
          name.text.isEmpty ? widget.name.toString() : name.text.toString(),
      'approver_surname': surname.text.isEmpty
          ? widget.surname.toString()
          : surname.text.toString(),
      'customer_signature': widget.image.toString(),
      'price': widget.qty!=0? '${prict * widget.qty}' :'${jumnuanTuk *prict}',
      'amount_bottle': widget.qty!=0?'${widget.qty}' : jumnuanTuk.toString(),
    };
    var res = await CallApi().postDatadeposit(data, 'deposit/insert',
        '${staffcontroller.items.values.toList()[0].token}');
    print('statusCode====>' + res.statusCode.toString());
    print('statusCode====>' + res.body.toString());
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Container(
                  alignment: Alignment.center,
                  width: 201,
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'icons/check.png',
                        width: 40,
                      ),
                      SizedBox(height: 10),
                      const Text(
                        'ທ່ານມັດຈຳສຳເລັດແລ້ວ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'branding4',
                            color: Color(0xFF4D4D4F)),
                      )
                    ],
                  ),
                ),
              );
            });
      });
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
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StaffDetailOrder(lat: 0.0, long: 0.0,stafforder: ,)));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff717171),
              )),
        ),
        title: const Text('ມັດຈຳຕຸກນໍ້າ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 18),
          height: 90,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ລວມມູນຄ່າມັດຈຳ:',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 17,
                          fontFamily: 'noto_bold')),
                  Row(
                    children: [
                      Text(nFormat(prict * jumnuanTuk),
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF293275),
                              fontFamily: 'noto_bold')),
                      SizedBox(width: 10),
                      Text('ກີບ',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF293275),
                              fontFamily: 'noto_bold')),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: screen,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                    child: const Text('ຢືນຢັນການມັດຈຳ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'noto_me')),
                    onPressed: () {
                      if (name.text.isEmpty &&
                          surname.text.isEmpty &&
                          qty == 0 &&
                          widget.image == '') {
                        setState(() {
                          checksurname = true;
                          checkname = true;
                          qtytuknam = true;
                          checksignature = true;
                        });
                      }
                      if (name.text.isEmpty) {
                        setState(() {
                          checkname = true;
                        });
                      } else {
                        setState(() {
                          checkname = false;
                        });
                      }
                      ////////////////////////////////////////////////////////////
                      if (surname.text.isEmpty) {
                        setState(() {
                          checksurname = true;
                        });
                      } else {
                        setState(() {
                          checksurname = false;
                        });
                      }
                      if (jumnuanTuk == 0) {
                        setState(() {
                          qtytuknam = true;
                        });
                      } else {
                        setState(() {
                          qtytuknam = false;
                        });
                      }
                      if (widget.image == '') {
                        setState(() {
                          checksignature = true;
                        });
                      } else {
                        setState(() {
                          checksignature = false;
                        });
                      }
                      if (name.text.isNotEmpty &&
                          surname.text.isNotEmpty &&
                          jumnuanTuk != 0 &&
                          widget.image != '') {
                        setState(() {
                          checksurname = false;
                          checkname = false;
                          qtytuknam = false;
                          checksignature = false;
                        });
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => dialog3());
                        insertDeposit();
                      }

                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmOrder()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Text('ຊື່ ແລະ ນາມສະກຸນ ຜູ້ໃຫ້ມັດຈຳ',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 15,
                          fontFamily: 'noto_regular')),
                ],
              ),
              SizedBox(height: 15),
              Container(
                height: 50,
                width: screen * 0.90,
                child: TextFormField(
                    controller: name,
                    //focusNode: focusNode,
                    keyboardType: TextInputType.name,
                    style:
                        const TextStyle(fontSize: 14, fontFamily: 'branding4'),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFEBEBEB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFEBEBEB),
                          width: 0.5,
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
              SizedBox(height: 5),
              checkname == true
                  ? Container(
                      width: screen * 0.90,
                      margin: EdgeInsets.only(),
                      child: Row(
                        children: [
                          Text('ກະລຸນາປ້ອນຊື່',
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
                    controller: surname,
                    //focusNode: focusNode,
                    keyboardType: TextInputType.name,
                    style:
                        const TextStyle(fontSize: 14, fontFamily: 'branding4'),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFEBEBEB),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFEBEBEB),
                          width: 0.5,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      label: const Text('ປ້ອນນາມສະກຸນ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'noto_regular')),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ),
              SizedBox(height: 10),
              checksurname == true
                  ? Container(
                      width: screen * 0.90,
                      margin: EdgeInsets.only(),
                      child: Row(
                        children: [
                          Text('ກະລຸນາປ້ອນນາມສະກຸນ',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontFamily: 'noto_regular')),
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ຈຳນວນຕຸກ: '),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (jumnuanTuk >= 1) {
                            setState(() {
                              jumnuanTuk--;
                            });
                          }
                        },
                        child: Image.asset(
                          'icons/remove.png',
                          width: 40,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        width: 50,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          style: TextStyle(fontSize: 16),
                          controller: touknam1,
                          //focusNode: focusNode,
                          onFieldSubmitted: (value) {
                            // setState(() {
                            //   touknum.add(value);
                            //   totall = price * touknum.length;

                            //   focusNode.requestFocus();
                            //   print(touknum.length);
                            // });
                          },
                          decoration: InputDecoration(
                              hintText: jumnuanTuk.toString(),
                              border: InputBorder.none),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                jumnuanTuk++;
                              });
                              // if (jumnuanTuk < 5) {
                              //   setState(() {
                              //     jumnuanTuk++;
                              //   });
                              // }
                            },
                            child: Image.asset(
                              'icons/add2.png',
                              width: 38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              qtytuknam == true
                  ? Container(
                      width: screen * 0.90,
                      margin: EdgeInsets.only(),
                      child: Row(
                        children: [
                          Text('ກະລຸນາເພີ່ມຈຳນວນຕຸກ',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontFamily: 'noto_regular')),
                        ],
                      ),
                    )
                  : SizedBox(),
              //SizedBox(height: 5),
              // Container(
              //     margin: EdgeInsets.only(top: 25),
              //     height: 50,
              //     child: Container(
              //       width: screen,
              //       height: 50,
              //       child: ClipRRect(
              //         borderRadius: BorderRadius.circular(10),
              //         child: ElevatedButton(
              //           style:
              //               ElevatedButton.styleFrom(primary: Color(0xFF293275)),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: [
              //               Container(
              //                 width: 35,
              //                 child: Image.asset('images/barc.png',
              //                     color: Colors.white),
              //               ),
              //               const SizedBox(width: 10),
              //               const Text('ສະແກນຕຸກ',
              //                   style: TextStyle(
              //                       fontSize: 15,
              //                       color: Color(0xFFFFFFFF),
              //                       fontFamily: 'noto_me')),
              //             ],
              //           ),
              //           onPressed: () async {

              //             scanBarcodeNormal();
              //             //String googleUrl =
              //             //'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}';
              //             //await launchUrl(Uri.parse(googleUrl));

              //           },
              //         ),
              //       ),
              //     ),
              //   ),

              SizedBox(height: 15),
              Row(
                children: [
                  Text('ລາຍເຊັນລູກຄ້າ',
                      style: TextStyle(
                          color: Color(0xFF293275),
                          fontSize: 16,
                          fontFamily: 'noto_bold')),
                ],
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SignatureCustomer(
                                data: widget.data,
                                name: name.text,
                                surname: surname.text,
                                qty: jumnuanTuk,
                              )));
                },
                child: widget.image == ''
                    ? Container(
                        alignment: Alignment.center,
                        width: screen,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 0.5, color: Color(0xFF707070))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.asset(
                                'images/add.png',
                                width: 40,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text('ລາຍເຊັນລູກຄ້າ',
                                style: TextStyle(
                                    color: Color(0xFF5D5D5D),
                                    fontSize: 10,
                                    fontFamily: 'noto_regular')),
                          ],
                        ),
                      )
                    : Container(
                        width: screen,
                        child: Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        )),
              ),
              SizedBox(
                height: 10,
              ),
              checksignature == true
                  ? Container(
                      width: screen * 0.90,
                      margin: EdgeInsets.only(),
                      child: Row(
                        children: [
                          Text('ກະລຸນາເພີ່ມຮູບພາບ',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontFamily: 'noto_regular')),
                        ],
                      ),
                    )
                  : SizedBox(),

              // Image.file(
              //    File('signature_2022-10-14T10:19:28:174185.png'),
              //  ),
            ],
          ),
        ),
      ),
    );
  }
}
