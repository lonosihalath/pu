import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/district/model.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/division/model.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/address/state/model.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/staff/detail_user2.dart';
import 'package:purer/staff/staff_add_user/controller-user/controller.dart';
import 'package:purer/staff/staff_add_user/controller-user/model.dart';
import 'package:purer/staff/staff_add_user/profile_photo.dart';
import 'package:purer/staff/staff_add_user/viewmap.dart';
import 'package:purer/widgets/vilage_all.dart';

import '../../screen/signin_signup/stafflogin/controller_staff.dart';

class StaffUptateData extends StatefulWidget {
  final UserAll userAll;
  final dataimage;
  final state;
  final district;
  final division;
  final lat;
  final long;
  final idaddress;
  //final notes;
  StaffUptateData({
    Key? key,
    required this.userAll,
    required this.district,
    required this.state,
    required this.division,
    required this.lat,
    required this.long,
    required this.idaddress,
    required this.dataimage
    //required this.notes
  }) : super(key: key);

  @override
  State<StaffUptateData> createState() => _StaffUptateDataState();
}

class _StaffUptateDataState extends State<StaffUptateData> {
  late Marker markers;
  @override
  void initState() {
    List.generate(widget.dataimage.length, (index) => image.add(widget.dataimage[index]['image']));
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
    setState(() {
      currentSelectedValuedistrict = widget.district;
      currentSelectedValueprovince = widget.division;
      currentSelectedValuevillage = widget.state.toString();
      nane.text = widget.userAll.name.toString();
      surname.text = widget.userAll.surname.toString();
      phone.text = widget.userAll.phone.toString();
      currentSelectedValueuser = widget.userAll.type.toString();
      email.text = widget.userAll.email.toString();
    });
    
   // print(widget.dataimage[0]['image'].toString());
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

  TextEditingController nane = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  StateController stateController = Get.put(StateController());
  DistrictController districtController = Get.put(DistrictController());
  DivisionController divisionController = Get.put(DivisionController());
  UserAllController userAllController= Get.put(UserAllController());
  final staffcontroller = Get.put(StaffController());

  List<String> deviceTypesuser = [
    'ບຸກຄົນ',
    'ອົງກອນ',
  ];
  var currentSelectedValueuser;

  var currentSelectedValueprovince;
  var currentSelectedValuedistrict;
  var currentSelectedValuevillage;

  var iddistrict;
  var idstate;
  var idprovince;

  updateuser() async {
    print('null!!!!');
    var data = {
      "name": nane.text.toString(),
      "surname": surname.text.toString(),
      "type": currentSelectedValueuser.toString(),
      "email": email.text.toString(),
      "phone": phone.text.toString(),
      "profile": urlImag1.isEmpty
          ? widget.userAll.profile.toString()
          : urlImag1.toString(),
    };
    var res = await CallApi().postDataupDate(data, widget.userAll.id.toString(),
        '${staffcontroller.items.values.toList()[0].token}');
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      userAllController.onInit();
      update();
    }
  }

  update() async {
    print('null!!!!');
    var data = {
      "division_id": idprovince.toString(),
      "district_id": iddistrict.toString(),
      "state_id": idstate.toString(),
      "latitiude": lat.toString(),
      "longtiude": long.toString(),
      //"notes": note.text.length.toInt() == 0 ? '' : note.text,
    };
    var res = await CallApi().postDataupDateAddress(
        data,
        widget.idaddress.toString(),
        staffcontroller.items.values.toList()[0].token);
    var body = json.decode(res.body);
    if (res.statusCode == 201) {
      //Navigator.pop(context);
      print('statusCode====>' + res.statusCode.toString());
        Navigator.pop(context);
        Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (lono)=> StaffDetailUser2(userAll: userAllController.statetList.where((p0) => p0.id.toString()== widget.userAll.id.toString()).first)));
    }
    print(res.statusCode);
    print(body);
    print('statusCode====>' + res.statusCode.toString());
  }

  List image = [];
  List imageinsert = [];
  XFile? _image;
  UploadTask? uploadTask;
  late String urlImag = '';
  late String urlImag1 = '';
  // List<XFile>? _image1;
  ImagePicker? picker = ImagePicker();
  Future getimageuser() async {
    final XFile? pickedFile = await picker!.pickImage(
      source: ImageSource.camera,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    setState(() {
      _image = pickedFile!;
    });
    profileUser1();
    //profileUser1();
    //_updateDataImage(token);
    //Get.to(Edit_account());
  }

  Future getimageuser1() async {
    final XFile? pickedFile = await picker!.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    setState(() {
      _image = pickedFile!;
    });
    profileUser1();
    //profileUser1();
    //_updateDataImage(token);
    //Get.to(Edit_account());
  }

  Future getimage() async {
    final XFile? pickedFile = await picker!.pickImage(
      source: ImageSource.camera,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    setState(() {
      _image = pickedFile!;
    });
    profileUser();
    //profileUser1();
    //_updateDataImage(token);
    //Get.to(Edit_account());
  }

  Future getimage1() async {
    final XFile? pickedFile = await picker!.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    setState(() {
      _image = pickedFile!;
    });
    profileUser();
    //profileUser1();
    //_updateDataImage(token);
    //Get.to(Edit_account());
  }

  Future profileUser() async {
    showDialog(
        barrierDismissible: false, context: context, builder: (_) => dialog3());
    final path = 'profile/Purer-${_image!.name}';
    final file = File(_image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlImage = await snapshot.ref.getDownloadURL();
    setState(() {
      urlImag = urlImage;
      image.add(urlImag);
      imageinsert.add(urlImag);
    });
    Navigator.pop(context);
    print('Linkkkkkkkkkkk: ' + urlImag);
  }

  Future profileUser1() async {
    showDialog(
        barrierDismissible: false, context: context, builder: (_) => dialog3());
    final path = 'profile/Purer-${_image!.name}';
    final file = File(_image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlImage = await snapshot.ref.getDownloadURL();
    setState(() {
      urlImag1 = urlImage;
      //image.add(urlImag1);
    });
    Navigator.pop(context);
    print('Linkkkkkkkkkkk: ' + urlImage);
  }

  insertimageAll() {
    List.generate(imageinsert.length, (index) => insertimage(index));
  }

  insertimage(index) async {
    var data = {
      "image": imageinsert[index].toString(),
      "user_id": widget.userAll.id.toString(),
    };

    var res = await CallApi().postDataOrder(data, 'user/image',
        '${staffcontroller.items.values.toList()[0].token}');
    var dataorder = json.decode(res.body);
    print(dataorder);
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );
      //////////////////////////////////////////
      //////////////////////////////////////////
    List dataimageuser = [];
    bool isLoadingimage = true;
    

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
        title: const Text('ແກ້ໄຂຂໍ້ມູນ',
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
                child: const Text('ຢືນຢັນການແກ້ໄຂ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (lono) => dialog3());
                  updateuser();
                  insertimageAll();
                },
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ຂໍ້ມູນລູກຄ້າ',
                style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 16,
                    fontFamily: 'noto_bold')),
            SizedBox(height: 15),
            urlImag1.isEmpty
                ? GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => photo(context));
                      //   showDialog(
                      // //useSafeArea: false,
                      //     context: context, builder: (context) => AlertDialog(

                      //     //insetPadding: EdgeInsets.symmetric(horizontal: 0),
                      //        titlePadding: EdgeInsets.only(top: 0, left:0, right: 0),
                      //        contentPadding: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      //     backgroundColor: Colors.white,
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      //     content: Container(
                      //       width: 350,
                      //       height: 200,
                      //       child: Column(
                      //         children: [
                      //           Container(
                      //             alignment: Alignment.center,
                      //             width: screen,
                      //             height: 45,
                      //             decoration: BoxDecoration(
                      //               color: Color(0xFF293275),
                      //               borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
                      //             child: Text('ເລືອກຮູບພາບຈາກກ້ອງຖ່າຍຮູບ ຫຼື ຄັລງຮູບພາບ',style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 15,
                      //       fontFamily: 'noto_me')),
                      //           ),
                      //           Row(
                      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               Container(
                      //                 margin: EdgeInsets.only(left: 10,top: 25),
                      //                 width: 140,
                      //                 height: 45,
                      //                 child: ElevatedButton(
                      //                   child: Row(
                      //                   children: [
                      //                     Icon(Icons.photo_camera,size: 25,),
                      //                     SizedBox(width: 10),
                      //                     Text('ກ້ອງຖ່າຍຮູບ',style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 14,
                      //       fontFamily: 'noto_regular')),
                      //                   ],
                      //                 ),onPressed: (){},),
                      //               ),
                      //               Container(
                      //                 margin: EdgeInsets.only(right: 10,top: 25),
                      //                 width: 140,
                      //                 height: 45,
                      //                 child: ElevatedButton(child: Row(
                      //                   children: [
                      //                     Icon(Icons.photo_album,size: 25,),
                      //                     SizedBox(width: 10),
                      //                     Text('ຄັລງຮູບພາບ',style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 14,
                      //       fontFamily: 'noto_regular')),
                      //                   ],
                      //                 ),onPressed: (){},),
                      //               ),
                      //             ],
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   ));
                    },
                    child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                              widget.userAll.profile.toString(),
                              fit: BoxFit.cover,
                            ))),
                  )
                : GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => photo(context));
                    },
                    child: Container(
                        width: 90,
                        height: 90,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.network(
                              urlImag1.toString(),
                              fit: BoxFit.cover,
                            ))),
                  ),
            SizedBox(height: 25),
            Container(
              height: 50,
              width: screen * 1,
              // decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 1,),borderRadius: BorderRadius.circular(10.0),),
              child: TextFormField(
                  //focusNode: focusNode,
                  onChanged: ((value) {}),
                  keyboardType: TextInputType.name,
                  controller: nane,
                  style: TextStyle(fontSize: 15, fontFamily: 'branding4'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    label: Text('ຊື່',
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
            Container(
              height: 50,
              width: screen * 1,
              // decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 1,),borderRadius: BorderRadius.circular(10.0),),
              child: TextFormField(
                  //focusNode: focusNode,
                  onChanged: ((value) {}),
                  keyboardType: TextInputType.name,
                  controller: surname,
                  style: TextStyle(fontSize: 15, fontFamily: 'branding4'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    label: Text('ນາມສະກຸນ',
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
            Container(
              height: 50,
              width: screen * 1,
              // decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 1,),borderRadius: BorderRadius.circular(10.0),),
              child: TextFormField(
                  //focusNode: focusNode,
                  onChanged: ((value) {}),
                  keyboardType: TextInputType.name,
                  controller: email,
                  style: TextStyle(fontSize: 15, fontFamily: 'branding4'),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    label: Text('ອີເມວ',
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
            selectType(screen),
            SizedBox(height: 13),
            Container(
                height: 70,
                width: screen * 1,
                child: TextFormField(
                    //focusNode: focusNode,
                    onChanged: ((value) {}),
                    keyboardType: TextInputType.number,
                    maxLength: 14,
                    controller: phone,
                    style: TextStyle(fontSize: 15, fontFamily: 'branding4'),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      label: Container(
                        width: 250,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'icons/laos.png',
                              width: 30,
                            ),
                            SizedBox(width: 5),
                            Padding(
                                padding: EdgeInsets.only(),
                                child: Container(
                                    child: Text('+85620 ເບີໂທລະສັບ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontFamily: 'noto_regular')))),
                          ],
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))),
            SizedBox(height: 15),
            Text('ຂໍ້ມູນທີ່ຢູ່',
                style: TextStyle(
                    color: Color(0xFF5D5D5D),
                    fontSize: 16,
                    fontFamily: 'noto_bold')),
            SizedBox(height: 15),
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: screen,
                  height: screen * 0.50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GoogleMap(
                      scrollGesturesEnabled: true,
                      onTap: (pos) {
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewMap(
                                      data: widget.userAll,
                                      district: currentSelectedValuedistrict,
                                      state: currentSelectedValuevillage,
                                      division: currentSelectedValueprovince,
                                      lat: lat,
                                      long: long,
                                      id: widget.idaddress,
                                      dataimage: widget.dataimage,
                                    )));
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
            ),
            SizedBox(height: 15),
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
                Text('ເເຂວງ',
                    style: TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 15,
                        fontFamily: 'noto_regular')),
              ],
            ),
            SizedBox(height: 5),
            selectprovince(),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ຂໍ້ມູນຮູບພາບ',
                    style: TextStyle(
                        color: Color(0xFF5D5D5D),
                        fontSize: 16,
                        fontFamily: 'noto_bold')),
                TextButton(onPressed: (){
                   showCupertinoModalPopup(
                          context: context,
                          builder: (context) => photo1(context));
                }, child: Text(' + ເພີ່ມຮູບພາບ',style: TextStyle(fontFamily: 'noto_bold',fontSize: 15),))
              ],
            ),
            SizedBox(height: 40),
       
            Container( width: width,
                                  height: width,
                                  child: GridView(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 14,
                                            mainAxisSpacing: 14
                                            ),
                                    children: List.generate(
                                        image.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (lono) =>
                                                            GalleryImageProfile(
                                                                image: image[index].toString())));
                                              },
                                              child: Container(
                                                width: width,
                                                //height: 150,
                                                // margin: EdgeInsets.only(
                                                //     bottom: 10, right: 15),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child:CachedNetworkImage(
                              fadeOutDuration: Duration(milliseconds: 100),
                              fadeInDuration: Duration(milliseconds: 100),
                              imageUrl: image[index].toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Padding(
                                    padding: const EdgeInsets.all(80.0),
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(),
                                          color: Colors.white),
                                    ),
                                  )
                                                  //  Image.network(
                                                  //   image[index]
                                                            
                                                  //       .toString(),
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ),
                                            )),
                                  ),
                                ),
            SizedBox(height: 20),
            // Container(
            //   margin: EdgeInsets.only(bottom: 18),
            //   height: 60,
            //   child: Container(
            //     margin: EdgeInsets.only(top: 10),
            //     width: screen,
            //     height: 50,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(10),
            //       child: ElevatedButton(
            //         style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
            //         child: const Text('ເພີ່ມຮູບພາບ',
            //             style: TextStyle(
            //                 fontSize: 15,
            //                 color: Color(0xFFFFFFFF),
            //                 fontFamily: 'noto_me')),
            //         onPressed: () {
            //           showCupertinoModalPopup(
            //               context: context,
            //               builder: (context) => photo1(context));
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      )),
    );
  }

  districtName(District district) => district.districtName.toString();
  sataetName(State1 state) => state.stateName.toString();
  divisiontName(Division division) => division.divisionName.toString();

  CupertinoActionSheet photo(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('ເລືອກຮູບພາບ'),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              getimageuser();
            },
            child: Text('ກ້ອງຖ່າຍຮຸບ')),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              getimageuser1();
            },
            child: Text('ຄລັງຮູບພາບ'))
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('ຍົກເລີກ'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  CupertinoActionSheet photo1(BuildContext context) {
    return CupertinoActionSheet(
      title: Text('ເລືອກຮູບພາບ'),
      actions: [
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              getimage();
            },
            child: Text('ກ້ອງຖ່າຍຮຸບ')),
        CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              getimage1();
            },
            child: Text('ຄລັງຮູບພາບ'))
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('ຍົກເລີກ'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Container selectType(screen) {
    return Container(
      height: 50,
      width: screen * 1,
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
                  hint: Text('ເລືອກປະເພດລູກຄ້າ',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontFamily: 'noto_regular')),
                  value: currentSelectedValueuser,
                  isDense: true,
                  onChanged: (newValue) {
                    setState(() {
                      currentSelectedValueuser = newValue;
                    });
                    print(currentSelectedValueuser);
                  },
                  items: deviceTypesuser.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontFamily: 'noto_regular')),
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
                  hint: Text(
                      currentSelectedValuedistrict.toString() == 'ໄຊທານີ'
                          ? village7[0]
                          : currentSelectedValuedistrict.toString() ==
                                  'ໄຊເສດຖາ '
                              ? village6[0]
                              : currentSelectedValuedistrict.toString() ==
                                      'ສີສັດຕະນາກ '
                                  ? village5[0]
                                  : currentSelectedValuedistrict.toString() ==
                                          'ຈັນທະບູລີ'
                                      ? village1[0]
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              'ຫາດຊາຍຟອງ'
                                          ? village2[0]
                                          : currentSelectedValuedistrict
                                                      .toString() ==
                                                  'ສີໂຄດຕະບອງ '
                                              ? village4[0]
                                              : currentSelectedValuedistrict
                                                          .toString() ==
                                                      'ນາຊາຍທອງ'
                                                  ? village3[0]
                                                  : '',
                      style: TextStyle(fontFamily: 'noto_regular')),
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
                            child: Text(value,
                                style: TextStyle(fontFamily: 'noto_regular')),
                          );
                        }).toList()
                      : currentSelectedValuedistrict.toString() == 'ໄຊເສດຖາ '
                          ? village6.map((String value1) {
                              return DropdownMenuItem<String>(
                                value: value1,
                                child: Text(value1,
                                    style:
                                        TextStyle(fontFamily: 'noto_regular')),
                              );
                            }).toList()
                          : currentSelectedValuedistrict.toString() ==
                                  'ສີສັດຕະນາກ '
                              ? village5.map((String value1) {
                                  return DropdownMenuItem<String>(
                                    value: value1,
                                    child: Text(value1,
                                        style: TextStyle(
                                            fontFamily: 'noto_regular')),
                                  );
                                }).toList()
                              : currentSelectedValuedistrict.toString() ==
                                      'ຈັນທະບູລີ'
                                  ? village1.map((String value1) {
                                      return DropdownMenuItem<String>(
                                        value: value1,
                                        child: Text(value1,
                                            style: TextStyle(
                                                fontFamily: 'noto_regular')),
                                      );
                                    }).toList()
                                  : currentSelectedValuedistrict.toString() ==
                                          'ຫາດຊາຍຟອງ'
                                      ? village2.map((String value1) {
                                          return DropdownMenuItem<String>(
                                            value: value1,
                                            child: Text(value1,
                                                style: TextStyle(
                                                    fontFamily:
                                                        'noto_regular')),
                                          );
                                        }).toList()
                                      : currentSelectedValuedistrict
                                                  .toString() ==
                                              'ສີໂຄດຕະບອງ '
                                          ? village4.map((String value1) {
                                              return DropdownMenuItem<String>(
                                                value: value1,
                                                child: Text(value1,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'noto_regular')),
                                              );
                                            }).toList()
                                          : currentSelectedValuedistrict
                                                      .toString() ==
                                                  'ນາຊາຍທອງ'
                                              ? village3.map((String value1) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value1,
                                                    child: Text(value1,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'noto_regular')),
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
                      child: Text(value,
                          style: TextStyle(fontFamily: 'noto_regular')),
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
                      child: Text(value,
                          style: TextStyle(fontFamily: 'noto_regular')),
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
