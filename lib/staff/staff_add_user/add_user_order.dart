import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/staff/staff_add_user/controller-user/controller.dart';
import 'package:purer/staff/staff_add_user/detail_order.dart';
import 'package:purer/staff/staff_add_user/order_controller.dart';
import 'package:purer/staff/staff_detail_order_regular.dart';
import 'package:purer/staff/staff_home.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screen/signin_signup/stafflogin/controller_staff.dart';

class StaffAddOrderUser extends StatefulWidget {
  final phone;
  final name;
  final surname;
  final stateId;
  final districtId;
  final divisionId;
  final dataimage;
  final String typeUser;
  final notes;
  final lat;
  final long;
  final image;
  final email;
  final password;
  const StaffAddOrderUser(
      {Key? key,
      required this.phone,
      required this.name,
      required this.surname,
      required this.stateId,
      required this.districtId,
      required this.divisionId,
      required this.notes,
      required this.lat,
      required this.long,
      required this.image,
      required this.typeUser,
      required this.email,
      required this.password,
      required this.dataimage})
      : super(key: key);

  @override
  State<StaffAddOrderUser> createState() => _StaffAddOrderUserState();
}

class _StaffAddOrderUserState extends State<StaffAddOrderUser> {
  final controller = Get.find<Controller>();
  StaffAddOrderController addordercontroller =
      Get.put(StaffAddOrderController());

  // List<String> deviceTypesday = [
  //   'ວັນຈັນ',
  //   'ວັນອັງຄານ',
  //   'ວັນພຸດ',
  //   'ວັນພະຫັດ',
  //   'ວັນສຸກ',
  //   'ວັນເສົາ'
  // ];
  var currentSelectedValueday;

  @override
  void initState() {
    // print(addordercontroller.deviceTypesday.length);
    deleteday();
    setState(() {
      currentSelectedValueday =addordercontroller.deviceTypesday[0];
    });
    setdata();
    super.initState();
  }

  var idUser;
  var idorder;
  List datars = [];

  deleteday() {
    List.generate(
        addordercontroller.items.length,
        (index) => setState(() {
             addordercontroller.deviceTypesday.remove(
                addordercontroller.items.values.toList()[index].day.toString(),
              );
              currentSelectedValueday =addordercontroller.deviceTypesday[0];
            }));
  }

  userRegister() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print(token);
    print('null!!!!');
    var data = {
      'name': widget.name.toString(),
      'surname': widget.surname.toString(),
      'type': widget.typeUser.toString(),
      'email': widget.email.toString(),
      'password': widget.password.toString(),
      'phone':widget.phone.toString(),
    };
    var res = await CallApi().postDataregisterRegular(
        data,
        'truck/register/user/regular',
        '${staffcontroller.items.values.toList()[0].token}');
    var body = json.decode(res.body);
    // print(res.statusCode);
    // print(res.body);
    if (res.statusCode == 200) {
      setState(() {
        idUser = json.encode(body['id']);
        //data = body;
      });
      controller.onInit();
        update();
        _insertAddress();
        insertimageuser();
     
      // print(body);+
      // print('statusCode====>' + res.statusCode.toString());
    }
  }

  void insertimageuser() {
    List.generate(widget.dataimage.length, (index) => insertimage(index));
  }

  final staffcontroller = Get.put(StaffController());
  insertimage(index) async {
    var data = {
      "image": widget.dataimage[index].toString(),
      "user_id": idUser.toString(),
    };

    var res = await CallApi().postDataOrder(data, 'user/image',
        '${staffcontroller.items.values.toList()[0].token}');
    var dataorder = json.decode(res.body);
    print(dataorder);
  }

  _insertAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? userid = preferences.getString('id');
    // print(token);
    // print(userid);
    var data = {
      "user_id": idUser.toString(),
      "division_id": widget.divisionId.toString(),
      "district_id": widget.districtId.toString(),
      "state_id": widget.stateId.toString(),
      "phone":'+85620'+ widget.phone.toString(),
      "latitiude": widget.lat.toString(),
      "longtiude": widget.long.toString(),
      "notes": widget.notes.toString(),
    };
    var res = await CallApi().postDataaddress(data, 'address/insert',
        '${staffcontroller.items.values.toList()[0].token}');
    if (res.statusCode == 201) {
      _addallorder();
      AddressShowController addressShowController =
          Get.put(AddressShowController());
      addressShowController.onInit();
    
     
    }
    // print(data);
    // print(token);
    // print('Response status: ${res.statusCode}');
  }

  update() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'profile': widget.image.toString() == ''
          ? 'https://firebasestorage.googleapis.com/v0/b/purer-company.appspot.com/o/profile%2Flogoapp.jpg?alt=media&token=858a7e44-01f3-42c7-b4ce-778693b0d0c3'
          : widget.image.toString(),
    };
    var res = await CallApi().postDataupDate(
        data, '${idUser}', '${staffcontroller.items.values.toList()[0].token}');
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      // print(body);
      // print('statusCode====>' + res.statusCode.toString());
    }
  }

  updatediposit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print('null!!!!');
    var data = {
      'deposit_status': 'ມັດຈຳແລ້ວ',
    };
    var res = await CallApi().postDataupDate(
        data,
        '${staffcontroller.items.values.toList()[0].id}',
        '${staffcontroller.items.values.toList()[0].token}');
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      // print(body);
      // print('statusCode====>' + res.statusCode.toString());
    }
  }

  int price = 50000;
  TextEditingController qit_bottle = TextEditingController();
   UserAllController userController = Get.put(UserAllController());

  insertDeposit(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    print('null!!!!');
    var data = {
      'user_id': idUser.toString(),
      'order_id': idaddorder[index].toString(),
      'approver_name': 'Purer',
      'approver_surname': 'Purer',
      'customer_signature': '',
      'price':
          '${price * int.parse(addordercontroller.items.values.toList()[index].qtyTuk.toString())}',
      'amount_bottle':
          addordercontroller.items.values.toList()[index].qtyTuk.toString(),
    };
    var res = await CallApi().postDatadeposit(data, 'deposit/insert',
        '${staffcontroller.items.values.toList()[0].token}');
    // print('statusCode====>' + res.statusCode.toString());
    // print('statusCode====>' + res.body.toString());
    var body = json.decode(res.body);
    addordercontroller.clear();
  }

  _addallorder() {
    List.generate(addordercontroller.items.length, (index) => _addroder(index));
  }

  List idaddorder = [];

  _addroder(int index) async {
    // showDialog(context: context, builder: (context) => dialog());
    var data = {
      "user_id": idUser.toString(),
      "division_id": nameDivision.toString(),
      "district_id": nameDistrict.toString(),
      "state_id": nameState.toString(),
      "longitude_id": widget.long.toString(),
      "latitiude_id": widget.lat.toString(),
      "phone": '+85620'+widget.phone.toString(),
      "notes": widget.notes.toString(),
      "day": addordercontroller.items.values.toList()[index].day.toString(),
      "amount_cash": '',
      // "order_month": DateFormat('LLLL').format(date),
      // "order_year": DateFormat('y').format(date),
      "order_type": 'regular',
      'order_items': [
        {
          "image": products[0].image,
          "product_name": products[0].name,
          "size": products[0].size,
          "price": products[0].prict,
          "amount": '',
          "total_amount": '',
        }
      ],
    };
    var res = await CallApi().postDataOrder(data, 'order/insert/regularUser',
        '${staffcontroller.items.values.toList()[0].token}');

    // print(res.body);
    // print('Response status: ${res.statusCode}');

    if (res.statusCode == 201) {
      //print(jsonDecode(res.body)['order']);
      //datars.add(jsonDecode(res.body));
      setState(() {
        idaddorder.add(jsonDecode(res.body)['order']['id'].toString());
      });
        insertDeposit(index);
        updatediposit();
       userController.onInit();
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StaffHome()));
      
      //print(idorder.toString());
     // print('Order=====>  ' + res.body);
      addordercontroller.deviceTypesday.clear();
      addordercontroller.deviceTypesday.add('ວັນຈັນ');
      addordercontroller.deviceTypesday.add('ວັນອັງຄານ');
      addordercontroller.deviceTypesday.add('ວັນພຸດ');
      addordercontroller.deviceTypesday.add('ວັນພະຫັດ');
      addordercontroller.deviceTypesday.add('ວັນສຸກ');
      addordercontroller.deviceTypesday.add('ວັນເສົາ');


      //  setState(() {
      //    datars = jsonDecode(res.body);
      //     print(datars.toString(),);
      //  });

    
       
       // print('=========> ' + datars.toString());
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                addordercontroller.clear();
                Navigator.of(context).pop();
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
                        'ສຳເລັດແລ້ວ',
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
     
    }
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );

  var nameState;
  var nameDistrict;
  var nameDivision;
  setdata() {
    List.generate(
        stateController.statetList.length,
        (index) => stateController.statetList[index].id.toString() ==
                widget.stateId.toString()
            ? setState(() {
                nameState =
                    stateController.statetList[index].stateName!.toString();
                print('===> ${nameState}');
              })
            : null);
    List.generate(
        districtController.statetList.length,
        (index) => districtController.statetList[index].id.toString() ==
                widget.districtId.toString()
            ? setState(() {
                nameDistrict = districtController
                    .statetList[index].districtName!
                    .toString();
                print('===> ${nameDistrict}');
              })
            : null);

    List.generate(
        divisionController.statetList.length,
        (index) => divisionController.statetList[index].id.toString() ==
                widget.divisionId.toString()
            ? setState(() {
                nameDivision = divisionController
                    .statetList[index].divisionName!
                    .toString();
                print('===> ${nameDivision}');
              })
            : null);
  }

  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());

  int jumnuanTuk = 0;

  bool checkqtytuk = false;

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
        title: const Text('ສ້າງອໍເດີ້',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StaffDetailOrders()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 25, top: 25),
              child: Stack(children: [
                Image.asset(
                  'icons/shopcart.png',
                  width: 40,
                ),
                GetBuilder<StaffAddOrderController>(
                    init: StaffAddOrderController(),
                    builder: (context) =>
                        addordercontroller.itemCount.toString() == '0'
                            ? Text('')
                            : Positioned(
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.red),
                                  child: Text(
                                    addordercontroller.itemCount.toString(),
                                    style: TextStyle(
                                        fontSize: 8, fontFamily: 'noto_me'),
                                  ),
                                )))
              ]),
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 18),
          height: 60,
          child: Container(
            margin: EdgeInsets.only(top: 10),
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
                  //insertDeposit();
                  if (addordercontroller.items.length.toString() == '0') {
                    setState(() {
                      checkqtytuk = true;
                    });
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          Future.delayed(Duration(seconds: 1), () {
                            Navigator.of(context).pop(true);
                          });
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            content: Container(
                              alignment: Alignment.center,
                              width: 201,
                              height: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'ກະລຸນາພີ່ມຈຳນວນຕຸກ',
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
                  } else {
                    userRegister();
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (lono) => dialog3());
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => StaffOTPScreen(
                  //             phone: widget.phone,
                  //             name: widget.name,
                  //             surname: widget.surname,
                  //             stateId: widget.stateId,
                  //             districtId: widget.districtId,
                  //             divisionId: widget.divisionId,
                  //             notes: widget.notes,
                  //             lat:widget.lat,
                  //             long: widget.long,day: currentSelectedValueday,)));
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 24)),
              Text('ສີນຄ້າ',
                  style: TextStyle(
                      color: Color(0xFF5D5D5D),
                      fontSize: 18,
                      fontFamily: 'noto_semi'))
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  height: 130,
                  width: 120,
                  decoration: BoxDecoration(
                      color: Color(0xFFE7F2FE),
                      borderRadius: BorderRadius.circular(15)),
                  child: Image.asset('images/purer1.png'),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(products[0].name,
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 18,
                              fontFamily: 'noto_semi')),
                      Text('ຂະຫນາດ 20 L',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 12,
                              fontFamily: 'noto_semi')),
                      Text('ລາຄາ: ' + nFormat(products[0].prict) + ' ກີບ',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 18,
                              fontFamily: 'noto_semi')),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 15),
            child: Row(
              children: [
                Text('ເລືອກມື້',
                    style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 18,
                        fontFamily: 'noto_semi'))
              ],
            ),
          ),

           GetBuilder<StaffAddOrderController>(
                    init: StaffAddOrderController(),
                    builder: (context) =>
                        selectprovince(),),

         
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 18, right: 24),
            child: Row(
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
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700),
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
          ),
          checkqtytuk == true
              ? Container(
                  width: screen * 0.90,
                  margin: EdgeInsets.only(top: 5),
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
          SizedBox(height: 40),
          Container(
            margin: EdgeInsets.only(left: 24, right: 24, bottom: 18),
            height: 60,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: screen,
              height: 50,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                  child: const Text('ເພີ່ມອໍເດີ້',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'noto_me')),
                  onPressed: () {
                    if (jumnuanTuk == 0) {
                      setState(() {
                        checkqtytuk = true;
                      });
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            Future.delayed(Duration(seconds: 1), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              content: Container(
                                alignment: Alignment.center,
                                width: 201,
                                height: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'ກະລຸນາພີ່ມຈຳນວນຕຸກ',
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
                    } else {
                      int i = 1000000;
                      int iint = Random().nextInt(i);
                      addordercontroller.addItem(
                          1 + iint,
                          1 + iint,
                          currentSelectedValueday.toString(),
                          int.parse(jumnuanTuk.toString()),
                          50000);
                      setState(() {
                        jumnuanTuk = 0;
                        checkqtytuk = false;
                      });
                      // showDialog(
                      //     barrierDismissible: false,
                      //     context: context,
                      //     builder: (lono) => dialog3());
                      setState(() {
                        addordercontroller.deviceTypesday
                            .remove(currentSelectedValueday.toString());
                        currentSelectedValueday =addordercontroller.deviceTypesday[0];
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Container selectprovince() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, top: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFFEBEBEB)),
          borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text(addordercontroller.deviceTypesday[0]),
                  value: currentSelectedValueday,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValueday = newValue;
                    });
                    print(currentSelectedValueday);
                  },
                  items: addordercontroller.deviceTypesday.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
