import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/staff/bill_deposit.dart';
import 'package:purer/widgets/format_money.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ShowDataDeposit extends StatefulWidget {
  final data;
  const ShowDataDeposit({Key? key, required this.data}) : super(key: key);

  @override
  State<ShowDataDeposit> createState() => _ShowDataDepositState();
}

class _ShowDataDepositState extends State<ShowDataDeposit> {
  @override
  void initState() {
    print(widget.data.toString());
    userdata();
    super.initState();
  }

  List data = [];
  List datauser = [];
  List bill = [];
  final staffcontroller = Get.put(StaffController());

  bool loading = true;

  showDeposit() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    var response = await http.get(
        Uri.parse(
            'https://purer.cslox-th.ruk-com.la/api/deposit/show/${widget.data['id'].toString()}'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${staffcontroller.items.values.toList()[0].token}'
        });
    var status = response.statusCode;
    var jsonString = jsonDecode(response.body);
    if (status == 200) {
      setState(() {
        data = jsonString;
         List.generate(data.length,(index)=> billImage(index));
        
      });
      print(jsonString);
      print(status);

    }
  }

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
      datauser.add(json);
          showDeposit();
      // setState(() {
      //   isLoading = false;
      // });
    }
  }
    // Uint8List? bytes =[];

  billImage(index)async{
      final controller1 = ScreenshotController();
            final bytes = await controller1.captureFromWidget(Material(child: cardWidget1(data[index]),));
            setState(() {
              // this.bytes = bytes;
              bill.add(bytes);
               loading = false;
            });
           
  }


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
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xff717171),
              )),
        ),
        title: const Text('ລາຍລະອຽດຂໍ້ມູນມັດຈຳ',
            style: TextStyle(
                color: Color(0xFF293275),
                fontSize: 18,
                fontFamily: 'noto_semi')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: loading == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                    child: Column(
                      children: const [
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
              : data.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text('ບໍ່ໄດ້ມັດຈຳ',
                            style: TextStyle(
                                color: Color(0xFF293275),
                                fontSize: 18,
                                fontFamily: 'noto_me')),
                      ),
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Column(
                            children: List.generate(
                                data.length,
                                (index) => data[index]['amount_bottle'].toString()=='null' || data[index]['price'].toString()=='null'  ?const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text('ບໍ່ມີມັດຈຳ',
                            style: TextStyle(
                                color: Color(0xFF293275),
                                fontSize: 18,
                                fontFamily: 'noto_me')),
                      ),
                    ): GestureDetector(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (lono)=> BillDeposit(bytes: bill[index],)));
                      
                      },
                      child: Container(
                                        margin: EdgeInsets.only(bottom: 13),
                                        padding: EdgeInsets.all(10),
                                        width: width,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.8,
                                                color: Colors.grey.shade200),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    'ລາຍການທີ: ${int.parse(index.toString()) + 1}',
                                                    style: const TextStyle(
                                                        color: Color(0xFF5D5D5D),
                                                        fontSize: 15,
                                                        fontFamily: 'noto_bold')),
                                                Text(
                                                    data[index]['deposit_number'],
                                                    style: const TextStyle(
                                                        color: Color(0xFF5D5D5D),
                                                        fontSize: 15,
                                                        fontFamily: 'noto_bold')),
                                              ],
                                            ),
                                            SizedBox(width: 10),
                                            ////////////////////////////////////////////////
                    
                                            Row(
                                              children: [
                                                Text(
                                                    'ຈຳນວນຕຸກ: ${data[index]['amount_bottle']}',
                                                    style: const TextStyle(
                                                        color: Color(0xFF5D5D5D),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'noto_regular')),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    'ລາຄາລວມ:  ${nFormat(int.parse(data[index]['price']))}',
                                                    style: const TextStyle(
                                                        color: Color(0xFF5D5D5D),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'noto_regular')),
                                                SizedBox(width: 10),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text('ຊື່ຜູ້ໃຫ້ມັດຈຳ: ',
                                                    style: TextStyle(
                                                        color: Color(0xFF5D5D5D),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'noto_regular')),
                                                SizedBox(width: 10),
                                                Text(
                                                    data[index]['approver_name']),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text('ນາມສະກຸນຜູ້ໃຫ້ມັດຈຳ: ',
                                                    style: TextStyle(
                                                        color: Color(0xFF5D5D5D),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'noto_regular')),
                                                SizedBox(width: 10),
                                                Text(data[index]
                                                    ['approver_surname']),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                    )),
                          ),
                        ),
                       //rcardWidget1(data[0])
                      ],
                    )),
    );
  }

  Widget cardWidget() {
    return Container(
      width: 595.28,
      height: 841.89,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Container(
              margin: EdgeInsets.only(left: 40, top: 20, bottom: 20),
              child: Image.asset(
                'images/PR Logo.jpg',
                width: 150,
              )),
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 20),
                width: 595.28,
                height: 37,
                color: Color(0xFF293275),
              ),
              Positioned(
                  right: 110,
                  child: Container(
                    width: 195,
                    height: 70,
                    color: Colors.white,
                    child: Column(
                      children: const [
                        Text('ໃບຢັ້ງຢືນການມັດຈຳ',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        //SizedBox(height: 10),
                        Text('Bottle Deposit Receipt',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                      ],
                    ),
                  ))
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 40, right: 40, top: 15),
            child: Column(
              children: [
                ////////////////////////////////////////////////////////////////
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('ລະຫັດລູກຄ້າ/Customer ID: ',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            Column(
                              children: [
                                const Text('000001',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: 0.5,
                                  color: Color(0xFF293275),
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          width: 1, color: Color(0xFF293275))),
                                ),
                                const SizedBox(width: 12),
                                const Text('ບຸກຄົນ\nIndividual',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular'))
                              ],
                            ),
                            const SizedBox(width: 25),
                            Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(
                                          width: 1, color: Color(0xFF293275))),
                                ),
                                const SizedBox(width: 12),
                                const Text('ນິຕິບຸກຄົນ\n Non Individual',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular'))
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ເລກທີ No : ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        const SizedBox(height: 5),
                        const Text('ວັນທີ Date Issued : ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        const SizedBox(height: 13),
                        Container(
                          color: Color(0xFF293275),
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 22,
                        )
                      ],
                    ),
                  ],
                ),
                ///////////////////////////////////////////////////////////////////////
                const SizedBox(
                  height: 25
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('ຊື່ ແລະ ນາມສະກຸນ :\n Name and Surname ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF293275),
                            fontFamily: 'noto_regular')),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Lono Sihalath',
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          height: 0.5,
                          color: Color(0xFF293275),
                          width: MediaQuery.of(context).size.width * 0.465,
                        ),
                      ],
                    )
                  ],
                ),
                ///////////////////////////////////////////////////////////////////////
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('ທີ່ຢູ່ :\n Address ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Laos',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 0.5,
                              color: Color(0xFF293275),
                              width: MediaQuery.of(context).size.width * 0.20,
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('ເບີໂທລະສັບທີ່ໃຊ້ລົງທະບຽນ :\n Phone Number ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('020 56677603',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 0.5,
                              color: Color(0xFF293275),
                              width: MediaQuery.of(context).size.width * 0.18,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                ///////////////////////////////////////////////////////////////////////
                const SizedBox(height: 25),
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Color(0xFF293275),
                    )),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.white),
                      child: DataTable(
                        headingRowHeight: 50,
                        headingRowColor:
                            MaterialStateProperty.all(Color(0xFFE2E2E2)),
                        columns: const [
                          DataColumn(
                              label: Text(
                            'ລຳດັບ\n No',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular'),
                          )),
                          DataColumn(
                            label: Text(
                                'ຈຳນວນຕຸກທີ່ມັດຈຳ\n Number of bottle deposited',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                          ),
                          DataColumn(
                            label: Text('ລາຄາ\n Price',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                          ),
                          DataColumn(
                            label: Text('ຈຳນວນເງິນ\n Amount',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                          ),
                        ],
                        rows: [
                          DataRow(
                              color: MaterialStateProperty.all(Colors.white),
                              cells: const [
                                DataCell(Center(
                                  child: Text('1',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),
                                )),
                                DataCell(Center(
                                  child: Text('5',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),
                                )),
                                DataCell(Center(
                                  child: Text('50,000 ₭',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),
                                )),
                                DataCell(Center(
                                  child: Text('250,000 ₭',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),
                                )),
                              ]),
                          DataRow(
                              color:
                                  MaterialStateProperty.all(Color(0xFFE2E2E2)),
                              cells: const [
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                              ]),
                          DataRow(
                              color: MaterialStateProperty.all(Colors.white),
                              cells: const [
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                                DataCell(Text('')),
                              ]),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          ///////////////////////////////////////////////////////////////////////
          Container(
            padding: EdgeInsets.only(left: 70, right: 40, top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  const Text('ເງື່ອນໄຂ ແລະ ຂໍ້ກຳນົດ\n Terms and Condition',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF293275),
                                      fontFamily: 'noto_regular')),
                    const SizedBox(height: 10),
                    Container(
                      width: 70,
                      height: 70,
                       decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Color(0xFF293275),
                      )),
                    )
                ],),
                Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 230,
                      height: 45,
                      color: Color(0xFFE2E2E2),
                      child: Row(
                        children: [
                          const Text('ມູນຄ່າການມັດຈຳ : \n Deposit Amount(LAK)            ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),
                                          Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text('250,000 ₭',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            
                          ],
                        )
                        ],
                      ),
                    ),
                       const SizedBox(height: 25),
                     Text('ລາຍເຊັນຜູ້ມັດຈຳ : \n Signature of Depositor            ',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),

                ],)
              ],
            ),
          ),
           const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 300,
                height: 7,
                color: Color(0xFF293275),
              ),
              Container(
                width: 160,
                height: 7,
                color: Color(0xFFE2E2E2),
              ),
              Container(
                width: 70,
                height: 7,
                color: Color(0xFF293275),
              )
            ],
          )
        ],
      ),
    );
  }

 Widget cardWidget1(data) {
    return SingleChildScrollView(

        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 700.89,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.only(left: 40, top: 20, bottom: 20),
                  child: Image.asset(
                    'icons/logo.png',
                    width: MediaQuery.of(context).size.width*0.25,
                  )),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.04,
                    color: Color(0xFF293275),
                  ),
                  Positioned(
                      right: 0,
                      child: Container(
                        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.12),
                        width: MediaQuery.of(context).size.width*0.38,
                        height: MediaQuery.of(context).size.height*0.08,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Text('ໃບຢັ້ງຢືນການມັດຈຳ',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.047,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            //SizedBox(height: 10),
                            Text('Bottle Deposit Receipt',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.030,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                          ],
                        ),
                      ))
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right:MediaQuery.of(context).size.width*0.05, top: 15),
                child: Column(
                  children: [
                    ////////////////////////////////////////////////////////////////
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                               Text('ລະຫັດລູກຄ້າ/Customer ID: ',
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width*0.024,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                                Column(
                                  children: [
                                     Text(datauser[0]['user_id'].toString(),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width*0.024,
                                            color: Color(0xFF293275),
                                            fontFamily: 'noto_regular')),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 5),
                                      height: 0.5,
                                      color: Color(0xFF293275),
                                      width:MediaQuery.of(context).size.width*0.17,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Row(
                                  children: [
                                   datauser[0]['type'].toString()!='ບຸກຄົນ' ?Container(
                                      width: MediaQuery.of(context).size.width*0.038,
                                      height: MediaQuery.of(context).size.width*0.038,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                              width: 1, color: Color(0xFF293275))),
                                    ): Container(
                                     
                                    //  width: MediaQuery.of(context).size.width*0.038,
                                    //   height: MediaQuery.of(context).size.width*0.038,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                              width: 1, color: Color(0xFF293275))),
                                      child: Icon(Icons.check,size: 12.5)),
                                    const SizedBox(width: 12),
                                    Text('ບຸກຄົນ\nIndividual',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width*0.024,
                                            color: Color(0xFF293275),
                                            fontFamily: 'noto_regular'))
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                       datauser[0]['type'].toString()!='ອົງກອນ' ?Container(
                                      width: MediaQuery.of(context).size.width*0.038,
                                      height: MediaQuery.of(context).size.width*0.038,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                              width: 1, color: Color(0xFF293275))),
                                    ): Container(
                                     
                                    //  width: MediaQuery.of(context).size.width*0.038,
                                    //   height: MediaQuery.of(context).size.width*0.038,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(
                                              width: 1, color: Color(0xFF293275))),
                                      child: Icon(Icons.check,size: 12.5)),
                                    const SizedBox(width: 12),
                                    Text('ນິຕິບຸກຄົນ\n Non Individual',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width*0.022,
                                            color: Color(0xFF293275),
                                            fontFamily: 'noto_regular'))
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ເລກທີ No : '+data['deposit_number'].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.024,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            const SizedBox(height: 5),
                             Text('ວັນທີ Date Issued : '+data['created_at'][8].toString()
                                  +data['created_at'][9].toString()
                                  +'/'
                                  +data['created_at'][5].toString()
                                  +data['created_at'][6].toString()
                                  +'/'
                                  +data['created_at'][0].toString()
                                  +data['created_at'][1].toString()
                                  +data['created_at'][2].toString()
                                  +data['created_at'][3].toString()
                                  ,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.024,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            const SizedBox(height: 13),
                            Container(
                              color: Color(0xFF293275),
                              width: MediaQuery.of(context).size.width*0.35,
                              height: 22,
                            )
                          ],
                        ),
                      ],
                    ),
                    ///////////////////////////////////////////////////////////////////////
                    const SizedBox(
                      height: 25
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                         Text('ຊື່ ແລະ ນາມສະກຸນ :\n Name and Surname ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width*0.022,
                                color: Color(0xFF293275),
                                fontFamily: 'noto_regular')),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(datauser[0]['name'].toString()+' '+datauser[0]['surname'].toString(),
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.022,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 0.5,
                              color: Color(0xFF293275),
                              width:MediaQuery.of(context).size.width*0.66
                            ),
                          ],
                        )
                      ],
                    ),
                    ///////////////////////////////////////////////////////////////////////
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Text('ທີ່ຢູ່ :\n Address ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.022,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text(widget.data['attributes']['state_id'].toString()+', '+widget.data['attributes']['district_id'].toString(),
                                    style: TextStyle(
                                        fontSize:MediaQuery.of(context).size.width*0.022,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: 0.5,
                                  color: Color(0xFF293275),
                                  width: MediaQuery.of(context).size.width*0.26,
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                           Text('ເບີໂທລະສັບທີ່ໃຊ້ລົງທະບຽນ :\n Phone Number ',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.022,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular')),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                         Text(widget.data['attributes']['phone'].toString(),
                                    style: TextStyle(
                                        fontSize:MediaQuery.of(context).size.width*0.022,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  height: 0.5,
                                  color: Color(0xFF293275),
                                  width: MediaQuery.of(context).size.width*0.25,
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    ///////////////////////////////////////////////////////////////////////
                    const SizedBox(height: 25),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Color(0xFF293275),
                        )),
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.white),
                          child: DataTable(
                            headingRowHeight: 30,
                            dataRowHeight: 30,
                            headingRowColor:
                                MaterialStateProperty.all(Color(0xFFE2E2E2)),
                            columns: [
                              DataColumn(
                                  label: Text(
                                'ລຳດັບ\n No',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width*0.020,
                                    color: Color(0xFF293275),
                                    fontFamily: 'noto_regular'),
                              )),
                              DataColumn(
                                label: Text(
                                    'ຈຳນວນຕຸກມັດຈຳ',
                                    //'ຈຳນວນຕຸກມັດຈຳ\nNumber of bottle deposited',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width*0.020,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                              ),
                              DataColumn(
                                label: Text('ລາຄາ\n Price',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:MediaQuery.of(context).size.width*0.020,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                              ),
                              DataColumn(
                                label: Text('ຈຳນວນເງິນ\n Amount',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width*0.020,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                              ),
                            ],
                            rows: [
                              DataRow(
                                  color: MaterialStateProperty.all(Colors.white),
                                  cells:  [
                                    DataCell(Center(
                                      child: Text('1',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width*0.019,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_regular')),
                                    )),
                                    DataCell(Center(
                                      child: Text(data['amount_bottle'].toString(),
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width*0.019,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_regular')),
                                    )),
                                    DataCell(Center(
                                      child: Text('50,000',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width*0.019,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_regular')),
                                    )),
                                    DataCell(Center(
                                      child: Text(nFormat(double.parse(data['price'].toString())),
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width*0.019,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_regular')),
                                    )),
                                  ]),
                              DataRow(
                                  color:
                                      MaterialStateProperty.all(Color(0xFFE2E2E2)),
                                  cells: const [
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ]),
                              DataRow(
                                  color: MaterialStateProperty.all(Colors.white),
                                  cells: const [
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ]),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
              ///////////////////////////////////////////////////////////////////////
              Container(
                padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*0.07, right: MediaQuery.of(context).size.width*0.055, top: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      Text('ເງື່ອນໄຂ ແລະ ຂໍ້ກຳນົດ\n Terms and Condition',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width*0.024,
                                          color: Color(0xFF293275),
                                          fontFamily: 'noto_regular')),
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width*0.15,
                            height: MediaQuery.of(context).size.width*0.15,
                           decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Color(0xFF293275),
                          )),
                        )
                    ],),
                    Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width*0.39,
                          height: 45,
                          color: Color(0xFFE2E2E2),
                          child: Row(
                            children: [
                              Text('ມູນຄ່າການມັດຈຳ : \n Deposit Amount(LAK)            ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width*0.019,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_regular')),
                                              Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                Text(nFormat(double.parse(data['price'].toString()))+' ₭',
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width*0.024,
                                        color: Color(0xFF293275),
                                        fontFamily: 'noto_regular')),
                                
                              ],
                            )
                            ],
                          ),
                        ),
                           const SizedBox(height: 24),
                         Text('ລາຍເຊັນຜູ້ມັດຈຳ : \n Signature of Depositor            ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width*0.024,
                                              color: Color(0xFF293275),
                                              fontFamily: 'noto_regular')),
          
                    ],)
                  ],
                ),
              ),
               const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.55,
                    height: 7,
                    color: Color(0xFF293275),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.30,
                    height: 7,
                    color: Color(0xFFE2E2E2),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.10,
                    height: 7,
                    color: Color(0xFF293275),
                  )
                ],
              )
            ],
          ),
        ),
      
    );
  }
}
