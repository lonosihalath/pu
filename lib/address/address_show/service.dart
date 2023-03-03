import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:purer/address/address_show/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteServicessaddress {
  static var client = http.Client();

  static Future<List<Showaddressmodel>?> fetchProducts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String iduser = preferences.getString('id').toString();

    var response = await client.get(
        Uri.parse('https://purer.cslox-th.ruk-com.la/api/address/show/$iduser'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    var jsonString = response.body;
    print('Addresssss=====>>>>>>>>>>>>>' + jsonString);
    if (response.statusCode == 201) {
      print('State::::::====>Ok' + '${response.statusCode}' + response.body);
      var jsonString = response.body;
      print('Addresssss=====>>>>>>>>>>>>>' + jsonString);
      return addressFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }
}
