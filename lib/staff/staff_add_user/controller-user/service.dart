import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:purer/staff/staff_add_user/controller-user/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../screen/signin_signup/stafflogin/controller_staff.dart';

StaffController staffController = Get.put(StaffController());

class RemoteServicesUserall{
  static var client = http.Client();

  static Future<List<UserAll>?> fetchProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await client.get(
        Uri.parse('https://purer.cslox-th.ruk-com.la/api/user/show/regular'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${staffController.items.values.toList()[0].token}',
        });
    if (response.statusCode == 201) {
      print('State555555::::::====>Ok' + '${response.statusCode}' + response.body);
      var jsonString = response.body;
      return userFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
