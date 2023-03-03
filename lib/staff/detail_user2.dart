import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/district/model.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/division/model.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/address/state/model.dart';
import 'package:purer/staff/staff_add_user/controller-user/controller.dart';
import 'package:purer/staff/staff_add_user/controller-user/model.dart';
import 'package:purer/staff/staff_add_user/profile_photo.dart';
import 'package:purer/staff/staff_add_user/updatedata_user.dart';
import 'package:purer/staff/staff_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screen/signin_signup/stafflogin/controller_staff.dart';

class StaffDetailUser2 extends StatefulWidget {
  final UserAll userAll;
  const StaffDetailUser2({Key? key, required this.userAll}) : super(key: key);

  @override
  State<StaffDetailUser2> createState() => _StaffDetailUser2State();
}

class _StaffDetailUser2State extends State<StaffDetailUser2> {
  @override
  void initState() {
    super.initState();
     userdataaddress();
    userdataimage();
   // userdata();
  }

  List data = [];
  List dataimageuser = [];
  List dataaddress = [];

  bool isLoading = true;
  bool isLoadingimage = true;
  bool isLoadingaddress = true;
  final staffcontroller = Get.put(StaffController());
  Completer<GoogleMapController> _controller = Completer();

  // userdata() async {
  //   final response = await http.get(
  //       Uri.parse(
  //           'https://purer.cslox-th.ruk-com.la/api/user/detail/${widget.userAll.id.toString()}'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization':
  //             'Bearer ${staffcontroller.items.values.toList()[0].token}',
  //       });
  //   print(response.statusCode);
  //   var json = jsonDecode(response.body);
  //   print(json);
  //   if (response.statusCode == 201) {
  //     data.add(json);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  userdataimage() async {
    final response = await http.get(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/user/image/show/${widget.userAll.id.toString()}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}',
        });
    print(response.statusCode);
    var json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 200) {
      setState(() {
        dataimageuser = json;
        isLoadingimage = false;
      });
    }
  }

  userdataaddress() async {
    final response = await http.get(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/address/show/${widget.userAll.id.toString()}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}',
        });
    print(response.statusCode);
    var json = jsonDecode(response.body);
    print(json);
    if (response.statusCode == 201) {
      setState(() {
        dataaddress = json;
        isLoadingaddress = false;
        markers = Marker(
          markerId: MarkerId('1'),
          position: LatLng(double.parse(dataaddress[0]['latitiude'].toString()),
              double.parse(dataaddress[0]['longtiude'].toString())),
          infoWindow: InfoWindow(
              title: 'ທີ່ຢູ່ຂອງລູກຄ້າ',
              onTap: () {
                print('Tap');
              }),
        );
      });
    }
  }

  DistrictController districtController = Get.put(DistrictController());
  StateController stateController = Get.put(StateController());
  DivisionController divisionController = Get.put(DivisionController());
  UserAllController userAllController = Get.put(UserAllController());
  late Marker markers;
  bool statemaps = false;

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double width = MediaQuery.of(context).size.width;
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
        title: const Text('ຂໍ້ມູນລູກຄ້າ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
          width: width,
          child: Container(
            width: width,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                child: const Text('ແກ້ໄຂຂໍ້ມູນ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
                  //print(dataaddress.toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StaffUptateData(
                                userAll:userAllController.statetList.where((p0) => p0.id.toString()== widget.userAll.id.toString()).first,
                                state: sataetName(stateController.statetList
                                    .where((p0) =>
                                        p0.id.toString() ==
                                        dataaddress[0]['state_id'].toString())
                                    .toList()
                                    .first),
                                district: districtName(districtController
                                    .statetList
                                    .where((p0) =>
                                        p0.id.toString() ==
                                        dataaddress[0]['district_id']
                                            .toString())
                                    .toList()
                                    .first),
                                division: divisiontName(divisionController
                                    .statetList
                                    .where((p0) =>
                                        p0.id.toString() ==
                                        dataaddress[0]['division_id']
                                            .toString())
                                    .toList()
                                    .first),
                                lat: dataaddress[0]['latitiude'].toString(),
                                long: dataaddress[0]['longtiude'].toString(),
                                idaddress: dataaddress[0]['id'].toString(),
                                dataimage: dataimageuser,
                              )));
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 24, top: 10, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx((){
              if(userAllController.isLoading.value){
                return Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('ກຳລັງໂຫຼດ',
                              style: TextStyle(
                                  color: Color(0xFF293275),
                                  fontSize: 17,
                                  fontFamily: 'noto_me')),
                        ],
                      ),
                    ),
                  );
              }else{
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('ຂໍ້ມູນທົ່ວໄປ',
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_bold'))
                        ],
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (lono) => GalleryImageProfile(
                                      image: widget.userAll.profile.toString())));
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                widget.userAll.profile.toString(),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('ໄອດີ:   ' + widget.userAll.userId.toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_regular'))
                        ],
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: screen,
                        child: Text(
                            'ຊື່ ແລະ ນາມສະກຸນ:   ' +
                               widget.userAll.name.toString() +
                                '  ' +
                                widget.userAll.surname.toString(),
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                                fontFamily: 'noto_regular')),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                              'ອີເມວ:   ' + widget.userAll.email.toString() ==
                                      'null'
                                  ? 'ຍັງບໍ່ມີ'
                                  : 'ອີເມວ:   ' + widget.userAll.email.toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_regular'))
                        ],
                      ),
                      SizedBox(height: 5),
                      widget.userAll.phone.toString() == 'null'
                          ? SizedBox()
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    String googleUrl =
                                        'whatsapp://send?phone=${widget.userAll.phone.toString()}&text=ສະບາຍດີ';
                                    await launchUrl(Uri.parse(googleUrl));
                                  },
                                  child: Text(
                                      'ໂທລະສັບ:   ' +
                                          widget.userAll.phone.toString() +
                                          '    ',
                                      style: TextStyle(
                                          color: Color(0xFF293275),
                                          fontSize: 16,
                                          fontFamily: 'noto_regular')),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    String googleUrl =
                                        'whatsapp://send?phone=${widget.userAll.phone.toString()}&text=ສະບາຍດີ';
                                    await launchUrl(Uri.parse(googleUrl));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey)),
                                    width: 40,
                                    height: 40,
                                    child: Image.asset('icons/wa.png'),
                                  ),
                                )
                              ],
                            ),
                    ],
                  );
              }
            }),
           
            SizedBox(height: 5),
            isLoadingaddress == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('ກຳລັງໂຫຼດ',
                              style: TextStyle(
                                  color: Color(0xFF293275),
                                  fontSize: 17,
                                  fontFamily: 'noto_me')),
                        ],
                      ),
                    ),
                  )
                : Container(
                    width: screen,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'ທີ່ຢູ່:   ' +
                                  sataetName(stateController.statetList
                                      .where((p0) =>
                                          p0.id.toString() ==
                                          dataaddress[0]['state_id'].toString())
                                      .toList()
                                      .first) +
                                  ', ' +
                                  districtName(districtController.statetList
                                      .where((p0) =>
                                          p0.id.toString() ==
                                          dataaddress[0]['district_id']
                                              .toString())
                                      .toList()
                                      .first) +
                                  ', ' +
                                  divisiontName(divisionController.statetList
                                      .where((p0) =>
                                          p0.id.toString() ==
                                          dataaddress[0]['division_id']
                                              .toString())
                                      .toList()
                                      .first),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_regular')),
                          SizedBox(height: 5),
                          Container(
                            width: screen,
                            child: Text(
                                'ລາຍລະອຽດຮ່ອມ ແລະ ເລກທີບ້ານ: ' +
                                    '${dataaddress[0]['notes'].toString()}',
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontFamily: 'noto_regular')),
                          ),
                          SizedBox(height: 15),
                          Stack(children: [
                            Container(
                              alignment: Alignment.center,
                              width: screen,
                              height: screen * 0.50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GoogleMap(
                                  scrollGesturesEnabled: true,
                                  onTap: (pos)async {
                                    if(Platform.isIOS){
                                      //  String url ='https://www.google.com/maps/dir/?api=1&destination=${dataaddress[0]['latitiude'].toString()},${dataaddress[0]['longtiude'].toString()}';
                                       String url ='comgooglemaps://?saddr=&daddr=${dataaddress[0]['latitiude'].toString()},${dataaddress[0]['longtiude'].toString()}&directionsmode=driving';
                        // String googleUrl =
                        //     'https://www.google.com/maps/search/?api=1&query=${widget.data['attributes']['latitiude_id'].toString()},${widget.data['attributes']['longitude_id'].toString()}';
                                 await launchUrl(Uri.parse(url));
                                    }else{
                                        MapsLauncher.launchCoordinates(
                            double.parse(dataaddress[0]['latitiude']
                                              .toString()),
                            double.parse(dataaddress[0]
                                                  ['longtiude']
                                              .toString()),
                            'ທີ່ຢູ່ລູກຄ້າ');
                                    }
                                  
                                  },
                                  markers: {markers},
                                  mapType: statemaps == false
                                      ? MapType.normal
                                      : MapType.hybrid,
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          double.parse(dataaddress[0]
                                                  ['latitiude']
                                              .toString()),
                                          double.parse(dataaddress[0]
                                                  ['longtiude']
                                              .toString())),
                                      zoom: 16),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                ),
                              ),
                            ),
                          ]),
                        ])),
            SizedBox(height: 20),
            isLoadingimage == true
                ? Text('')
                : Row(
                    children: [
                      Text('ຮູບພາບເພີ່ມເຕີມ',
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontFamily: 'noto_bold'))
                    ],
                  ),
            SizedBox(height: 15),
            isLoadingimage == true
                ? Padding(
                    padding: const EdgeInsets.only(),
                    child: Center(
                      child: Column(
                        children: [
                          // CircularProgressIndicator(),
                          // SizedBox(height: 10),
                          // Text('ກຳລັງໂຫຼດ',
                          //     style: TextStyle(
                          //         color: Color(0xFF293275),
                          //         fontSize: 17,
                          //         fontFamily: 'noto_me')),
                        ],
                      ),
                    ),
                  )
                :dataimageuser.isEmpty  ? Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Center(child:  Text('ຍັງບໍ່ມີຮູບພາບ',
                            style: TextStyle(
                                color: Color(0xFF293275),
                                fontSize: 16,
                                fontFamily: 'noto_bold')),),
                ) : Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          width: screen,
                          height: screen * 1,
                          child: GridView(
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 14,
                                      mainAxisSpacing: 14),
                              children:  List.generate(
                                dataimageuser.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (lono) =>
                                                GalleryImageProfile(
                                                    image: dataimageuser[index]
                                                            ['image']
                                                        .toString())));
                                  },
                                  child: Container(
                                    width: screen,
                                    //height: 150,
                                    // margin: EdgeInsets.only(
                                    //     bottom: 10, right: 15),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          fadeOutDuration:
                                              Duration(milliseconds: 100),
                                          fadeInDuration:
                                              Duration(milliseconds: 100),
                                          imageUrl: dataimageuser[index]
                                                  ['image']
                                              .toString(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Center(child: CupertinoActivityIndicator(radius: 15,color: Colors.grey,)),
                                        )),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      )),
    );
  }

  districtName(District district) => district.districtName.toString();
  sataetName(State1 state) => state.stateName.toString();
  divisiontName(Division division) => division.divisionName.toString();
}
