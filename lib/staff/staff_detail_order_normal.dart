import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/district/model.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/division/model.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/address/state/model.dart';
import 'package:purer/controller/buynow_model.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/staff/detail_user.dart';
import 'package:purer/staff/staff_home.dart';
import 'package:purer/staff/staff_showdata_tuknam.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../screen/signin_signup/register-Api.dart';

class StaffDetailOrderNormal extends StatefulWidget {
  final data;
  const StaffDetailOrderNormal({Key? key, required this.data});

  @override
  State<StaffDetailOrderNormal> createState() => _StaffDetailOrderNormalState();
}

class _StaffDetailOrderNormalState extends State<StaffDetailOrderNormal> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController touknam1 = TextEditingController();
  DistrictController districtController = Get.put(DistrictController());
  StateController stateController = Get.put(StateController());
  DivisionController divisionController = Get.put(DivisionController());

  List payment = ['ເງິນສົດ', 'ເງິນໂອນ', 'ລາຍເດືອນ'];
  String datapayment = '';
  var imagepath;
  // List<XFile>? _image1;
  ImagePicker? picker = ImagePicker();
  XFile? _image;
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

    //_updateDataImage();
    //Get.to(Edit_account());
  }

  @override
  void initState() {
    if (widget.data['attributes']['status'].toString() == 'Processing') {
      setState(() {
        processing = true;
      });
    }
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
    setState(() {
      datapayment = payment[0];
    });
  }

  double lat = 0.0;
  double long = 0.0;
  int indexx = 0;
  int jumnuanTuk = 0;
  late Marker markers;
  bool checkimagePayment = false;

  bool state = false;
  bool statemaps = false;

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

  bool isChecked = false;
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool processing = false;

  String _scanBarcode = '';
  List touknum = [];
  int totall = 0;
  int price = 12000;

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      print(_scanBarcode.toString());
    });
    addItem(
        int.parse(barcodeScanRes.toString()),
        int.parse(barcodeScanRes.toString()),
        products[0].prict,
        products[0].name.toString(),
        products[0].image.toString(),
        1,
        'discription',
        'size');
  }

  Map<int, BuynowItem> productbuynow = {};

  void addItem(int productId, id, int price, String name, String image,
      int quantity, String discription, size) {
    if (productbuynow.containsKey(productId)) {
      removeitem(productId);
    } else {
      productbuynow.putIfAbsent(
        productId,
        () => BuynowItem(
            id: id,
            image: image,
            name: name,
            price: price,
            quantity: quantity,
            discription: discription,
            size: size),
      );
    }
    print('5555555555' + productbuynow.length.toString());

    setState(() {
      totall = price * productbuynow.length;
    });
  }

  void removeitem(int productId) {
    productbuynow.remove(productId);
  }

  var urlImag;
  UploadTask? uploadTask;
  final staffcontroller = Get.put(StaffController());

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
      Navigator.pop(context);
    });
    print('Linkkkkkkkkkkk: ' + urlImage);
  }

  _Updateaddroder() async {
    // showDialog(context: context, builder: (context) => dialog());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    var data = {
      // "amount_cash": totall.toString(),
      "paid_status": indexx == 0
          ? "ຈ່າຍແລ້ວ"
          : indexx == 1
              ? 'ຈ່າຍແລ້ວດ້ວຍເງີນໂອນ'
              : indexx == 2
                  ? 'ຍັງບໍ່ທັນຈ່າຍ'
                  : '',
      "onepay_image": urlImag.toString(),
      "status": "Done",
      // 'order_items': [
      //   {
      //     "image": products[0].image,
      //     "product_name": products[0].name,
      //     "size": products[0].size,
      //     "price": products[0].prict,
      //     "amount": productbuynow.length,
      //     "total_amount": totall.toString(),
      //   }
      // ],
    };
    var res = await CallApi().postDataOrder(
        data,
        'order/update/${widget.data['id'].toString()}',
        '${staffcontroller.items.values.toList()[0].token}');
    var dataorder = json.decode(res.body);

    print(res.body);
    print('Response status: ${res.statusCode}');
    if (res.statusCode == 201) {
      // _addroderHistory(token);
      updateStatusDone();
    }
  }

  updateStatusDone() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await http.post(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/order/update/status/done/${widget.data['id']}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}'
        });
    print('Done:  ' + response.statusCode.toString());
    if (response.statusCode == 201) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => StaffHome()));
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Container(
                  alignment: Alignment.center,
                  width: 201,
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'icons/check.png',
                        width: 40,
                      ),
                      SizedBox(height: 10),
                      const Text(
                        'ສົ່ງສຳເລັດແລ້ວ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'branding4',
                            color: Color(0xFF4D4D4F)),
                      )
                    ],
                  ),
                ),
              );
            });
      });
    }
    //staffOrderController.onInit();
  }

  updateStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await http.post(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/order/update/status/processing/${widget.data['id']}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}'
        });
    print('Pocessing:  ' + response.statusCode.toString());
    if (response.statusCode == 201) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        setState(() {
          processing = true;
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Container(
                  alignment: Alignment.center,
                  width: 201,
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'icons/check.png',
                        width: 40,
                      ),
                      SizedBox(height: 10),
                      const Text(
                        'ອັບເດດສຳເລັດແລ້ວ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'noto_me',
                            color: Color(0xFF4D4D4F)),
                      )
                    ],
                  ),
                ),
              );
            });
      });
    }
    ;
    // print('Processing:  ' + response.body.toString());
    //staffOrderController.onInit();
  }

  updateStatusCancel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await http.post(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/order/update/status/notAvailable/${widget.data['id']}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}'
        });
    if (response.statusCode == 201) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Container(
                  alignment: Alignment.center,
                  width: 201,
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'icons/check.png',
                        width: 40,
                      ),
                      SizedBox(height: 10),
                      const Text(
                        'ສຳເລັດແລ້ວ',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'noto_me',
                            color: Color(0xFF4D4D4F)),
                      )
                    ],
                  ),
                ),
              );
            });
      });
    }
    ;
    //staffOrderController.onInit();
  }

  _addroderHistory(token) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => dialog3());

    var data = {
      "user_id": widget.data['attributes']['user_id'].toString(),
      "division_id": widget.data['attributes']['division_id'].toString(),
      "paid_status": indexx == 0
          ? "ຈ່າຍແລ້ວ"
          : indexx == 1
              ? 'ຈ່າຍແລ້ວດ້ວຍເງີນໂອນ'
              : indexx == 2
                  ? 'ຍັງບໍ່ທັນຈ່າຍ'
                  : '',
      "district_id": widget.data['attributes']['district_id'].toString(),
      "state_id": widget.data['attributes']['state_id'].toString(),
      "longitude_id": widget.data['attributes']['longitude_id'].toString(),
      "latitiude_id": widget.data['attributes']['latitiude_id'].toString(),
      "phone": widget.data['attributes']['phone'].toString(),
      "notes": widget.data['attributes']['notes'].toString(),
      "truck_id": widget.data['attributes']['truck_id'].toString(),
      "day": widget.data['attributes']['day'].toString(),
      "onepay_image": urlImag.toString(),
      "order_date": widget.data['attributes']['order_date'].toString(),
      "amount_cash": widget.data['attributes']['amount_cash'].toString(),
      "order_month": widget.data['attributes']['order_month'].toString(),
      "order_year": widget.data['attributes']['order_year'].toString(),
      "order_type": "regular",
      "order_no": widget.data['attributes']['order_no'].toString(),
      "status": "Done",
      "order_item": List.generate(
        widget.data['attributes']['order_item'].length,
        (index) => {
          "image": widget.data['attributes']['order_item'][index]['attributes']
                  ['image']
              .toString(),
          "product_name": widget.data['attributes']['order_item'][index]
                  ['attributes']['product_name']
              .toString(),
          "size": widget.data['attributes']['order_item'][index]['attributes']
                  ['size']
              .toString(),
          "price": widget.data['attributes']['order_item'][index]['attributes']
                  ['price']
              .toString(),
          "amount": widget.data['attributes']['order_item'][index]['attributes']
                  ['amount']
              .toString(),
          "total_amount": widget.data['attributes']['amount_cash'].toString(),
        },
      ),
      "deposit": []
    };
    var res = await CallApi().postDataOrder(data, 'order/history/insert',
        '${staffcontroller.items.values.toList()[0].token}');
    var dataorder = json.decode(res.body);

    print(res.body);
    print('Response status: ${res.statusCode}');
    if (res.statusCode == 201) {
      _Updateaddroder();
      //tuknam();
    }
  }

  Widget dialog3() => CupertinoAlertDialog(
        title: Center(child: CircularProgressIndicator()),
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(child: Text('ກະລຸນາລໍຖ້າ')),
        ),
      );

  // void tuknam() {
  //   List.generate(productbuynow.length, (index) => insertTuckname(index));
  // }

  insertTuckname(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var data = {
      "bottle_id": productbuynow.values.toList()[index].id,
      "order_id": widget.data['id'].toString(),
      "user_id": widget.data['attributes']['user_id'].toString(),
    };

    var res = await CallApi().postDataOrder(data, 'bottle/insert', token);
    var dataorder = json.decode(res.body);
    print(dataorder);
  }

  opendialog1(text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontFamily: 'noto_regular'),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(5)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white, elevation: 0),
                              child: Text('ຍົກເລີກ',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                      fontFamily: 'noto_regular')),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF293275), elevation: 0),
                              child: Text('ຕົກລົງ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'noto_regular')),
                              onPressed: () {
                                Navigator.pop(context);
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => dialog3());
                                updateStatus();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  opendialog2(text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontFamily: 'noto_regular'),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(5)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white, elevation: 0),
                              child: Text('ຍົກເລີກ',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                      fontFamily: 'noto_regular')),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF293275), elevation: 0),
                              child: Text('ຕົກລົງ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'noto_regular')),
                              onPressed: () async {
                                if (indexx == 1 &&
                                    urlImag.toString() == 'null') {
                                  Navigator.pop(context);
                                  setState(() {
                                    checkimagePayment = true;
                                  });
                                } else {
                                  Navigator.pop(context);
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => dialog3());
                                  _addroderHistory(
                                      '${staffcontroller.items.values.toList()[0].token}');
                                  setState(() {
                                    checkqtytuk = false;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  opendialog3(text) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text.toString(),
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                          fontFamily: 'noto_regular'),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade600),
                              borderRadius: BorderRadius.circular(5)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.white, elevation: 0),
                              child: Text('ຍົກເລີກ',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                      fontFamily: 'noto_regular')),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF293275), elevation: 0),
                              child: Text('ຕົກລົງ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'noto_regular')),
                              onPressed: () async {
                                Navigator.pop(context);
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => dialog3());
                                updateStatusCancel();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  FocusNode focusNode = FocusNode();
  bool checkqtytuk = false;

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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StaffHome()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff717171),
              )),
        ),
        title: const Text('ລາຍລະອຽດອໍເດີ້',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15),
            child: PopupMenuButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              position: PopupMenuPosition.under,
              color: Colors.black87,
              icon: Icon(Icons.more_vert, color: Color(0xFF293275)),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(StaffDetailUser(
                        data: widget.data,
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StaffDetailUser(
                                    data: widget.data,
                                  )));
                    },
                    child: Text('ຂໍ້ມູນລູກຄ້າ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'noto_regular')),
                  ),
                  // PopupMenuItem(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(TuknamScreen(
                  //       image: '',
                  //       name: '',
                  //       qty: 0,
                  //       surname: '',
                  //       data: widget.data,
                  //     ));
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => TuknamScreen(
                  //                   image: '',
                  //                   name: '',
                  //                   qty: 0,
                  //                   surname: '',
                  //                   data: widget.data,
                  //                 )));
                  //   },
                  //   child: Text('ມັດຈຳຕຸກນໍ້າເພີ່ມ',
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontFamily: 'noto_regular')),
                  // ),
                  PopupMenuItem(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(ShowDataDeposit(
                        data: widget.data,
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowDataDeposit(
                                    data: widget.data,
                                  )));
                    },
                    child: Text('ຂໍ້ມູນມັດຈຳຕຸກນໍ້າ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'noto_regular')),
                  ),
                  // PopupMenuItem(
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(KebTuknam());
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) => KebTuknam()));
                  //   },
                  //   child: Text('ເກັບຕຸກນໍ້າ',
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //           fontFamily: 'noto_regular')),
                  // ),
                ];
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.only(bottom: 15),
          height: 140,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: List.generate(
                      widget.data['attributes']['order_item'].length,
                      (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.data['attributes']['order_item']
                                            [index]['attributes']
                                            ['product_name']
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF5D5D5D),
                                        fontFamily: 'noto_me'),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    widget.data['attributes']['order_item']
                                            [index]['attributes']['size']
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF5D5D5D),
                                        fontFamily: 'noto_me'),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    '( ${widget.data['attributes']['order_item'][index]['attributes']['amount'].toString()})',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF5D5D5D),
                                        fontFamily: 'noto_me'),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // Text(
                                  //   'ລາຄາ: ',
                                  //   style: const TextStyle(
                                  //       fontSize: 14,
                                  //       color: Color(0xFF5D5D5D),
                                  //       fontFamily: 'noto_me'),
                                  // ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  Text(
                                      nFormat(double.parse(widget
                                              .data['attributes']['order_item']
                                                  [index]['attributes']['price']
                                              .toString()))
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF5D5D5D),
                                          fontFamily: 'noto_me')),
                                  SizedBox(width: 10),
                                  Text('ກີບ',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF5D5D5D),
                                          fontFamily: 'noto_me')),
                                ],
                              ),
                            ],
                          )),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ລວມມູນຄ່າ:',
                        style: TextStyle(
                            color: Color(0xFF5D5D5D),
                            fontSize: 17,
                            fontFamily: 'noto_bold')),
                    Row(
                      children: [
                        Text(
                            nFormat(double.parse(widget.data['attributes']
                                        ['amount_cash']
                                    .toString()))
                                .toString(),
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_bold')),
                        SizedBox(width: 10),
                        Text('ກີບ',
                            style: TextStyle(
                                fontSize: 17,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_bold')),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'ອໍເດີ້ຜູ້ໃຊ້ໄອດີ: ' +
                              widget.data['attributes']['user_id'].toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF293275),
                              fontFamily: 'noto_bold'),
                        ),
                        Container(
                          // margin: EdgeInsets.only(right: 10),
                          child: Row(
                            children: [
                              Container(
                                  width: 20,
                                  child: Icon(Icons.phone_outlined,
                                      size: 21, color: Color(0xFF293275))),
                              SizedBox(width: 10),
                              Text(
                                widget.data['attributes']['phone'].toString(),
                                style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'copo_bold',
                                    color: Color(0xFF5D5D5D)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Text(
                          widget.data['attributes']['order_no'].toString(),
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF5D5D5D),
                              fontFamily: 'noto_me'),
                        )),
                  ],
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      width: 14,
                      child: Container(
                          width: 5, child: Image.asset('icons/location.png')),
                    ),
                    SizedBox(width: 16),
                    Container(
                      width: screen * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data['attributes']['state_id'].toString() +
                                ', ' +
                                widget.data['attributes']['district_id']
                                    .toString() +
                                ', ' +
                                widget.data['attributes']['division_id']
                                    .toString(),
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF5D5D5D),
                                fontFamily: 'noto_me'),
                          ),
                          Text(
                            'ໝາຍເຫດ: ' +
                                widget.data['attributes']['notes'].toString(),
                            style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF5D5D5D),
                                fontFamily: 'noto_me'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                // Text(
                //   'ລາຍການ:  ',
                //   style: TextStyle(
                //       fontSize: 15,
                //       color: Color(0xFF5D5D5D),
                //       fontFamily: 'noto_bold'),
                // ),
                // SizedBox(height: 15),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text('ຈຳນວນຕຸກ: '),
                //     Row(
                //       children: [
                //         GestureDetector(
                //           onTap: () {
                //             if (jumnuanTuk >= 1) {
                //               setState(() {
                //                 jumnuanTuk--;
                //               });
                //             }
                //           },
                //           child: Image.asset(
                //             'icons/remove.png',
                //             width: 40,
                //           ),
                //         ),
                //         const SizedBox(width: 12),
                //         Container(
                //           padding: EdgeInsets.only(left: 15),
                //           width: 50,
                //           height: 40,
                //           decoration: BoxDecoration(
                //               border: Border.all(
                //                   width: 0.5, color: Colors.grey.shade300),
                //               borderRadius: BorderRadius.circular(10)),
                //           child: TextFormField(
                //             keyboardType: TextInputType.number,
                //             readOnly: true,
                //             style: TextStyle(fontSize: 16),
                //             controller: touknam1,
                //             focusNode: focusNode,
                //             onFieldSubmitted: (value) {
                //               // setState(() {
                //               //   touknum.add(value);
                //               //   totall = price * touknum.length;

                //               //   focusNode.requestFocus();
                //               //   print(touknum.length);
                //               // });
                //             },
                //             decoration: InputDecoration(
                //                 hintText: jumnuanTuk.toString(),
                //                 border: InputBorder.none),
                //           ),
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             const SizedBox(width: 12),
                //             GestureDetector(
                //               onTap: () {
                //                 if (jumnuanTuk < 5) {
                //                   setState(() {
                //                     jumnuanTuk++;
                //                   });
                //                 }
                //               },
                //               child: Image.asset(
                //                 'icons/add2.png',
                //                 width: 38,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                // checkqtytuk == true
                //     ? Container(
                //         width: screen * 0.90,
                //         margin: EdgeInsets.only(),
                //         child: Row(
                //           children: [
                //             Text('ກະລຸນາເພີ່ມຈຳນວນຕຸກ',
                //                 style: TextStyle(
                //                     fontSize: 10,
                //                     color: Colors.red,
                //                     fontFamily: 'noto_regular')),
                //           ],
                //         ),
                //       )
                //     : SizedBox(),
                // Container(
                //   margin: EdgeInsets.only(top: 25),
                //   height: 50,
                //   child: Container(
                //     width: screen,
                //     height: 50,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(10),
                //       child: ElevatedButton(
                //         style:
                //             ElevatedButton.styleFrom(primary: Color(0xFF293275)),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Container(
                //               width: 35,
                //               child: Image.asset('images/barc.png',
                //                   color: Colors.white),
                //             ),
                //             const SizedBox(width: 10),
                //             const Text('ສະແກນຕຸກ',
                //                 style: TextStyle(
                //                     fontSize: 15,
                //                     color: Color(0xFFFFFFFF),
                //                     fontFamily: 'noto_me')),
                //           ],
                //         ),
                //         onPressed: () async {
                //           scanBarcodeNormal();
                //           //String googleUrl =
                //           //'https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}';
                //           //await launchUrl(Uri.parse(googleUrl));
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 15),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: screen,
                      height: screen1 * 0.30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
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
                            mapType: statemaps == false
                                ? MapType.normal
                                : MapType.hybrid,
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
                  ],
                ),

                // Positioned(
                //   child: Container(
                //     alignment: Alignment.center,
                //     width: screen,
                //     height: screen1 * 0.20,
                //     decoration: BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Container(
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(10),
                //         child: GoogleMap(
                //           markers: {markers},
                //           mapType: statemaps == false
                //               ? MapType.normal
                //               : MapType.hybrid,
                //           initialCameraPosition: CameraPosition(
                //               target: LatLng(widget.lat, widget.long), zoom: 16),
                //           onMapCreated: (GoogleMapController controller) {
                //             _controller.complete(controller);
                //           },
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 50,
                  child: Container(
                    width: screen,
                    height: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFF293275)),
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
                          if (Platform.isIOS) {
                           /// String url ='https://www.google.com/maps/dir/?api=1&destination=${widget.data['attributes']['latitiude_id']},${widget.data['attributes']['longitude_id']}';
                          String url ='comgooglemaps://?saddr=&daddr=${widget.data['attributes']['latitiude_id'].toString()},${widget.data['attributes']['longitude_id'].toString()}&directionsmode=driving';
                           /// 
                        // String googleUrl =
                        //     'https://www.google.com/maps/search/?api=1&query=${widget.data['attributes']['latitiude_id'].toString()},${widget.data['attributes']['longitude_id'].toString()}';
                        await launchUrl(Uri.parse(url));
                          }else{
                              MapsLauncher.launchCoordinates(
                              double.parse(widget.data['attributes']
                                      ['latitiude_id']
                                  .toString()),
                              double.parse(widget.data['attributes']
                                      ['longitude_id']
                                  .toString()),
                              'ທີ່ຢູ່ລູກຄ້າ');
                          }
                        

                          // _Updateaddroder();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'ວິທີຈ່າຍເງິນ',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5D5D5D),
                      fontFamily: 'noto_bold'),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      payment.length,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                indexx = index;
                                print(indexx);
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: screen * 0.27,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: indexx == index
                                      ? Border.all(width: 0)
                                      : Border.all(
                                          width: 0.5, color: Color(0xFF707070)),
                                  borderRadius: BorderRadius.circular(7),
                                  color: indexx == index
                                      ? Color(0xFF293275)
                                      : Colors.white),
                              child: Text(payment[index],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: indexx == index
                                          ? Color(0xFFFFFFFF)
                                          : Color(0xFF5D5D5D),
                                      fontFamily: 'noto_me')),
                            ),
                          )),
                ),
                SizedBox(height: 20),
                indexx == 1
                    ? imagepath == null
                        ? GestureDetector(
                            onTap: (() {
                              getimage();
                            }),
                            child: Container(
                              width: screen,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 0.5,
                                      color: const Color(0xFF707070))),
                              child: Column(
                                children: [
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Container(
                                        width: 40,
                                        child: Image.asset('icons/photo.png')),
                                  ),
                                  checkimagePayment == true
                                      ? Text('ກະລຸນາເພີ່ມຮູບພາບການຊຳລະເງິນ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.red,
                                              fontFamily: 'noto_regular'))
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(_image!.path),
                            ))
                    : SizedBox(),
                indexx == 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                              onPressed: () {
                                getimage();
                              },
                              icon: Icon(Icons.edit_outlined,
                                  color: Color(0xFF293275)),
                              label: Text(
                                'ແກ້ໄຂ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_bold'),
                              )),
                        ],
                      )
                    : SizedBox(),
                SizedBox(height: 20),
                Text(
                  'ອັບເດດສະຖານະ',
                  style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF5D5D5D),
                      fontFamily: 'noto_bold'),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    processing == false
                        ? GestureDetector(
                            onTap: () {
                              // updateStatus();
                              opendialog1('ຢືນຢັນກຳລັງຈັດສົ່ງ');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: screen * 0.27,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Color(0xFF707070)),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color(0xFF293275)),
                              child: Text('ກຳລັງຈັດສົ່ງ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: 'noto_me')),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              // opendialog3('ຢືນຢັນການສົ່ງບໍ່ສຳເລັດ');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: screen * 0.27,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Color(0xFF707070)),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white),
                              child: Text('ກຳລັງຈັດສົ່ງ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF707070),
                                      fontFamily: 'noto_me')),
                            ),
                          ),
                    processing == true
                        ? GestureDetector(
                            onTap: () async {
                              opendialog2('ຢືນຢັນການສົ່ງສຳເລັດ');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: screen * 0.27,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Color(0xFF707070)),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Color(0xFF293275)),
                              child: Text('ສົ່ງສຳເລັດ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFFFFFFF),
                                      fontFamily: 'noto_me')),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              //opendialog3('ຢືນຢັນການສົ່ງບໍ່ສຳເລັດ');
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: screen * 0.27,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Color(0xFF707070)),
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white),
                              child: Text('ສົ່ງສຳເລັດ',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF707070),
                                      fontFamily: 'noto_me')),
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        opendialog3('ຢືນຢັນການສົ່ງບໍ່ສຳເລັດ');
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: screen * 0.27,
                        height: 40,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5, color: Color(0xFF707070)),
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white),
                        child: Text('ສົ່ງບໍ່ສຳເລັດ',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF707070),
                                fontFamily: 'noto_me')),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  districtName(District district) => district.districtName.toString();
  sataetName(State1 state) => state.stateName.toString();
  divisiontName(Division division) => division.divisionName.toString();
}
