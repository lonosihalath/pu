import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purer/screen/products/product.dart';
import 'package:purer/staff/staff_add_user/order_controller.dart';

class StaffDetailOrders extends StatefulWidget {
  StaffDetailOrders({Key? key}) : super(key: key);

  @override
  State<StaffDetailOrders> createState() => _StaffDetailOrdersState();
}

class _StaffDetailOrdersState extends State<StaffDetailOrders> {
  StaffAddOrderController addordercontroller =
      Get.put(StaffAddOrderController());
  @override
  Widget build(BuildContext context) {
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
          title: const Text('ລາຍລະອຽດອໍເດີ້',
              style: TextStyle(
                  color: Color(0xFF293275),
                  fontSize: 18,
                  fontFamily: 'noto_semi')),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(24),
              child: GetBuilder<StaffAddOrderController>(
                init: StaffAddOrderController(),
                builder: (context) => Column(
                  children: List.generate(
                      addordercontroller.items.length,
                      (index) => Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFE5EFF9),
                            ),
                            margin: EdgeInsets.only(bottom: 13),
                            width: width,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              color: Colors.white),
                                          child: Image.asset(products[0].image),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(products[0].name.toString(),
                                                  style: TextStyle(
                                                      color: Color(0xFF293275),
                                                      fontSize: 15,
                                                      fontFamily: 'noto_semi')),
                                              SizedBox(height: 2),
                                              Text(
                                                  'ມື້ສົ່ງ: ' +
                                                      addordercontroller
                                                          .items.values
                                                          .toList()[index]
                                                          .day
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Color(0xFF293275),
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'noto_regular')),
                                              // SizedBox(height: 2),
                                              Text(
                                                  'ຈຳນວນຕຸກມັດຈຳ: ' +
                                                      addordercontroller
                                                          .items.values
                                                          .toList()[index]
                                                          .qtyTuk
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Color(0xFF293275),
                                                      fontSize: 15,
                                                      fontFamily:
                                                          'noto_regular')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addordercontroller.deviceTypesday.add(
                                            addordercontroller.items.values
                                                .toList()[index]
                                                .day
                                                .toString());
                                        addordercontroller.removeitem(int.parse(
                                            addordercontroller.items.values
                                                .toList()[index]
                                                .id
                                                .toString()));
                                       
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 25, right: 10),
                                        child: Image.asset(
                                          'icons/datete.png',
                                          width: 35,
                                          color: Color(0xFF293275),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                ),
              )),
        ));
  }
}
