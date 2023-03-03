import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/staff/staff_add_user/add_user_order.dart';
import 'package:get/get.dart';
import 'package:purer/staff/staff_add_user/profile_photo.dart';
import '../../screen/signin_signup/stafflogin/controller_staff.dart';

class CreateImageAddress extends StatefulWidget {
  final phone;
  final name;
  final surname;
  final stateId;
  final districtId;
  final divisionId;
  final String typeUser;
  final notes;
  final lat;
  final long;
  final image;
  final email;
  final password;
  CreateImageAddress({
    Key? key,
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
  }) : super(key: key);

  @override
  State<CreateImageAddress> createState() => _CreateImageAddressState();
}

class _CreateImageAddressState extends State<CreateImageAddress> {
  List image = [];
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
      image.add(urlImage);
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


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.all(15),
        width: 75,
        height: 75,
        child: FloatingActionButton(
            onPressed: () {
               showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => photo(context));
            },
            child: const Icon(
              Icons.add_a_photo,
              size: 25,
            )),
      ),
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
        title: const Text('ຮູບພາບສະຖານທີ່ເພີ່ມເຕີມ',
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
                child: const Text('ຢືນຢັນ',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'noto_me')),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (lono) => StaffAddOrderUser(
                                phone: widget.phone,
                                name: widget.name,
                                surname: widget.surname,
                                stateId: widget.stateId,
                                districtId: widget.districtId,
                                divisionId: widget.divisionId,
                                notes: widget.notes,
                                lat: widget.lat,
                                image: widget.image,
                                long: widget.long,
                                typeUser: widget.typeUser,
                                email: widget.email.toString(),
                                password: widget.password,
                                dataimage: image,
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
              const EdgeInsets.only(left: 24, top: 5, right: 24, bottom: 60),
          child: Column(
            children: [
              Center(
                child: Text('ຮູບພາບສະຖານທີ່ ສາມາດເພີ່ມໄດ້ຫຼາຍກ່ວາ 1 ຮູບພາບ',
                    style: TextStyle(
                        color: Color(0xFF293275),
                        fontSize: 14,
                        fontFamily: 'noto_regular')),
              ),
              SizedBox(height: 10),
            image.length.toString()=='0' ?  Container(
              margin: EdgeInsets.only(top: 140),
              child: Center(
                  child: Text('ເພີ່ມຮູບພາບສະຖານທີ່',
                      style: TextStyle(
                          color: Color(0xFF293275),
                          fontSize: 16,
                          fontFamily: 'noto_me')),
                ),
            ):  Container(
                                  width: width,
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
                                                                image: image[index]
                                                                        
                                                                    .toString())));
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
                              imageUrl: image[index]
                                                            
                                                        .toString(),
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>  Center(child: CupertinoActivityIndicator(radius: 15,color: Colors.grey,))
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
            ],
          ),
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
