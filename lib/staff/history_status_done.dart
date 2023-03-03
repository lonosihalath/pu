import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/staff/detail_history_status_done.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/signin_signup/stafflogin/controller_staff.dart';

class StaffHistoryStatusDone extends StatefulWidget {
  const StaffHistoryStatusDone({Key? key}) : super(key: key);

  @override
  State<StaffHistoryStatusDone> createState() => _StaffHistoryStatusDoneState();
}

class _StaffHistoryStatusDoneState extends State<StaffHistoryStatusDone> {
  @override
  void initState() {
    super.initState();
    resApi();
  }

  StaffController staffController = Get.put(StaffController());
  bool isLoading = true;
  List data = [];
  resApi() async {
    DateTime date = DateTime.now();
    var day = DateFormat('EEEE').format(date);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //String? token = sharedPreferences.getString('token');
    final staffcontroller = Get.put(StaffController());
    //////// truck4 normal //////////
    String normal = 'https://purer.cslox-th.ruk-com.la/api/truck/view/Done';

    ////////// truck 1 ບສ 8899
    String urlTuck1_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday1/Done';
    String urlTuck1_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday1/Done';
    String urlTuck1_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday1/Done';
    String urlTuck1_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday1/Done';
    String urlTuck1_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday1/Done';
    String urlTuck1_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday1/Done';

    ////////// truck 2 ກດ 2377
    String urlTuck2_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday2/Done';
    String urlTuck2_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday2/Done';
    String urlTuck2_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday2/Done';
    String urlTuck2_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday2/Done';
    String urlTuck2_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday2/Done';
    String urlTuck2_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday2/Done';

    ////////// truck 3 ບບ 1689
    String urlTuck3_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday3/Done';
    String urlTuck3_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday3/Done';
    String urlTuck3_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday3/Done';
    String urlTuck3_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday3/Done';
    String urlTuck3_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday3/Done';
    String urlTuck3_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday3/Done';

    ////////// truck 5 ກບ 2465

    String urlTuck5_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday5/Done';
    String urlTuck5_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday5/Done';
    String urlTuck5_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday5/Done';
    String urlTuck5_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday5/Done';
    String urlTuck5_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday5/Done';
    String urlTuck5_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday5/Done';

    var response = await http.get(
        Uri.parse(staffController.items.values.toList()[0].name == 'ກນ 1648'
            ? normal
            : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                    day == 'Monday'
                ? urlTuck1_Monday
                : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                        day == 'Tuesday'
                    ? urlTuck1_Tuesday
                    : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                            day == 'Wednesday'
                        ? urlTuck1_Wednesday
                        : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                                day == 'Thursday'
                            ? urlTuck1_Thursday
                            : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                                    day == 'Friday'
                                ? urlTuck1_Friday
                                : staffController.items.values.toList()[0].name == 'ບສ 8899' &&
                                        day == 'Saturday'
                                    ? urlTuck1_Saturday
                                    /////////////////////////////////////////////////////////////////////////////////////////////////
                                    : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                            day == 'Monday'
                                        ? urlTuck2_Monday
                                        : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                                day == 'Tuesday'
                                            ? urlTuck2_Tuesday
                                            : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                                    day == 'Wednesday'
                                                ? urlTuck2_Wednesday
                                                : staffController.items.values
                                                                .toList()[0]
                                                                .name ==
                                                            'ກດ 2377' &&
                                                        day == 'Thursday'
                                                    ? urlTuck2_Thursday
                                                    : staffController.items.values
                                                                    .toList()[0]
                                                                    .name ==
                                                                'ກດ 2377' &&
                                                            day == 'Friday'
                                                        ? urlTuck2_Friday
                                                        : staffController.items.values.toList()[0].name == 'ກດ 2377' &&
                                                                day == 'Saturday'
                                                            ? urlTuck2_Saturday
                                                            /////////////////////////////////////////////////////////////////////////////////////////////////
                                                            : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Monday'
                                                                ? urlTuck3_Monday
                                                                : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Tuesday'
                                                                    ? urlTuck3_Tuesday
                                                                    : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Wednesday'
                                                                        ? urlTuck3_Wednesday
                                                                        : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Thursday'
                                                                            ? urlTuck3_Thursday
                                                                            : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Friday'
                                                                                ? urlTuck3_Friday
                                                                                : staffController.items.values.toList()[0].name == 'ບບ 1689' && day == 'Saturday'
                                                                                    ? urlTuck3_Saturday
                                                                                    /////////////////////////////////////////////////////////////////////////////////////////////////
                                                                                    : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Monday'
                                                                                        ? urlTuck5_Monday
                                                                                        : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Tuesday'
                                                                                            ? urlTuck5_Tuesday
                                                                                            : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Wednesday'
                                                                                                ? urlTuck5_Wednesday
                                                                                                : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Thursday'
                                                                                                    ? urlTuck5_Thursday
                                                                                                    : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Friday'
                                                                                                        ? urlTuck5_Friday
                                                                                                        : staffController.items.values.toList()[0].name == 'ກບ 2465' && day == 'Saturday'
                                                                                                            ? urlTuck5_Saturday
                                                                                                            : 'lono.com'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}',
        });
    var jsonString = jsonDecode(response.body)['data'];
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        data = jsonString;
      });
    }
    print('====>' + data.toString());
  }

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
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>StaffDetailOrder(lat: 0.0, long: 0.0,stafforder: ,)));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff717171),
              )),
        ),
        title: const Text('ປະຫວັດການສົ່ງ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: isLoading == true
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('ກຳລັງໂຫຼດ',
                          style: TextStyle(
                              color: Color(0xFF293275),
                              fontSize: 17,
                              fontFamily: 'noto_me')),
                    ],
                  ),
                ),
              )
            : Column(
                children: List.generate(
                    data.length,
                    (index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (angee) => Historydetail(
                                          data: data[index],
                                        )));
                          },
                          child: Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 13),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xFFE5EFF9),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          padding: EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(35)),
                                          child: Image.asset(
                                              products[index].image),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 3),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(products[index].name,
                                                  style: TextStyle(
                                                      color: Color(0xFF293275),
                                                      fontSize: 14,
                                                      fontFamily: 'noto_semi')),
                                              Text(products[index].size,
                                                  style: TextStyle(
                                                      color: Color(0xFF293275),
                                                      fontSize: 12,
                                                      fontFamily: 'noto_semi')),
                                              Text(
                                                  'ຈຳນວນ: ' +
                                                      data[index]['attributes'][
                                                                      'order_item']
                                                                  [
                                                                  0]['attributes']
                                                              ['amount']
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
                                  top: 8,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFF293275)),
                                    child: Text('ສົ່ງສຳເລັດ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontFamily: 'noto_semi')),
                                    width: 100,
                                    height: 27,
                                  )),
                              Positioned(
                                right: 10,
                                bottom: 20,
                                child: Text(
                                    'ລາຄາ: ' +
                                        nFormat(int.parse(data[index]
                                                        ['attributes']
                                                    ['order_item'][0]
                                                ['attributes']['total_amount']
                                            .toString())) +
                                        ' ກີບ',
                                    style: TextStyle(
                                        color: Color(0xFF293275),
                                        fontSize: 15,
                                        fontFamily: 'noto_semi')),
                              ),
                            ],
                          ),
                        )),
              ),
      )),
    );
  }
}
