import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purer/staff/staff_add_user/updatedata_user.dart';

class ViewMap extends StatefulWidget {
  final data;
  final state;
  final district;
  final division;
  final lat;
  final long;
  final id;
  final dataimage;
  const ViewMap(
      {Key? key,
      required this.data,
      required this.district,
      required this.state,
      required this.division,
      required this.lat,
      required this.long,
      required this.dataimage,
      required this.id})
      : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  late Marker markers;
  @override
  void initState() {
    //print('object::::'+widget.data.toString());
    super.initState();
    markers = Marker(
      markerId: MarkerId('1'),
      position: LatLng(double.parse(widget.lat.toString()),
          double.parse(widget.long.toString())),
      infoWindow: InfoWindow(
          title: 'ທີ່ຢູ່ຂອງລູກຄ້າ',
          onTap: () {
            print('Tap');
          }),
    );
  }

  Completer<GoogleMapController> _controller = Completer();
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

  bool state = false;
   bool statemaps = false;
  late double lat = double.parse(widget.lat.toString());
  late double long = double.parse(widget.long.toString());
  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Location',
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
                child: const Text('ຢືນຢັນການແກ້ໄຂ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StaffUptateData(
                                userAll: widget.data,
                                district: widget.district,
                                state: widget.state,
                                division: widget.division,
                                lat: lat,
                                long: long,
                                idaddress: widget.id,
                                dataimage: widget.dataimage,
                              )));

                  // showDialog(
                  //     barrierDismissible: false,
                  //     context: context,
                  //     builder: (lono) => dialog3());
                  // updateuser();
                  // insertimageAll();
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
            //padding: EdgeInsets.only(left: 24, right: 24),
            alignment: Alignment.center,
            width: screen,
            height: screen1 * 0.75,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GoogleMap(
                  scrollGesturesEnabled: true,
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
                  initialCameraPosition:
                      CameraPosition(target: LatLng(lat, long), zoom: 16),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
          ),
           Positioned(
                right: 35,
                top: 15,
                child: Container(
                  width:50,
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
          )
        ],
      ),
    );
  }
}
