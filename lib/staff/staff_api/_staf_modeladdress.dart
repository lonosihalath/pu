import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:purer/screen/signin_signup/stafflogin/model.dart';
import 'package:purer/staff/staff_api/_stafemodel_addr.dart';


class StaffController_add extends GetxController {
  Map<int, Satffdata_addr> _items = {};

  Map<int, Satffdata_addr> get items {
    return {..._items};
  }

  void addItem(int userId, String id, String divison, String district,
      String state, dynamic token) {
    _items.putIfAbsent(
        userId,
        () => Satffdata_addr(
              district: district,
              division: divison,
              id: id,
              state: state,
              token: token,
            ));
  }

  void clear() {
    _items = {};
    update();
  }
}
