import 'package:get/get.dart';
import 'package:purer/screen/signin_signup/stafflogin/model.dart';

class StaffController extends GetxController {
  Map<int, Satffdata> _items = {};

  Map<int, Satffdata> get items {
    return {..._items};
  }

  void addItem(token,int productId,String id,String name, String email,
      String phone, String surname, type) {
    _items.putIfAbsent(
        productId,
        () => Satffdata(
            id: id,
            name: name,
            surname: surname,
            email: email,
            phone: phone,
            type: type,
            token: token
            ));
  }

  void clear() {
    _items = {};
    update();
  }
}
