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
import 'package:purer/widgets/vilage_all.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAddress extends StatefulWidget {
  final double lat;
  final double long;
  const EditAddress({Key? key, required this.lat, required this.long})
      : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
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
    });
    getCurrentLocation();
    super.initState();
    markers = Marker(
      markerId: MarkerId('1'),
      position: LatLng(widget.lat, widget.long),
      infoWindow: InfoWindow(
          title: 'ທີ່ຢູ່ຂອງທ່ານ',
          onTap: () {
            print('Tap');
          }),
    );
  }

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
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Address()));
      });
    }
    print(data);
    print(token);
    print('Response status: ${res.statusCode}');
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Address()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff717171),
                )),
          ),
          title: const Text('ທີ່ຢູ່ຈັດສົ່ງ',
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
                  child: const Text('ບັນທຶກ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'noto_me')),
                  onPressed: () {
                    //addressShowController.onInit();
                    showDialog(context: context, builder: (lono)=> dialog3());
                    _insert();
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmOrder()));
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
                    children: [
                      Text('ບ້ານ',
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
                      Text('ເມືອງ',
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
                    children: const [
                      Text('ເເຂວງ',
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
                  //           hintText: 'ເເຂວງ',
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
                  //     Text('ໂທລະສັບ',
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
                  //           hintText: 'ໂທລະສັບ',
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
                      Text('ປ້ອນຂໍ້ມູນເພີ່ມເຕີມ',
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
                          hintText: 'ປ້ອນຂໍ້ມູນເພີ່ມເຕີມ',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5D5D5D),
                              fontFamily: 'noto_regular'),
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
                            Text('ກຳລັງໂຫຼດ',
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
                top: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
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
                  hint: Text(currentSelectedValuedistrict.toString() == 'ໄຊທານີ'
                      ? village7[0]
                      : currentSelectedValuedistrict.toString() == 'ໄຊເສດຖາ'
                          ? village6[0]
                          : currentSelectedValuedistrict.toString() ==
                                  'ສີສັດຕະນາກ'
                              ? village5[0]
                              : currentSelectedValuedistrict.toString() ==
                                      'ຈັນທະບູລີ'
                                  ? village1[0]
                                  : currentSelectedValuedistrict.toString() ==
                                          'ຫາດຊາຍຟອງ'
                                      ? village2[0]
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              'ສີໂຄດຕະບອງ'
                                          ? village4[0]
                                          :currentSelectedValuedistrict
                                                  .toString() ==
                                              'ນາຊາຍທອງ'
                                          ? village3[0] : ''),
                  value: currentSelectedValuevillage,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValuevillage = newValue;
                    });
                    print(currentSelectedValuevillage);
                  },
                  items: currentSelectedValuedistrict.toString() == 'ໄຊທານີ'
                      ? village7.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : currentSelectedValuedistrict.toString() == 'ໄຊເສດຖາ '
                          ? village6.map((String value1) {
                              return DropdownMenuItem<String>(
                                value: value1,
                                child: Text(value1),
                              );
                            }).toList()
                          : currentSelectedValuedistrict.toString() ==
                                  'ສີສັດຕະນາກ '
                              ? village5.map((String value1) {
                                  return DropdownMenuItem<String>(
                                    value: value1,
                                    child: Text(value1),
                                  );
                                }).toList()
                              : currentSelectedValuedistrict.toString() ==
                                      'ຈັນທະບູລີ'
                                  ? village1.map((String value1) {
                                      return DropdownMenuItem<String>(
                                        value: value1,
                                        child: Text(value1),
                                      );
                                    }).toList()
                                  : currentSelectedValuedistrict.toString() ==
                                          'ຫາດຊາຍຟອງ'
                                      ? village2.map((String value1) {
                                          return DropdownMenuItem<String>(
                                            value: value1,
                                            child: Text(value1),
                                          );
                                        }).toList()
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              'ສີໂຄດຕະບອງ '
                                          ? village4.map((String value1) {
                                              return DropdownMenuItem<String>(
                                                value: value1,
                                                child: Text(value1),
                                              );
                                            }).toList()
                                          :currentSelectedValuedistrict
                                                  .toString() ==
                                              'ນາຊາຍທອງ'
                                          ? village3.map((String value1) {
                                              return DropdownMenuItem<String>(
                                                value: value1,
                                                child: Text(value1),
                                              );
                                            }).toList() : null,
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
                      if (currentSelectedValuedistrict.toString() == 'ໄຊທານີ') {
                        setState(() {
                          currentSelectedValuevillage = village7[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ສີສັດຕະນາກ ') {
                        setState(() {
                          currentSelectedValuevillage = village5[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ໄຊເສດຖາ ') {
                        setState(() {
                          currentSelectedValuevillage = village6[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ຈັນທະບູລີ') {
                        setState(() {
                          currentSelectedValuevillage = village1[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ຫາດຊາຍຟອງ') {
                        setState(() {
                          currentSelectedValuevillage = village2[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ສີໂຄດຕະບອງ ') {
                        setState(() {
                          currentSelectedValuevillage = village4[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ນາຊາຍທອງ') {
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

class EditAddress1 extends StatefulWidget {
  final vilage;
  final district;
  final povince;
  final lat;
  final long;
  final notes;

  EditAddress1(
      {Key? key,
      required this.vilage,
      required this.district,
      required this.povince,
      required this.lat,
      required this.long,
      required this.notes})
      : super(key: key);

  @override
  State<EditAddress1> createState() => _EditAddress1State();
}

class _EditAddress1State extends State<EditAddress1> {
  Completer<GoogleMapController> _controller = Completer();
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());
  AddressShowController addressShowController = Get.put(AddressShowController());

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

  late double lat = double.parse(widget.lat.toString());
  late double long = double.parse(widget.long.toString());

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
  @override
  void initState() {
   widget.notes ==null?note.text ='...': note.text = widget.notes;
    setState(() {
      currentSelectedValuedistrict = widget.district;
      currentSelectedValuevillage = widget.vilage;
      currentSelectedValueprovince = widget.povince;
    });
    // getCurrentLocation();
    super.initState();
    markers = Marker(
      markerId: MarkerId('1'),
      position: LatLng(double.parse(widget.lat.toString()),
          double.parse(widget.long.toString())),
      infoWindow: InfoWindow(
          title: 'ທີ່ຢູ່ຂອງທ່ານ',
          onTap: () {
            print('Tap');
          }),
    );
  }

  late List<Marker> _marker = List.generate(2, (index) => Marker(
      markerId: MarkerId('1'),
      position: LatLng(double.parse(widget.lat.toString()),
          double.parse(widget.long.toString())),
      infoWindow: InfoWindow(
          title: 'ທີ່ຢູ່ຂອງທ່ານ',
          onTap: () {
            print('Tap');
          }),
    ));

 
  update() async {
    showDialog(
      barrierDismissible: false,
      context: context, builder: (lono)=> dialog3());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print('null!!!!');
    var data = {
      "division_id": idprovince.toString(),
      "district_id": iddistrict.toString(),
      "state_id": idstate.toString(),
      "latitiude": lat.toString(),
      "longtiude": long.toString(),
      "notes": note.text.length.toInt() == 0 ? '' : note.text,
    };
    var res = await CallApi().postDataupDateAddress(data, addressShowController.statetList[0].id.toString(), token);
    var body = json.decode(res.body);
    print(res.statusCode);
    if (res.statusCode == 201) {
      AddressShowController addressShowController = Get.put(AddressShowController());
      addressShowController.onInit();
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        // Navigator.pop(context);
        // Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Address()));
      });
      print(body);
      print('statusCode====>' + res.statusCode.toString());
    }
  }

    Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );


  late Marker markers;
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Address()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xff717171),
                )),
          ),
          title: const Text('ທີ່ຢູ່ຈັດສົ່ງ',
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
                  child: const Text('ບັນທຶກ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFFFFFFF),
                          fontFamily: 'noto_me')),
                  onPressed: () {
                    //addressShowController.onInit();
                    update();
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=> ConfirmOrder()));
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
                    children: [
                      Text('ບ້ານ',
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
                      Text('ເມືອງ',
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
                    children: const [
                      Text('ເເຂວງ',
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
                  //           hintText: 'ເເຂວງ',
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
                  //     Text('ໂທລະສັບ',
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
                  //           hintText: 'ໂທລະສັບ',
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
                      Text('ປ້ອນຂໍ້ມູນເພີ່ມເຕີມ',
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
                          hintText: 'ປ້ອນຂໍ້ມູນເພີ່ມເຕີມ',
                          hintStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5D5D5D),
                              fontFamily: 'noto_regular'),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            )),
            Positioned(
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
                        setState(() {
                        lat = pos.latitude;
                        long = pos.longitude;
                          markers = Marker(
                            markerId: MarkerId('1'),
                            position: pos,
                          );
                        });
                      },
                      markers: {markers},
                      mapType:
                          statemaps == false ? MapType.normal : MapType.hybrid,
                      initialCameraPosition:
                          CameraPosition(target: LatLng(lat, long), zoom: 16),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                right: 35,
                top: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
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
                  hint: Text(currentSelectedValuedistrict.toString() == 'ໄຊທານີ'
                      ? village7[0]
                      : currentSelectedValuedistrict.toString() == 'ໄຊເສດຖາ '
                          ? village6[0]
                          : currentSelectedValuedistrict.toString() ==
                                  'ສີສັດຕະນາກ '
                              ? village5[0]
                              : currentSelectedValuedistrict.toString() ==
                                      'ຈັນທະບູລີ'
                                  ? village1[0]
                                  : currentSelectedValuedistrict.toString() ==
                                          'ຫາດຊາຍຟອງ'
                                      ? village2[0]
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              'ສີໂຄດຕະບອງ '
                                          ? village4[0]
                                          :currentSelectedValuedistrict
                                                  .toString() ==
                                              'ນາຊາຍທອງ'
                                          ? village3[0] : ''),
                  value: currentSelectedValuevillage,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValuevillage = newValue;
                    });
                    print(currentSelectedValuevillage);
                  },
                  items: currentSelectedValuedistrict.toString() == 'ໄຊທານີ'
                      ? village7.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : currentSelectedValuedistrict.toString() == 'ໄຊເສດຖາ '
                          ? village6.map((String value1) {
                              return DropdownMenuItem<String>(
                                value: value1,
                                child: Text(value1),
                              );
                            }).toList()
                          : currentSelectedValuedistrict.toString() ==
                                  'ສີສັດຕະນາກ '
                              ? village5.map((String value1) {
                                  return DropdownMenuItem<String>(
                                    value: value1,
                                    child: Text(value1),
                                  );
                                }).toList()
                              : currentSelectedValuedistrict.toString() ==
                                      'ຈັນທະບູລີ'
                                  ? village1.map((String value1) {
                                      return DropdownMenuItem<String>(
                                        value: value1,
                                        child: Text(value1),
                                      );
                                    }).toList()
                                  : currentSelectedValuedistrict.toString() ==
                                          'ຫາດຊາຍຟອງ'
                                      ? village2.map((String value1) {
                                          return DropdownMenuItem<String>(
                                            value: value1,
                                            child: Text(value1),
                                          );
                                        }).toList()
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              'ສີໂຄດຕະບອງ '
                                          ? village4.map((String value1) {
                                              return DropdownMenuItem<String>(
                                                value: value1,
                                                child: Text(value1),
                                              );
                                            }).toList()
                                          :currentSelectedValuedistrict
                                                  .toString() ==
                                              'ນາຊາຍທອງ'
                                          ? village3.map((String value1) {
                                              return DropdownMenuItem<String>(
                                                value: value1,
                                                child: Text(value1),
                                              );
                                            }).toList() : null,
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
                      if (currentSelectedValuedistrict.toString() == 'ໄຊທານີ') {
                        setState(() {
                          currentSelectedValuevillage = village7[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ສີສັດຕະນາກ ') {
                        setState(() {
                          currentSelectedValuevillage = village5[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ໄຊເສດຖາ ') {
                        setState(() {
                          currentSelectedValuevillage = village6[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ຈັນທະບູລີ') {
                        setState(() {
                          currentSelectedValuevillage = village1[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ຫາດຊາຍຟອງ') {
                        setState(() {
                          currentSelectedValuevillage = village2[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ສີໂຄດຕະບອງ ') {
                        setState(() {
                          currentSelectedValuevillage = village4[0];
                        });
                      }
                      ;
                      if (currentSelectedValuedistrict.toString() ==
                          'ນາຊາຍທອງ') {
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
