import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purer/address/address_show/controller.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/controller/cart_controller.dart';
import 'package:purer/screen/signin_signup/user/editAddress.dart';
import 'package:purer/widgets/vilage_all.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Address extends StatefulWidget {
  const Address({Key? key}) : super(key: key);

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  delate(String id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    String url = 'https://purer.cslox-th.ruk-com.la/api/address/delete/$id';
    var response = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var status = response.statusCode;
    if (status == 201) {
      addressShowController.onInit();
    }
    print(status);
  }

  double lat = 0.0;
  double long = 0.0;
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

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    addressShowController.statetList.isEmpty ? null : setdata();
  }

  setdata() {
    List.generate(
        stateController.statetList.length,
        (index) => stateController.statetList[index].id.toString() ==
                addressShowController.statetList[0].stateId.toString()
            ? setState(() {
                nameState =
                    stateController.statetList[index].stateName!.toString();
                print('===> ${nameState}');
              })
            : null);
    List.generate(
        districtController.statetList.length,
        (index) => districtController.statetList[index].id.toString() ==
                addressShowController.statetList[0].districtId.toString()
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
                addressShowController.statetList[0].divisionId.toString()
            ? setState(() {
                nameDivision = divisionController
                    .statetList[index].divisionName!
                    .toString();
                print('===> ${nameDivision}');
              })
            : null);
    List.generate(addressShowController.statetList.where((p0) => false).length,
        (index) => null);
  }

  var nameState;
  var nameDistrict;
  var nameDivision;
  var id;
  //final cartController = Get.put(CartController());
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());

  AddressShowController addressShowController =
      Get.put(AddressShowController());

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
        title: const Text('ທີ່ຢູ່ຈັດສົ່ງ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar:
          Obx((() => addressShowController.statetList.isNotEmpty
              ? Container(
                  height: 1,
                )
              : SafeArea(
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
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF293275)),
                          child: Text('ເພີ່ມທີ່ຢູ່',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: 'noto_me')),
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAddress(
                                          lat: lat,
                                          long: long,
                                        )));
                          },
                        ),
                      ),
                    ),
                  ),
                ))),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Obx((() => addressShowController.statetList.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Text('ທ່ານຍັງບໍ່ມີທີ່ຢູ່',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 16,
                              fontFamily: 'noto_regular')),
                    ),
                  )
                : Obx(() {
                    if (addressShowController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        children: List.generate(
                            addressShowController.statetList.length,
                            (index) => Container(
                                  width: screen,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            child: Image.asset(
                                                'icons/location.png'),
                                          ),
                                          SizedBox(width: 15),
                                          Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      nameState,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color:
                                                              Color(0xFF5D5D5D),
                                                          fontFamily:
                                                              'noto_bold'),
                                                    ),
                                                   addressShowController
                                                          .statetList[0].notes
                                                          .toString()=='null'?SizedBox(): Text(
                                                      addressShowController
                                                          .statetList[0].notes
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color:
                                                              Color(0xFF5D5D5D),
                                                          fontFamily:
                                                              'noto_me'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            child: IconButton(
                                              padding: EdgeInsets.all(0),
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => EditAddress1(
                                                            vilage: nameState,
                                                            district:
                                                                nameDistrict,
                                                            povince:
                                                                nameDivision,
                                                            lat:
                                                                addressShowController
                                                                    .statetList[
                                                                        0]
                                                                    .latitiude,
                                                            long:
                                                                addressShowController
                                                                    .statetList[
                                                                        0]
                                                                    .longtiude,
                                                            notes:
                                                                addressShowController
                                                                    .statetList[
                                                                        0]
                                                                    .notes)));
                                              },
                                              icon: Icon(Icons.edit_outlined,
                                                  color: Color(0xFF293275)),
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Container(
                                            width: 28,
                                            child: IconButton(
                                                padding: EdgeInsets.all(0),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          dialog());
                                                },
                                                icon: Image.asset(
                                                  'icons/datete.png',
                                                  width: 28,
                                                  color: Color(0xFF293275),
                                                )),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                      );
                    }
                  })))
          ],
        ),
      )),
    );
  }

  Widget dialog() => CupertinoAlertDialog(
        title: Text('ລົບທີ່ຢູ່ ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        content: Text('ທ່ານຕ້ອງການລົບທີ່ຢູ່ລາຍການນີ້ ຫຼື ບໍ່ ?'),
        actions: [
          CupertinoDialogAction(
            child: Text('ຕົກລົງ'),
            onPressed: () {
              Navigator.pop(context);
              delate(addressShowController.statetList[0].id.toString());
            },
          ),
          CupertinoDialogAction(
            child: Text('ຍົກເລີກ'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
}
