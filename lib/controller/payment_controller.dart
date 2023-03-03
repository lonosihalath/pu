import 'package:get/get.dart';

class Payment {
  final String paymentname;
  Payment({required this.paymentname});
}

class PaymentController extends GetxController {
  Map<int, Payment> _items = {};

  Map<int, Payment> get items {
    return {..._items};
  }

  void addmoney(String moneyName) {
    clear();
    _items.putIfAbsent(0, () => Payment(paymentname: moneyName));
  }

  void clear() {
    _items = {};
    update();
  }
}
