import 'package:get/get.dart';
import 'package:purer/staff/staff_add_user/order_model.dart';

class StaffAddOrderController extends GetxController {
  Map<int, CartorderItem > _items = {};

  Map<int, CartorderItem > get items {
    return {..._items};
  }


  int get itemCount {
    // return  _items?.length?? 0;
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.priceTuk * cartItem.qtyTuk;
    });
    return total;
  }

  //////---------- Add to Cart  ------------/////////////
  void addItem(int productId,int id, String day, int qtyTuk,  int priceTik) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartorderItem(
            id: existingCartItem.id,
              day: existingCartItem.day,
              qtyTuk: existingCartItem.qtyTuk,
              priceTuk: existingCartItem.priceTuk
              ));
      update();
    } else {
      _items.putIfAbsent(
        productId,
        () => CartorderItem(
              day: day.toString(),
              id: id,
              qtyTuk: qtyTuk,
              priceTuk: priceTik,
              ),
      );
    }
    update();
  }

  ////---------- Add Address ------------/////////////
  ///

  List<String> deviceTypesday = [
    'ວັນຈັນ',
    'ວັນອັງຄານ',
    'ວັນພຸດ',
    'ວັນພະຫັດ',
    'ວັນສຸກ',
    'ວັນເສົາ'
  ];
  

  void removeitem(int productId) {
    _items.remove(productId);
    update();
  }

  void clear() {
    _items = {};
    update();
  }
}