// ignore: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  // final String _url = 'https://bundo-laravel.cslox-th.ruk-com.la/api/';
  final String _urlupdate = 'https://purer.cslox-th.ruk-com.la/api/user/edit/';
  final String _urlupdateaddress =
      'https://purer.cslox-th.ruk-com.la/api/address/edit/';
  final String _url = 'https://purer.cslox-th.ruk-com.la/api/';
  final String url = 'https://purer.cslox-th.ruk-com.la/api/';
  //final String _urlprofile = 'https://bundo-laravel.cslox-th.ruk-com.la/api/';

  // postData(
  //   data,
  //   apiUrl,
  // ) async {
  //   var fullUrl = _url + apiUrl;
  //   return await http.post(Uri.parse(fullUrl),
  //       body: jsonEncode(data), headers: _setHeaders());
  // }
  ////////////////////////////////////////////////////////
  ///
  postDatabottles(data, Url, token) async {
    var fullUrl = _url + Url;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }

  ///////////////////////////////////////////
  ////////////////////////////////////////////////////////
  ///
  postDatadeposit(data, Url, token) async {
    var fullUrl = _url + Url;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }
  ///////////////////////////////////////////

  postDataloginTuck(
    data,
    apiUrl,
  ) async {
    var fullUrl = url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders());
  }
  ///////////////////////////////////////////

  postDataregisterRegular(data, apiUrl, token) async {
    var fullUrl = url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }

  postDataaddress(data, Url, token) async {
    var fullUrl = _url + Url;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }

  ////////////////////////////////////////////////////////////
  postDataOrder(data, url, token) async {
    var fullUrl = _url + url;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }

  postDataupDate(
    data,
    apiUrl,
    token,
  ) async {
    var fullUrl = _urlupdate + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }
  ///////////////////////////////////////////////////////////

  postDataupDateAddress(
    data,
    apiUrl,
    token,
  ) async {
    var fullUrl = _urlupdateaddress + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data), headers: _setHeaders1(token));
  }

  // postDataProfile(
  //   data,
  //   apiUrl,
  //   token,
  // ) async {
  //   var fullUrl = _urlprofile + apiUrl;
  //   return await http.post(Uri.parse(fullUrl),
  //       body: jsonEncode(data), headers: _setHeaders1(token));
  // }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
  _setHeaders1(token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }
}
