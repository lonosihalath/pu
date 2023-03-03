import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/district/model.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/division/model.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/address/state/model.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../screen/signin_signup/stafflogin/controller_staff.dart';

class Historydetail extends StatefulWidget {
  final data;
  const Historydetail({Key? key, required this.data}) : super(key: key);

  @override
  State<Historydetail> createState() => _HistorydetailState();
}

class _HistorydetailState extends State<Historydetail> {
  @override
  void initState() {
    super.initState();
    markers = Marker(
      markerId: MarkerId('1'),
      position: LatLng(
          double.parse(widget.data['attributes']['latitiude_id'].toString()),
          double.parse(widget.data['attributes']['longitude_id'].toString())),
      infoWindow: InfoWindow(
          title: 'ທີ່ຢູ່ຂອງລູກຄ້າ',
          onTap: () {
            print('Tap');
          }),
    );
    userdata();
  }

  List data = [];

  bool isLoading = true;
  final staffcontroller = Get.put(StaffController());

  userdata() async {
    final response = await http.get(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/user/detail/${widget.data['attributes']['user_id'].toString()}'),
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
      data.add(json);
      setState(() {
        isLoading = false;
      });
    }
  }

  DistrictController districtController = Get.put(DistrictController());
  StateController stateController = Get.put(StateController());
  DivisionController divisionController = Get.put(DivisionController());
  Completer<GoogleMapController> _controller = Completer();

  late Marker markers;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;
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
        title: const Text('ລາຍລະອຽດ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ລາຍການສິນຄ້າ',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 17,
                    fontFamily: 'noto_semi')),
            SizedBox(height: 10),
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xFFE5EFF9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(35)),
                            child: Image.asset(widget.data['attributes']
                                    ['order_item'][0]['attributes']['image']
                                .toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    widget.data['attributes']['order_item'][0]
                                            ['attributes']['product_name']
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF293275),
                                        fontSize: 14,
                                        fontFamily: 'noto_semi')),
                                Text(
                                    widget.data['attributes']['order_item'][0]
                                            ['attributes']['size']
                                        .toString(),
                                    style: TextStyle(
                                        color: Color(0xFF293275),
                                        fontSize: 12,
                                        fontFamily: 'noto_semi')),
                                Text(
                                    'ຈຳນວນ: ' +
                                        widget.data['attributes']['order_item']
                                                [0]['attributes']['amount']
                                            .toString() +
                                        ' ຕຸກ',
                                    style: TextStyle(
                                        color: Color(0xFF293275),
                                        fontSize: 12,
                                        fontFamily: 'noto_semi')),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 20,
                  child: Text(
                      'ລາຄາ: ' +
                          nFormat(int.parse(widget.data['attributes']
                                  ['order_item'][0]['attributes']
                                  ['total_amount']
                              .toString())) +
                          ' ກີບ',
                      style: TextStyle(
                          color: Color(0xFF293275),
                          fontSize: 15,
                          fontFamily: 'noto_semi')),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('ຂໍ້ມູນລູກຄ້າ',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 17,
                    fontFamily: 'noto_semi')),
            SizedBox(height: 10),
            isLoading == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    width: width,
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.network(
                                data[0]['profile'].toString(),
                                fit: BoxFit.cover,
                              )),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                          data[0]['user_id'].toString()=='null'?SizedBox():  Text('ໄອດີ:   ' + data[0]['user_id'].toString(),
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontFamily: 'noto_regular'))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                                'ຊື່ ແລະ ນາມສະກຸນ:   ' +
                                    data[0]['name'].toString() +
                                    '  ' +
                                    data[0]['surname'].toString(),
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontFamily: 'noto_regular'))
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                String googleUrl =
                                    'whatsapp://send?phone=${data[0]['phone'].toString()}&text=ສະບາຍດີ';
                                await launchUrl(Uri.parse(googleUrl));
                              },
                              child: Text(
                                  'ໂທລະສັບ:   ' +
                                      data[0]['phone'].toString() +
                                      '    ',
                                  style: TextStyle(
                                      color: Color(0xFF293275),
                                      fontSize: 16,
                                      fontFamily: 'noto_regular')),
                            ),
                            GestureDetector(
                              onTap: () async {
                                String googleUrl =
                                    'whatsapp://send?phone=${data[0]['phone'].toString()}&text=ສະບາຍດີ';
                                await launchUrl(Uri.parse(googleUrl));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Image.asset('icons/wa.png'),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                           data[0]['email'].toString()=='null' ?SizedBox(): Text('ອີເມວ:   ' + data[0]['email'].toString(),
                                style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                    fontFamily: 'noto_regular'))
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                            width: width * 0.75,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'ທີ່ຢູ່:   ' +
                                          widget.data['attributes']['state_id']
                                              .toString() +
                                          ', ' +
                                          widget.data['attributes']
                                                  ['district_id']
                                              .toString() +
                                          ', ' +
                                          widget.data['attributes']
                                                  ['division_id']
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 16,
                                          fontFamily: 'noto_regular'))
                                ])),
                        SizedBox(height: 5),
                        Row(children: [
                         widget.data['attributes']['notes'].toString()=='null'?SizedBox(): Text(
                              'ໝາຍເຫດ: ' +
                                  '${widget.data['attributes']['notes'].toString()}',
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_regular'))
                        ]),
                      ],
                    ),
                  ),
            SizedBox(height: 20),
            Text('ເສັ້ນທາງ',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 17,
                    fontFamily: 'noto_semi')),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              width: width,
              height: heigth * 0.30,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    // onTap: (pos) {
                    //   lat = pos.latitude;
                    //   long = pos.longitude;
                    //   setState(() {
                    //     markers = Marker(
                    //       markerId: MarkerId('1'),
                    //       position: pos,
                    //     );
                    //   });
                    // },
                    markers: {markers},
                    mapType: MapType.normal,

                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                            double.parse(widget.data['attributes']
                                    ['latitiude_id']
                                .toString()),
                            double.parse(widget.data['attributes']
                                    ['longitude_id']
                                .toString())),
                        zoom: 16),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 50,
              child: Container(
                width: width,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 14,
                          child: Container(
                              width: 5,
                              child: Image.asset(
                                'icons/location.png',
                                color: Colors.white,
                              )),
                        ),
                        SizedBox(width: 15),
                        const Text('ເປີດແຜນທີ່ນຳທາງ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'noto_me')),
                      ],
                    ),
                    onPressed: () async {
                      if(Platform.isIOS){
                         //String url ='https://www.google.com/maps/dir/?api=1&destination=${widget.data['attributes']['latitiude_id']},${widget.data['attributes']['longitude_id']}';
                          String url ='comgooglemaps://?saddr=&daddr=${widget.data['attributes']['latitiude_id'].toString()},${widget.data['attributes']['longitude_id'].toString()}&directionsmode=driving';

                        // String googleUrl =
                        //     'https://www.google.com/maps/search/?api=1&query=${widget.data['attributes']['latitiude_id'].toString()},${widget.data['attributes']['longitude_id'].toString()}';
                        await launchUrl(Uri.parse(url));
                      }else{
                         MapsLauncher.launchCoordinates(
                          double.parse(widget.data['attributes']['latitiude_id']
                              .toString()),
                          double.parse(widget.data['attributes']['longitude_id']
                              .toString()),
                          'ທີ່ຢູ່ລູກຄ້າ');
                      }
                     
                      // String googleUrl =
                      //     'https://www.google.com/maps/search/?api=1&query=${widget.data['attributes']['latitiude_id'].toString()},${widget.data['attributes']['longitude_id'].toString()}';
                      // await launchUrl(Uri.parse(googleUrl));
                      // _Updateaddroder();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  districtName(District district) => district.districtName.toString();
  sataetName(State1 state) => state.stateName.toString();
  divisiontName(Division division) => division.divisionName.toString();
}
