import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:purer/controller/order_model.dart';
import 'package:purer/widgets/format_money.dart';

class OrderSatatus extends StatefulWidget {
  final order;
  const OrderSatatus({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderSatatus> createState() => _OrderSatatusState();

}

class _OrderSatatusState extends State<OrderSatatus> {
  @override
  void initState()
  {
    super.initState();
    print(widget.order);
  }
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
        title: const Text('ສະຖານະລາຍການສັ່ງຊື້',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 24, right: 24, bottom: 20),
          height: 210,
          width: screen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: List.generate( widget.order['attributes']['order_item_history'].length, (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ignore: prefer_interpolation_to_compose_strings
                        Text(
                            widget.order['attributes']['order_item_history'][index]
                                        ['attributes']['product_name']
                                    .toString() +
                                '  ' +
                                widget.order['attributes']['order_item_history'][index]
                                        ['attributes']['size']
                                    .toString() +
                                '  '+'(${widget.order['attributes']['order_item_history'][index]['attributes']['amount']
                                                                              .toString()})' ,
                            style: const TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 15,
                                fontFamily: 'noto_regular')),
                        Text(
                            nFormat(int.parse(widget.order['attributes']['order_item_history'][index]
                                        ['attributes']['price']
                                    .toString())) +
                                '  ກີບ',
                            style: TextStyle(
                                color: Color(0xFF5D5D5D),
                                fontSize: 15,
                                fontFamily: 'noto_regular')),
                      ],
                    ),),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ລວມມູນຄ່າ:',
                      style: TextStyle(
                          color: Color(0xFF5D5D5D),
                          fontSize: 15,
                          fontFamily: 'noto_bold')),
                  Row(
                    children: [
                      Text(     nFormat(double.parse(widget.order['attributes']['amount_cash']
                                    .toString())),
                          style: const TextStyle(
                              fontSize: 17,
                              color: Color(0xFF293275),
                              fontFamily: 'noto_bold')),
                      SizedBox(width: 8),
                      const Text('ກີບ',
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
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Container(
          width: screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text('ລະຫັດການສັ່ງຊື້: '+widget.order['attributes']['order_no'],
                  style: TextStyle(
                      color: Color(0xFF5D5D5D),
                      fontSize: 13,
                      fontFamily: 'noto_regular')),
               Text(widget.order['attributes']['day']+' '+widget.order['attributes']['order_date'],
                  style: TextStyle(
                      color: Color(0xFF5D5D5D),
                      fontSize: 13,
                      fontFamily: 'noto_regular')),
              const SizedBox(height: 15),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'icons/check.png',
                                width: 25,
                              ),
                              FDottedLine(
                                color: Color(0xFF293275),
                                height: 60,
                                strokeWidth: 2.0,
                                dottedLength: 10.0,
                                space: 2.0,
                              )
                            ],
                          ),
                          const SizedBox(width: 15),
                          const Text('ຮັບອໍເດີ້',
                              style: TextStyle(
                                  color: Color(0xFF293275),
                                  fontSize: 18,
                                  fontFamily: 'noto_me'))
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   child: const Text('10:00',
                      //       style: TextStyle(
                      //           color: Color(0xFF293275),
                      //           fontSize: 13,
                      //           fontFamily: 'copo_regular')),
                      // )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'icons/check.png',
                                width: 25,
                              ),
                              FDottedLine(
                                color: Color(0xFF293275),
                                height: 60,
                                strokeWidth: 2.0,
                                dottedLength: 10.0,
                                space: 2.0,
                              )
                            ],
                          ),
                          const SizedBox(width: 15),
                          const Text('ກຳລັງຈັດສົ່ງ',
                              style: TextStyle(
                                  color: Color(0xFF293275),
                                  fontSize: 18,
                                  fontFamily: 'noto_me'))
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   child: const Text('10:00',
                      //       style: TextStyle(
                      //           color: Color(0xFF293275),
                      //           fontSize: 13,
                      //           fontFamily: 'copo_regular')),
                      // )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                'icons/check.png',
                                width: 25,
                              ),
                              // FDottedLine(
                              //   color: Color(0xFF293275),
                              //   height: 60,
                              //   strokeWidth: 2.0,
                              //   dottedLength: 10.0,
                              //   space: 2.0,
                              // )
                            ],
                          ),
                          const SizedBox(width: 15),
                          const Text('ສົ່ງສຳເລັດ',
                              style: TextStyle(
                                  color: Color(0xFF293275),
                                  fontSize: 18,
                                  fontFamily: 'noto_me'))
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 10),
                      //   child: const Text('10:00',
                      //       style: TextStyle(
                      //           color: Color(0xFF293275),
                      //           fontSize: 13,
                      //           fontFamily: 'copo_regular')),
                      // )
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
