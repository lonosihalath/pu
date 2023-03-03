import 'package:http/http.dart' as http;
import 'package:purer/address/division/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteServiceDivision {
  static var client = http.Client();

  static Future<List<Division>?> fetchProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await client.get(
        Uri.parse('https://purer.cslox-th.ruk-com.la/api/division/show'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print('Division::::::====>Ok' + '${response.statusCode}' + response.body);
      var jsonString = response.body;
      return DivisionFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
