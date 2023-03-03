import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/district/model.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/division/model.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/address/state/model.dart';
import 'package:purer/staff/staff_add_user/profile_photo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screen/signin_signup/stafflogin/controller_staff.dart';

class StaffDetailUser extends StatefulWidget {
  final data;
  const StaffDetailUser({Key? key, required this.data}) : super(key: key);

  @override
  State<StaffDetailUser> createState() => _StaffDetailUserState();
}

class _StaffDetailUserState extends State<StaffDetailUser> {
  @override
  void initState() {
    super.initState();
    userdata();
    userdataimage();
  }

  List data = [];
  List dataimageuser = [];

  bool isLoading = true;
  bool isLoadingimage = true;
  final staffcontroller = Get.put(StaffController());

  userdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
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

  userdataimage() async {
    final response = await http.get(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/user/image/show/${widget.data['attributes']['user_id'].toString()}'),
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

  DistrictController districtController = Get.put(DistrictController());
  StateController stateController = Get.put(StateController());
  DivisionController divisionController = Get.put(DivisionController());

  @override
  Widget build(BuildContext context) {
    double screen = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
          child: Padding(
        padding:
            const EdgeInsets.only(left: 24, top: 10, bottom: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading == true
                ? Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
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
                                      image: data[0]['profile'].toString())));
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.network(
                                data[0]['profile'].toString(),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      SizedBox(height: 10),
                     data[0]['user_id'].toString()=='null' ?SizedBox(): Row(
                        children: [
                          Text('ໄອດີ:   ' + data[0]['user_id'].toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_regular'))
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                        width: screen,
                        child: Text(
                            'ຊື່ ແລະ ນາມສະກຸນ:   ' +
                                data[0]['name'].toString() +
                                '  ' +
                                data[0]['surname'].toString(),
                            style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                                fontFamily: 'noto_regular')),
                      ),
                      SizedBox(height: 3),
                     data[0]['email'].toString()=='null'?SizedBox(): Row(
                        children: [
                          Text('ອີເມວ:   ' + data[0]['email'].toString(),
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 16,
                                  fontFamily: 'noto_regular'))
                        ],
                      ),
                      SizedBox(height: 3),
                      data[0]['phone'].toString() == 'null'
                          ? SizedBox()
                          : Row(
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
                      SizedBox(height: 3),
                      Container(
                          width: screen, 
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'ທີ່ຢູ່:   ' +
                                        widget.data['attributes']['state_id']
                                            .toString() +
                                        ', ' +
                                        widget.data['attributes']['district_id']
                                            .toString() +
                                        ', ' +
                                        widget.data['attributes']['division_id']
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 16,
                                        fontFamily: 'noto_regular'))
                              ])),
                      SizedBox(height: 20),
                      Row(
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
                              padding: const EdgeInsets.only(top: 150),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : dataimageuser.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 80),
                                  child: Center(
                                    child: Text('ຍັງບໍ່ມີຮູບພາບ',
                                        style: TextStyle(
                                            color: Color(0xFF293275),
                                            fontSize: 16,
                                            fontFamily: 'noto_bold')),
                                  ),
                                )
                              : Container(
                                  width: screen,
                                  height: screen,
                                  child: GridView(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 14,
                                            mainAxisSpacing: 14),
                                    children: List.generate(
                                        dataimageuser.length,
                                        (index) => GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (lono) =>
                                                            GalleryImageProfile(
                                                                image: dataimageuser[
                                                                            index]
                                                                        [
                                                                        'image']
                                                                    .toString())));
                                              },
                                              child: Container(
                                                width: screen,
                                                //height: 150,
                                                // margin: EdgeInsets.only(
                                                //     bottom: 10, right: 15),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CachedNetworkImage(
                                                      fadeOutDuration: Duration(
                                                          milliseconds: 100),
                                                      fadeInDuration: Duration(
                                                          milliseconds: 100),
                                                      imageUrl:
                                                          dataimageuser[index]
                                                                  ['image']
                                                              .toString(),
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                                Center(child: CupertinoActivityIndicator(radius: 15,color: Colors.grey,)),
                                                    )
                                                    //  Image.network(
                                                    //   dataimageuser[index]['image']
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
          ],
        ),
      )),
    );
  }

  districtName(District district) => district.districtName.toString();
  sataetName(State1 state) => state.stateName.toString();
  divisiontName(Division division) => division.divisionName.toString();
}
