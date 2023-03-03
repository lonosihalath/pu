import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purer/screen/signin_signup/register-Api.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';
import 'package:purer/screen/signin_signup/user/editname.dart';
import 'package:purer/screen/signin_signup/user/editphone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfileUser extends StatefulWidget {
  const ProfileUser({Key? key}) : super(key: key);

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  @override
  void initState() {
    setUser();

    super.initState();
  }

  Future setUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    setState(() {
      userToken = token;
    });
    print(userToken);
  }

  XFile? _image;
  UploadTask? uploadTask;
  late String urlImag;
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
      imagepath = _image!.path;
    });
    profileUser();
    //_updateDataImage(token);
    //Get.to(Edit_account());
  }

  var imagesave;

  void saveImage(path) async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    saveimage.clear();
    saveimage.setString('imagepath', path);
    setState(() {
      imagesave = saveimage.getString('imagepath');
    });
    profileUser();
  }

  Future getimagesave() async {
    SharedPreferences saveimage = await SharedPreferences.getInstance();
    setState(() {
      imagesave = saveimage.getString('imagepath');
    });
  }

  Future getimage1() async {
    final XFile? pickedFile = await picker!.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    setState(() {
      _image = pickedFile!;
      imagepath = _image!.path;
    });
    profileUser();
    //Get.to(Edit_account());
  }

  final controller = Get.find<Controller>();

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
    _updateDataImage();
    print('Linkkkkkkkkkkk: ' + urlImage);
  }

  update() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    print(token);
    var data = {
      'profile': urlImag.toString(),
    };
    var res = await CallApi().postDataupDate(data, '${id}', token);
    var body = json.decode(res.body);
    print(body);
    if (res.statusCode == 201) {
      Navigator.pop(context);
      controller.onInit();
    }
    ;
    print('statusCode====>' + res.statusCode.toString());
  }

  _updateDataImage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');

    print('null!!!!');
    var data = {
      'profile': urlImag.toString(),
    };
    var res =
        await CallApi().postDataupDate(data, '${id}', token);
    var body = json.decode(res.body);
    print(body);
    print('statusCode====>' + res.statusCode.toString());
    if (res.statusCode == 201) {
      controller.onInit();
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => Edit_account()));
    }
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
        title: const Text('ໂປຣຟາຍ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Container(
          width: screen,
          child: Column(
            children: [
              controller.photoList.isNotEmpty
                  ? Obx(()=> Container(
                      width: 86,
                      height: 86,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(43),
                          child: Image.network(
                              controller.photoList[0].profile.toString(),fit: BoxFit.cover,))))
                  : Container(
                      width: 86,
                      height: 86,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(43),
                          child: Image.asset('icons/profile.png',fit: BoxFit.cover)),
                    ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                     showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => photo(context));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      color: Color(0xFF293275),
                      size: 20,
                    ),
                    Text('_ ແກ້ໄຂ',
                        style: TextStyle(
                            color: Color(0xFF293275),
                            fontSize: 15,
                            fontFamily: 'noto_semi')),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(10),
                width: screen * 0.90,
                height: 78,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Color(0xFFEBEBEB), width: 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ຊື່',
                            style: TextStyle(
                                color: Color(0xFFA8A8A8),
                                fontSize: 15,
                                fontFamily: 'noto_regular')),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditName()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF293275),
                                size: 20,
                              ),
                              Text('_ ແກ້ໄຂ',
                                  style: TextStyle(
                                      color: Color(0xFF293275),
                                      fontSize: 15,
                                      fontFamily: 'noto_semi')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Obx(()=> Text(controller.photoList[0].name.toString(),
                        style: TextStyle(
                            color: Color(0xFF5D5D5D),
                            fontSize: 18,
                            fontFamily: 'copo_regular')))
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(10),
                width: screen * 0.90,
                height: 73,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Color(0xFFEBEBEB), width: 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('ເບີໂທລະສັບ',
                            style: TextStyle(
                                color: Color(0xFFA8A8A8),
                                fontSize: 15,
                                fontFamily: 'noto_regular')),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditPhone()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                color: Color(0xFF293275),
                                size: 20,
                              ),
                              Text('_ ແກ້ໄຂ',
                                  style: TextStyle(
                                      color: Color(0xFF293275),
                                      fontSize: 15,
                                      fontFamily: 'noto_semi')),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                   Obx(()=>  Text(controller.photoList[0].phone.toString(),
                        style: TextStyle(
                            color: Color(0xFF5D5D5D),
                            fontSize: 18,
                            fontFamily: 'copo_regular')))
                  ],
                ),
              )
            ],
          ),
        ),
      )),
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
