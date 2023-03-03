import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/staff/staff_api/order_api/controler.dart';
import 'package:purer/staff/staff_detail_order_normal.dart';
import 'package:purer/staff/staff_detail_order_regular.dart';

class StaffMaps extends StatefulWidget {
  final dataorder;
  const StaffMaps({Key? key, required this.dataorder}) : super(key: key);

  @override
  State<StaffMaps> createState() => _StaffMapsState();
}

class _StaffMapsState extends State<StaffMaps> {
   StaffController staffController = Get.put(StaffController());
  Completer<GoogleMapController> _controller = Completer();
  StaffOrderController staffOrderController = Get.put(StaffOrderController());
  late final List<Marker> marker = [
    Marker(
      markerId: MarkerId('001'),
      position: LatLng(lat, long),
    ),
  ];
  late final List<Marker> _list = List.generate(
    widget.dataorder.length,
    (index) => Marker(
        markerId:
            MarkerId(widget.dataorder[index]['id'].toString()),
        position: LatLng(
            double.parse(
                widget.dataorder[0]['attributes']['latitiude_id'].toString()),
            double.parse(widget.dataorder[0]['attributes']['longitude_id'].toString())),
        onTap: () {
          if (staffController
                                                                            .items
                                                                            .values
                                                                            .toList()[0]
                                                                            .name
                                                                            .toString() !=
                                                                        "ກນ 1648") {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => StaffDetailOrder(
                                                                                    data:widget.dataorder[index],
                                                                                  )));
                                                                    } else {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => StaffDetailOrderNormal(
                                                                                    data: widget.dataorder[index],
                                                                                  )));
                                                                    }
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (lono) => StaffDetailOrder(
          //               data: widget.dataorder[index],
          //             )));
        }),
  );
  bool state = false;
  getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      state = true;
      lat = position.latitude;
      long = position.longitude;
      //createMarker(context);
      _list.add(
        Marker(
            markerId: MarkerId('000001'),
            position: LatLng(lat, long),
            icon: customIcon,
            infoWindow: InfoWindow(title: 'My location')),
      );
    });
  }

  addMarkers() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "icons/ll.png",
    );
    setState(() {
      customIcon = markerbitmap;
    });
  }

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

  double lat = 0.0;
  double long = 0.0;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    print(widget.dataorder[0]['attributes']['latitiude_id'].toString());
    print(widget.dataorder[0]['attributes']['longitude_id'].toString());
    addMarkers();
    //createMarker(context);
    getCurrentLocation();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getCurrentLocation();
    });

    //marker.addAll(_list);
  }

  bool statusmap = false;

  @override
  Widget build(BuildContext context) {
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
                timer!.cancel();
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StaffDetailOrder(lat: 0.0, long: 0.0,stafforder: ,)));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff717171),
              )),
        ),
        title: const Text('ແຜນທີ່ທັງໝົດ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      statusmap = !statusmap;
                    });
                  },
                  icon: Icon(
                    Icons.layers,
                    color: Colors.blue,
                    size: 30,
                  )))
        ],
      ),
      body: state == false
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              markers: Set<Marker>.of(_list),
              mapType: statusmap == false ? MapType.normal : MapType.hybrid,
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat, long), zoom: 16),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
