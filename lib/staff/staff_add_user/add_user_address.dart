import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/address.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/staff/staff_add_user/add_user_order.dart';
import 'package:purer/staff/staff_add_user/add_user_otp.dart';
import 'package:purer/staff/staff_add_user/image_address.dart';
import 'package:purer/staff/staff_home.dart';
import 'package:purer/widgets/vilage_all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffAddUserAddress extends StatefulWidget {
  final double lat;
  final double long;
  final String name;
  final String surname;
  final String TypeUser;
  final phone;
  final email;
  final password;
  final image;
  const StaffAddUserAddress({
    Key? key,
    required this.lat,
    required this.long,
    required this.name,
    required this.phone,
    required this.image,
    required this.surname,
    required this.TypeUser,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<StaffAddUserAddress> createState() => _StaffAddUserAddressState();
}

class _StaffAddUserAddressState extends State<StaffAddUserAddress> {
  Completer<GoogleMapController> _controller = Completer();
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());

  late BitmapDescriptor customIcon;
  createMarker(context) {
    ImageConfiguration configuration = createLocalImageConfiguration(context);
    BitmapDescriptor.fromAssetImage(
      configuration,
      'icons/ll.png',
    ).then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

  bool state = false;
  bool statemaps = false;

  Future getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      state = true;
      lat = position.latitude;
      long = position.longitude;
    });
  }

  double lat = 0.0;
  double long = 0.0;

  TextEditingController name = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController village = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController note = TextEditingController();

  var currentSelectedValueprovince;
  var currentSelectedValuedistrict;
  var currentSelectedValuevillage;

  var iddistrict;
  var idstate;
  var idprovince;
  var Userid;

  final controller = Get.find<Controller>();

  late Marker markers;
  @override
  void initState() {
    setState(() {
      currentSelectedValuedistrict = deviceTypesdistrict[0];
      currentSelectedValuevillage = village1[0];
      currentSelectedValueprovince = deviceTypesdivision[0];
      note.text = '...';
    });
    getCurrentLocation();
    super.initState();
    markers = Marker(
      markerId: MarkerId('1'),
      position: LatLng(widget.lat, widget.long),
      infoWindow: InfoWindow(
          title: '???????????????????????????????????????',
          onTap: () {
            print('Tap');
          }),
    );
  }

  var idUser;

  userRegister() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      'name': widget.name.toString(),
      'surname': widget.surname.toString(),
      'phone': widget.phone.toString(),
    };
    var res = await CallApi()
        .postDataupDate(data, 'truck/register/user/regular', token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      setState(() {
        idUser = json.encode(body['user']['id']);
      });
      controller.onInit();
      Timer(Duration(seconds: 1), () {
        _insertAddress();
      });
      // print(body);
      // print('statusCode====>' + res.statusCode.toString());
    }
  }

  _insertAddress() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? userid = preferences.getString('id');
    print(token);
    print(userid);

    var data = {
      "user_id": idUser.toString(),
      "division_id": idprovince.toString(),
      "district_id": iddistrict.toString(),
      "state_id": idstate.toString(),
      "phone": widget.phone.toString(),
      "latitiude": widget.lat.toString(),
      "longtiude": widget.long.toString(),
      "notes": note.text.toString(),
    };
    var res = await CallApi().postDataaddress(data, 'address/insert', token);
    if (res.statusCode == 201) {
      AddressShowController addressShowController =
          Get.put(AddressShowController());
      addressShowController.onInit();
      Timer(Duration(seconds: 1), () {
        // _addroder();
      });
    }
    // print(data);
    // print(token);
    // print('Response status: ${res.statusCode}');
  }

  // _addroder() async {
  //   // showDialog(context: context, builder: (context) => dialog());
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String? token = preferences.getString('token');
  //   String? id = preferences.getString('id');
  //   var data = {
  //     "user_id": idUser.toString(),
  //     "division_id": idprovince.toString(),
  //     "district_id": iddistrict.toString(),
  //     "state_id": idstate.toString(),
  //     "longitude_id": long.toString(),
  //     "latitiude_id": lat.toString(),
  //     "phone": widget.phone.toString(),
  //     "notes": n,
  //     "day": widget.day.toString(),
  //     "amount_cash": '',
  //     "order_month": DateFormat('LLLL').format(date),
  //     "order_year": DateFormat('y').format(date),
  //     "order_type":'regular',
  //     'order_items': [{
  //        "image":products[0].image,
  //               "product_name":products[0].name,
  //               "size":products[0].size,
  //               "price":products[0].prict,
  //               "amount": '',
  //               "total_amount":'',
  //     }],
  //   };
  //   var res = await CallApi().postDataOrder(
  //       data,'order/insert/regularUser',

  //       token);
  //   var dataorder = json.decode(res.body);

  //   // print(res.body);
  //   // print('Response status: ${res.statusCode}');
  //   if (res.statusCode == 201) {
  //    Future.delayed(Duration(seconds: 1),(){
  //     Navigator.pop(context);
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => StaffHome()));
  //     showDialog(
  //         barrierDismissible: false,
  //         context: context,
  //         builder: (BuildContext context) {
  //           Future.delayed(Duration(seconds: 2), () {
  //             Navigator.of(context).pop(true);
  //           });
  //           return AlertDialog(
  //             backgroundColor: Colors.white,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20)),
  //             content: Container(
  //               alignment: Alignment.center,
  //               width: 201,
  //               height: 90,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Image.asset(
  //                     'icons/check.png',
  //                     width: 40,
  //                   ),
  //                   SizedBox(height: 10),
  //                   const Text(
  //                     '??????????????????????????????',
  //                     style: TextStyle(
  //                         fontSize: 15,
  //                         fontFamily: 'branding4',
  //                         color: Color(0xFF4D4D4F)),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         });
  //    });
  //   }
  // }

  _insert() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? userid = preferences.getString('id');
    print(token);
    print(userid);

    var data = {
      "user_id": controller.photoList[0].id.toString(),
      "division_id": idprovince.toString(),
      "district_id": iddistrict.toString(),
      "state_id": idstate.toString(),
      "phone": controller.photoList[0].phone.toString(),
      "latitiude": lat.toString(),
      "longtiude": long.toString(),
      "notes": note.text.length.toInt() == 0 ? '' : note.text,
    };
    var res = await CallApi().postDataaddress(data, 'address/insert', token);
    if (res.statusCode == 201) {
      AddressShowController addressShowController =
          Get.put(AddressShowController());
      addressShowController.onInit();
      Timer(Duration(seconds: 1), () {
        //Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Address()));
      });
    }
    print(data);
    print(token);
    print('Response status: ${res.statusCode}');
  }

  @override
  Widget build(BuildContext context) {
    List.generate(
        districtController.statetList.length,
        (index) => districtController.statetList[index].districtName ==
                currentSelectedValuedistrict
            ? setState(() {
                iddistrict =
                    districtController.statetList[index].id!.toString();
                print(iddistrict);
              })
            : null);
    List.generate(
        stateController.statetList.length,
        (index) => stateController.statetList[index].stateName ==
                currentSelectedValuevillage
            ? setState(() {
                idstate = stateController.statetList[index].id!.toString();
                print('===> ${idstate}');
              })
            : null);
    List.generate(
        divisionController.statetList.length,
        (index) => divisionController.statetList[index].divisionName ==
                currentSelectedValueprovince
            ? setState(() {
                idprovince =
                    divisionController.statetList[index].id!.toString();
                print('===> ${idprovince}');
              })
            : null);
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
                  //print(stateController.statetList.where((p0) => p0.districtId.toString()=='7').length);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff717171),
                )),
          ),
          title: const Text('???????????????????????????????????????',
              style: TextStyle(
                  color: Color(0xFF293275),
                  fontSize: 18,
                  fontFamily: 'noto_semi')),
          centerTitle: true,
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
                  child: const Text('??????????????????',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'noto_me')),
                  onPressed: () {
                    //addressShowController.onInit();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (lono) => CreateImageAddress(
                                  phone: widget.phone,
                                  name: widget.name,
                                  surname: widget.surname,
                                  stateId: idstate,
                                  districtId: iddistrict,
                                  divisionId: idprovince,
                                  notes: note.text,
                                  lat: lat,
                                  image: widget.image,
                                  long: long,
                                  typeUser: widget.TypeUser.toString(),
                                  email: widget.email.toString(),
                                  password: widget.password,
                                )));
                  },
                ),
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  SizedBox(height: screen1 * 0.35),
                  Row(
                    children: const [
                      Text('???????????????',
                          style: TextStyle(
                              color: Color(0xFFB1B1B1),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                    ],
                  ),

                  SizedBox(height: 5),
                  selectciy(),

                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text('????????????',
                          style: TextStyle(
                              color: Color(0xFFB1B1B1),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                    ],
                  ),
                  SizedBox(height: 5),
                  selectvillage(),

                  SizedBox(height: 6),
                  Row(
                    children: const [
                      Text('???????????????',
                          style: TextStyle(
                              color: Color(0xFFB1B1B1),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                    ],
                  ),
                  SizedBox(height: 5),
                  selectprovince(),
                  // Container(
                  //   padding: EdgeInsets.only(left: 10, top: 20),
                  //   width: screen,
                  //   height: 43,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white,
                  //       border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                  //   child: Container(
                  //     width: screen,
                  //     child: TextFormField(
                  //       keyboardType: TextInputType.emailAddress,
                  //       style: const TextStyle(fontSize: 16),
                  //       decoration: const InputDecoration(
                  //           hintText: '???????????????',
                  //           hintStyle: TextStyle(
                  //               fontSize: 14,
                  //               color: Color(0xFF5D5D5D),
                  //               fontFamily: 'noto_semi'),
                  //           border: InputBorder.none),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 6),
                  // Row(
                  //   children: const [
                  //     Text('?????????????????????',
                  //         style: TextStyle(
                  //             color: Color(0xFFB1B1B1),
                  //             fontSize: 15,
                  //             fontFamily: 'noto_regular')),
                  //   ],
                  // ),
                  // SizedBox(height: 5),
                  //  Container(
                  //   padding: EdgeInsets.only(left: 10, top: 20),
                  //   width: screen,
                  //   height: 43,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Colors.white,
                  //       border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                  //   child: Container(
                  //     width: screen,
                  //     child: TextFormField(
                  //       keyboardType: TextInputType.emailAddress,
                  //       style: const TextStyle(fontSize: 16),
                  //       decoration: const InputDecoration(
                  //           hintText: '?????????????????????',
                  //           hintStyle: TextStyle(
                  //               fontSize: 14,
                  //               color: Color(0xFF5D5D5D),
                  //               fontFamily: 'noto_semi'),
                  //           border: InputBorder.none),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 8),
                  Row(
                    children: const [
                      Text('?????????????????????????????????????????????????????????',
                          style: TextStyle(
                              color: Color(0xFFB1B1B1),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                    ],
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: screen,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(width: 1, color: Color(0xFFEBEBEB))),
                    child: TextField(
                      controller: note,
                      keyboardType: TextInputType.streetAddress,
                      maxLines: 8,
                      decoration: InputDecoration(
                          label: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '????????????????????????????????????????????????????????????????????????: ????????????,??????????????????????????????,??????????????????????????????????????????',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF5D5D5D),
                                    fontFamily: 'noto_regular'),
                              ),
                            ],
                          ),
                          // hintText: '?????????????????????????????????????????????????????????',

                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            )),
            state == true
                ? Positioned(
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      alignment: Alignment.center,
                      width: screen,
                      height: screen1 * 0.33,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            onTap: (pos) {
                              lat = pos.latitude;
                              long = pos.longitude;
                              setState(() {
                                markers = Marker(
                                  markerId: MarkerId('1'),
                                  position: pos,
                                );
                              });
                            },
                            markers: {markers},
                            mapType: statemaps == false
                                ? MapType.normal
                                : MapType.hybrid,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(lat, long), zoom: 16),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    child: Container(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      alignment: Alignment.center,
                      width: screen,
                      height: screen1 * 0.33,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: screen,
                        decoration: BoxDecoration(
                            color: Color(0xFFE5EFF9),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 5),
                            Text('???????????????????????????',
                                style: TextStyle(
                                    color: Color(0xFF293275),
                                    fontSize: 15,
                                    fontFamily: 'noto_me'))
                          ],
                        ),
                      ),
                    ),
                  ),
            Positioned(
                right: 35,
                top: 15,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        setState(() {
                          statemaps = !statemaps;
                        });
                      },
                      icon: Icon(
                        Icons.layers_outlined,
                        color: Colors.blue,
                      )),
                ))
          ],
        ));
  }

  Container selectvillage() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0xFFEBEBEB)),
        borderRadius: BorderRadius.circular(10),
      ),
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
                  hint: Text(currentSelectedValuedistrict.toString() == '??????????????????'
                      ? village7[0]
                      : currentSelectedValuedistrict.toString() == '????????????????????? '
                          ? village6[0]
                          : currentSelectedValuedistrict.toString() ==
                                  '?????????????????????????????? '
                              ? village5[0]
                              : currentSelectedValuedistrict.toString() ==
                                      '???????????????????????????'
                                  ? village1[0]
                                  : currentSelectedValuedistrict.toString() ==
                                          '???????????????????????????'
                                      ? village2[0]
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              '?????????????????????????????? '
                                          ? village4[0]
                                          : currentSelectedValuedistrict
                                                      .toString() ==
                                                  '????????????????????????'
                                              ? village3[0]
                                              : ''),
                  value: currentSelectedValuevillage,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValuevillage = newValue;
                    });
                    print(currentSelectedValuevillage);
                  },
                  items: currentSelectedValuedistrict.toString() == '??????????????????'
                      ? village7.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : currentSelectedValuedistrict.toString() == '????????????????????? '
                          ? village6.map((String value1) {
                              return DropdownMenuItem<String>(
                                value: value1,
                                child: Text(value1),
                              );
                            }).toList()
                          : currentSelectedValuedistrict.toString() ==
                                  '?????????????????????????????? '
                              ? village5.map((String value1) {
                                  return DropdownMenuItem<String>(
                                    value: value1,
                                    child: Text(value1),
                                  );
                                }).toList()
                              : currentSelectedValuedistrict.toString() ==
                                      '???????????????????????????'
                                  ? village1.map((String value1) {
                                      return DropdownMenuItem<String>(
                                        value: value1,
                                        child: Text(value1),
                                      );
                                    }).toList()
                                  : currentSelectedValuedistrict.toString() ==
                                          '???????????????????????????'
                                      ? village2.map((String value1) {
                                          return DropdownMenuItem<String>(
                                            value: value1,
                                            child: Text(value1),
                                          );
                                        }).toList()
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              '?????????????????????????????? '
                                          ? village4.map((String value1) {
                                              return DropdownMenuItem<String>(
                                                value: value1,
                                                child: Text(value1),
                                              );
                                            }).toList()
                                          : currentSelectedValuedistrict
                                                      .toString() ==
                                                  '????????????????????????'
                                              ? village3.map((String value1) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value1,
                                                    child: Text(value1),
                                                  );
                                                }).toList()
                                              : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container selectciy() {
    return Container(
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
                  hint: Text(deviceTypesdistrict[0]),
                  value: currentSelectedValuedistrict,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValuedistrict = newValue;
                      if (currentSelectedValuedistrict.toString() == '??????????????????') {
                        setState(() {
                          currentSelectedValuevillage = village7[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          '?????????????????????????????? ') {
                        setState(() {
                          currentSelectedValuevillage = village5[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          '????????????????????? ') {
                        setState(() {
                          currentSelectedValuevillage = village6[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          '???????????????????????????') {
                        setState(() {
                          currentSelectedValuevillage = village1[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          '???????????????????????????') {
                        setState(() {
                          currentSelectedValuevillage = village2[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          '?????????????????????????????? ') {
                        setState(() {
                          currentSelectedValuevillage = village4[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          '????????????????????????') {
                        setState(() {
                          currentSelectedValuevillage = village3[0];
                        });
                      }
                      ;
                    });
                    print(currentSelectedValuedistrict);
                  },
                  items: deviceTypesdistrict.map((String value) {
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

  Container selectprovince() {
    return Container(
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
                  hint: Text(deviceTypesdivision[0]),
                  value: currentSelectedValueprovince,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValueprovince = newValue;
                    });
                    print(currentSelectedValueprovince);
                  },
                  items: deviceTypesdivision.map((String value) {
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
