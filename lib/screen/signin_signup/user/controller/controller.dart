import 'dart:convert';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:purer/screen/signin_signup/user/controller/models.dart';
import 'package:purer/widgets/check_error.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var photoList = <Users>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchAlbumData();
    super.onInit();
  }

  Future<void> fetchAlbumData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');
    String? id = preferences.getString('id');
    final response = await http.get(
        Uri.parse('https://purer.cslox-th.ruk-com.la/api/user/detail/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 201) {
      photoList.clear();
      print(response.statusCode);
      Users _albumModel = Users.fromJson(jsonDecode(response.body));

      photoList.add(
        Users(
          name: _albumModel.name == null ? '....' : _albumModel.name,
          email: _albumModel.email == null ? null : _albumModel.email,
          type: _albumModel.type,
          phone: _albumModel.phone == null ? null : _albumModel.phone,
          surname: _albumModel.surname == null ? '....' : _albumModel.surname,
          status: _albumModel.status,
          depositStatus: _albumModel.depositStatus,
          twoFactorConfirmedAt: _albumModel.twoFactorConfirmedAt,
          profile: _albumModel.profile,
          id: _albumModel.id,
        ),
      );

      isLoading.value = false;
      update();
    } else {
      //Get.to(Server_Error());
    }
  }

  void clear() {
    photoList.clear();
    update();
  }
}
