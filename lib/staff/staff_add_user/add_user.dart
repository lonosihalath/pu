import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purer/staff/staff_add_user/add_user_address.dart';

class StaffAdduser extends StatefulWidget {
  const StaffAdduser({Key? key}) : super(key: key);

  @override
  State<StaffAdduser> createState() => _StaffAdduserState();
}

class _StaffAdduserState extends State<StaffAdduser> {
  TextEditingController phone = TextEditingController();

  bool checkPhone = false;
  bool checkPhone1 = false;

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color(0xFFE5EFF6),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: screen,
                  height: screen1,
                ),
                Positioned(
                    top: 50,
                    left: 15,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xff717171),
                        ))),
                Positioned(
                    left: screen * 0.72,
                    child: Container(
                      width: screen * 0.50,
                      height: screen * 0.50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screen * 0.25),
                          color: Color(0xFF98caff)),
                    )),
                Positioned(
                    bottom: 20,
                    right: screen * 0.60,
                    child: Container(
                      width: screen * 0.65,
                      height: screen1 * 0.52,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(screen * 0.55),
                              bottomRight: Radius.circular(screen * 0.55)),
                          color: Color(0xFF98caff)),
                    )),
                Positioned(
                  right: screen * 0.05,
                  child: Column(
                    children: [
                      SizedBox(height: 180),
                      Container(
                          width: 138,
                          height: 138,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              color: Color(0xFF98caff)),
                          child: Image.asset('icons/logo.png')),
                      SizedBox(height: 20),
                      const Text('ສ້າງບັນຊີລູກຄ້າ',
                          style: TextStyle(
                              color: Color(0xFF5D5D5D),
                              fontSize: 15,
                              fontFamily: 'noto_regular')),
                      SizedBox(height: 30),
                      Container(
                        height: 70,
                        width: screen * 0.90,
                        child: TextFormField(
                            //focusNode: focusNode,
                            onChanged: ((value) {}),
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            controller: phone,
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'branding4'),
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
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              label: Container(
                                width: 200,
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
                                            child: Text('+85620 ປ້ອນເບີໂທລະສັບ',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontFamily:
                                                        'noto_regular')))),
                                  ],
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                      checkPhone == true
                          ? Container(
                              width: screen * 0.90,
                              margin: EdgeInsets.only(),
                              child: Row(
                                children: [
                                  Text('ກະລຸນາປ້ອນເບີໂທລະສັບ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            )
                          : checkPhone1 == true
                              ? Container(
                                  width: screen * 0.90,
                                  margin: EdgeInsets.only(),
                                  child: Row(
                                    children: [
                                      Text('ກະລຸນາປ້ອນເບີໂທລະສັບໃຫ້ຄົບ 8 ໂຕ',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.red,
                                              fontFamily: 'noto_regular')),
                                    ],
                                  ),
                                )
                              : SizedBox()
                    ],
                  ),
                ),
                Positioned(
                  right: screen * 0.05,
                  bottom: 20,
                  child: Container(
                    width: screen * 0.90,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF293275)),
                        child: Text('ຢືນຢັນ',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'noto_me')),
                        onPressed: () {
                          if (phone.text.isEmpty) {
                            setState(() {
                              checkPhone = true;
                            });
                          } else {
                            setState(() {
                              checkPhone = false;
                            });
                            if (phone.text.length < 8) {
                              setState(() {
                                checkPhone1 = true;
                              });
                            } else {
                              checkPhone1 = false;
                              checkPhone = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StaffAddNameSurname()));
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )));
  }
}

class StaffAddNameSurname extends StatefulWidget {
  const StaffAddNameSurname({
    Key? key,
  }) : super(key: key);

  @override
  State<StaffAddNameSurname> createState() => _StaffAddNameSurname();
}

class _StaffAddNameSurname extends State<StaffAddNameSurname> {
  bool checkName = false;
  bool checkSurname = false;
  TextEditingController phone = TextEditingController();
  List<String> deviceTypesuser = [
    'ບຸກຄົນ',
    'ອົງກອນ',
  ];
  var currentSelectedValueuser;

  bool checkPhone = false;
  bool checkPhone1 = false;
  bool checkprofile = false;
  bool checkType = false;
  bool checkemail = false;
  bool checkpassword = false;
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  double lat = 0.0;
  double long = 0.0;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  XFile? _image;
  UploadTask? uploadTask;
  late String urlImag = '';
  var imagepath;
  var userToken;
  // List<XFile>? _image1;
  ImagePicker? picker = ImagePicker();
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
    });
    Navigator.pop(context);
    print('Linkkkkkkkkkkk: ' + urlImage);
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );
  bool stutusRedEye1 = true;

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
    extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFFE5EFF6),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading:  IconButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () {
                      Navigator.pop(context);
                     
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      
                      color: Color(0xff717171),
                    )),
        ),
        body: SingleChildScrollView(
            child: Stack(children: [
              Stack(
          children: [
            SingleChildScrollView(
              child: Container(
               // padding: EdgeInsets.only(bottom: 200),
                width: screen,
                height: screen1,
              ),
            ),
            
            Positioned(
                left: screen * 0.72,
                child: Container(
                  width: screen * 0.50,
                  height: screen * 0.50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screen * 0.25),
                      color: Color(0xFF98caff)),
                )),
            Positioned(
                bottom: 20,
                right: screen * 0.60,
                child: Container(
                  width: screen * 0.65,
                  height: screen1 * 0.52,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(screen * 0.55),
                          bottomRight: Radius.circular(screen * 0.55)),
                      color: Color(0xFF98caff)),
                )),
           
            Positioned(
              right: screen * 0.05,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      _image == null
                          ? GestureDetector(
                            onTap: (){
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
                                child: Image.asset('icons/profile.png')),
                          )
                          : GestureDetector(
                            onTap: (){
                               showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => photo(context));
                            },
                            child: Container(
                                width: 90,
                                height: 90,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(45),
                                    child: Image.file(
                                      File(_image!.path),
                                      fit: BoxFit.cover,
                                    ))),
                          ),
                      TextButton(
                          onPressed: () {
                           showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => photo(context));
                          },
                          child: Text(
                              _image == null
                                  ? 'ເພີ່ມຮູບໂປຣໄຟລ໌'
                                  : 'ແກ້ໄຂຮູບໂປຣໄຟລ໌',
                              style: TextStyle(
                                  color: Color(0xFF5D5D5D),
                                  fontSize: 15,
                                  fontFamily: 'noto_regular'))),
                      checkprofile == true
                          ? Container(
                              alignment: Alignment.center,
                              width: screen * 0.90,
                              margin: EdgeInsets.only(),
                              child: Text('ກະລຸນາເພີ່ມຮູບພາບ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontFamily: 'noto_regular')),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                       // SizedBox(height: 10),
                      selectType(screen),
                       checkType == true
                          ? Container(
                              width: screen * 0.90,
                              margin: EdgeInsets.only(top: 5),
                              child: Row(
                                children: [
                                  Text('ກະລຸນາເລືອກປະເພດລູກຄ້າ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screen * 0.90,
                        child: TextFormField(
                            //focusNode: focusNode,
                            onChanged: ((value) {}),
                            keyboardType: TextInputType.name,
                            controller: name,
                            style: const TextStyle(
                                fontSize: 15, fontFamily: 'branding4'),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              label:  Text(currentSelectedValueuser.toString() == 'ອົງກອນ'?'ປ້ອນຊື່ອົງກອນ' :'ປ້ອນຊື່',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'noto_regular')),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                     
                      checkName == true
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
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screen * 0.90,
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
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              label: Text(currentSelectedValueuser.toString() == 'ອົງກອນ'?'ປ້ອນຊື່ອົງກອນເປັນພາສາອັງກິດ' :'ປ້ອນນາມສະກຸນ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'noto_regular')),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                    
                      checkSurname == true
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
                           SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screen * 0.90,
                        child: TextFormField(
                            //focusNode: focusNode,
                            onChanged: ((value) {}),
                            keyboardType: TextInputType.emailAddress,
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
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              label: Text('ປ້ອນອີເມວ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'noto_regular')),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            )),
                      ),
                       checkemail == true
                          ? Container(
                              width: screen * 0.90,
                              margin: EdgeInsets.only(),
                              child: Row(
                                children: [
                                  Text('ກະລຸນາປ້ອນອີເມວ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            )
                          : SizedBox(),
                    
                      SizedBox(height: 10),
                      Container(
                          height: 70,
                          width: screen * 0.90,
                          child: TextFormField(
                              //focusNode: focusNode,
                              onChanged: ((value) {}),
                              keyboardType: TextInputType.number,
                            
                              controller: phone,
                              style:
                                  TextStyle(fontSize: 15, fontFamily: 'branding4'),
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
                                    color: Colors.white,
                                    width: 2.0,
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
                                              child: Text('+85620 ປ້ອນເບີໂທລະສັບ',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontFamily:
                                                          'noto_regular')))),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ))),
                      checkPhone == true
                          ? Container(
                              width: screen * 0.90,
                              margin: EdgeInsets.only(),
                              child: Row(
                                children: [
                                  Text('ກະລຸນາປ້ອນເບີໂທລະສັບ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            )
                          // : checkPhone1 == true
                          //     ? Container(
                          //         width: screen * 0.90,
                          //         margin: EdgeInsets.only(),
                          //         child: Row(
                          //           children: [
                          //             Text('ກະລຸນາປ້ອນເບີໂທລະສັບໃຫ້ຄົບ 8 ໂຕ',
                          //                 style: TextStyle(
                          //                     fontSize: 10,
                          //                     color: Colors.red,
                          //                     fontFamily: 'noto_regular')),
                          //           ],
                          //         ),
                          //       )
                              : SizedBox(),
                              //SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: screen * 0.90,
                        child: TextFormField(
                          obscureText: stutusRedEye1,
                            //focusNode: focusNode,
                            onChanged: ((value) {}),
                            keyboardType: TextInputType.name,
                            controller: password,
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
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              label: Text('ປ້ອນລະຫັດຜ່ານ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'noto_regular')),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                               suffixIcon: IconButton(
                                icon: stutusRedEye1
                                    ? Icon(Icons.visibility_off_outlined)
                                    : Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  setState(() {
                                    stutusRedEye1 = !stutusRedEye1;
                                  });
                                },
                              ),
                            )),
                      ),
                       checkpassword == true
                          ? Container(
                              width: screen * 0.90,
                              margin: EdgeInsets.only(),
                              child: Row(
                                children: [
                                  Text('ກະລຸນາປ້ອນລະຫັດຜ່ານ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontFamily: 'noto_regular')),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            //SizedBox(height: 100,),
            
          ],
        ),
        Positioned(
              right: screen * 0.05,
              bottom: 20,
              child: Container(
                width: screen * 0.90,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                    child: Text('ຢືນຢັນ',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFFFFFFFF),
                            fontFamily: 'noto_me')),
                    onPressed: () {
                      if (email.text.isEmpty &&
                          password.text.isEmpty&& currentSelectedValueuser.toString()=='null') {
                        setState(() {
                          checkemail = true;
                          checkpassword = true;
                          //checkprofile = true;
                          checkType = true;
                        });
                      }
                      if (email.text.isEmpty) {
                        setState(() {
                          checkemail = true;
                        });
                      } else {
                        setState(() {
                          checkemail = false;
                        });
                      }
                      ////////////////////////////////////////////////////////////
                      if (password.text.isEmpty) {
                        setState(() {
                          checkpassword = true;
                        });
                      } else {
                        setState(() {
                          checkpassword = false;
                        });
                      }
                      ////////////////////////////////////////////////////////////
                      // if (phone.text.isEmpty) {
                      //   setState(() {
                      //     checkPhone = true;
                      //   });
                      // } else {
                      //   setState(() {
                      //     checkPhone = false;
                      //   });
                      // }
                      ////////////////////////////////////////////////////////////
                      // if (phone.text.length < 8) {
                      //   setState(() {
                      //     checkPhone1 = true;
                      //   });
                      // } else {
                      //   setState(() {
                      //     checkPhone1 = false;
                      //   });
                      // }
                      // if (urlImag == '') {
                      //   setState(() {
                      //     checkprofile = true;
                      //   });
                      // } else {
                      //   setState(() {
                      //     checkprofile = false;
                      //   });
                      // }
                      if (currentSelectedValueuser.toString()=='null') {
                        setState(() {
                          checkType = true;
                        });
                      } else {
                        setState(() {
                          checkType = false;
                        });
                      }
                      ////////////////////////////////////////////////////////////
                      if (email.text.isNotEmpty &&
                          password.text.isNotEmpty &&
                           currentSelectedValueuser.toString()!='null') {
                        setState(() {
                          checkemail = false;
                          checkpassword = false;
                         // checkprofile = false;
                          checkType = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StaffAddUserAddress(
                                      phone: phone.text,
                                      lat: lat,
                                      long: long,
                                      name: name.text,
                                      surname: surname.text,
                                      image: urlImag.toString(),
                                      TypeUser: currentSelectedValueuser.toString(),
                                      email: email.text.toString(),
                                      password: password.text.toString(),
                                    )));
                      }
                      //Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      //    builder: (context) => OTPScreen(
                      //         phone: widget.phone,
                      //        name: name.text,
                      //       surname: surname.text,
                      //     )));
                    },
                  ),
                ),
              ),
            )
            ],)));
  }

  Container selectType(screen) {
    return Container(
      height: 50,
      width: screen * 0.90,
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

   CupertinoActionSheet photo(BuildContext context) {
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
}
