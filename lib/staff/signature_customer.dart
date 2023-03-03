
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purer/staff/staff_tuknam.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

class SignatureCustomer extends StatefulWidget {
  final data;
  final name;
  final surname;
  final int qty;
  const SignatureCustomer({Key? key, required this.data, required this.name,required this.surname, required this.qty}) : super(key: key);

  @override
  State<SignatureCustomer> createState() => _SignatureCustomerState();
}

class _SignatureCustomerState extends State<SignatureCustomer> {
  late SignatureController controller;
  @override
  void initState() {
    super.initState();

    controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.red,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

   XFile? _image;
  UploadTask? uploadTask;
  late String urlImag;
  var imagepath;
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
    saveImage(_image!.path);
    //_updateDataImage();
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
    print(_image!.path);
    profileUser();
    //Get.to(Edit_account());
  }

  var partImage;

  Future profileUser() async {
    showDialog(
        barrierDismissible: false, context: context, builder: (_) => dialog3());
    final path = 'profile/purer-${_image!.name}';
    final file = File(_image!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlImage = await snapshot.ref.getDownloadURL();
    setState(() {
      urlImag = urlImage;
    });
    saveImage(urlImage);
    Navigator.pop(context);
    // _updateDataImage();
    print('Linkkkkkkkkkkk: ' + urlImage);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TuknamScreen(image: urlImage,data: widget.data,name: widget.name,surname: widget.surname,qty: widget.qty,)));
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );



  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';

    final result = await ImageGallerySaver.saveImage(signature);
    final isSuccess = result['isSuccess'];
    var path = result['filePath'];
   

    if (isSuccess) {
    setState(() {
      partImage = path;
    });
      
      print(partImage);
      getimage1();
    }
  }

  var signature;

  @override
  Widget build(BuildContext context) {
    double screen1 = MediaQuery.of(context).size.height;
    return Scaffold(
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
        title: const Text('ລາຍເຊັນບລູກຄ້າ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: screen1 *0.70,
            child: Signature(
              controller: controller,
              backgroundColor: Colors.white,
            ),
          ),
          buildButtons(context),
          //buildSwapOrientation(),
        ],
      ),
    );
  }

  Widget buildSwapOrientation() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final newOrientation =
            isPortrait ? Orientation.landscape : Orientation.portrait;

        controller.clear();
        setOrientation(newOrientation);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPortrait
                  ? Icons.screen_lock_portrait
                  : Icons.screen_lock_landscape,
              size: 40,
            ),
            const SizedBox(width: 12),
            Text(
              'Tap to change signature orientation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCheck(context),
            buildClear(),
          ],
        ),
      );

  Widget buildCheck(BuildContext context) => IconButton(
        iconSize: 36,
        icon: Icon(Icons.check, color: Colors.green),
        onPressed: () async {
          if (controller.isNotEmpty) {
            final  signature1 = await exportSignature();
            setState(() {
              signature =signature1;
            });

            // await Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => SignaturePreviewPage(signature: signature),
            // ));

            controller.clear();
            print(signature);
          }
     storeSignature(context);
        },
      );

  Widget buildClear() => IconButton(
        iconSize: 36,
        icon: Icon(Icons.clear, color: Colors.red),
        onPressed: () => controller.clear(),
      );

  Future<Uint8List?> exportSignature() async {
    final exportController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    final signature = await exportController.toPngBytes();
    exportController.dispose();

    return signature;
  }

  void setOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}