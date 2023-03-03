import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:purer/screen/signin_signup/stafflogin/controller_staff.dart';
import 'package:purer/staff/staff_api/order_api/model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

StaffController staffController = Get.put(StaffController());

class RemoteServiceStaffOrder {
  static var client = http.Client();

  static Future<List<StaffOrder>?> fetchdata() async {
    StaffController staffController = Get.put(StaffController());
    DateTime date = DateTime.now();
    var day = DateFormat('EEEE').format(date);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    ///////// -- Truck 1 ກນ 1648
    String normal = 'https://purer.cslox-th.ruk-com.la/api/truck/view';

    ///////// -- Truck 1 ບສ 8899
    ///
    String urlTuck1_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday1';
    String urlTuck1_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday1';
    String urlTuck1_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday1';
    String urlTuck1_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday1';
    String urlTuck1_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday1';
    String urlTuck1_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday1';

    ///////// -- Truck 2 ກດ 2377
    ///
    String urlTuck2_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday2';
    String urlTuck2_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday2';
    String urlTuck2_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday2';
    String urlTuck2_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday2';
    String urlTuck2_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday2';
    String urlTuck2_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday2';

    ///////// -- Truck 3 ບບ 1689
    ///
    String urlTuck3_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday3';
    String urlTuck3_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday3';
    String urlTuck3_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday3';
    String urlTuck3_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday3';
    String urlTuck3_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday3';
    String urlTuck3_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday3';

    ///////// -- Truck 5 ກບ 2465
    ///
    String urlTuck5_Monday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/monday5';
    String urlTuck5_Tuesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/tuesday5';
    String urlTuck5_Wednesday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/wednesday5';
    String urlTuck5_Thursday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/thursday5';
    String urlTuck5_Friday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/friday5';
    String urlTuck5_Saturday =
        'https://purer.cslox-th.ruk-com.la/api/truck/view/saturday5';

    var response = await client.get(
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
                                                                                                            : 'https://google.com.th'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token}',
        });
    //   print(
    // 'District::::::====>Ok' + '${response.statusCode}' + response.body);
    if (response.statusCode == 200) {
      print(
          '55555::::::====>Ok' + '${response.statusCode} ' + response.body);
      var jsonString = response.body;
      return orderFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
