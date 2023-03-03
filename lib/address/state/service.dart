import 'package:http/http.dart' as http;
import 'package:purer/address/state/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteServicesstate {
  static var client = http.Client();

  static Future<List<State1>?> fetchProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    var response = await client.get(
        Uri.parse('https://purer.cslox-th.ruk-com.la/api/state/show'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print('State::::::====>Ok' + '${response.statusCode}' + response.body);
      var jsonString = response.body;
      return stateFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
