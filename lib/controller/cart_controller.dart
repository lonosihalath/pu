
import 'package:get/get.dart';
import 'package:purer/controller/cart_model.dart';

class CartController extends GetxController {
  Map<int, CartItem> _items = {};

  Map<int, CartItem> get items {
    return {..._items};
  }


  int get itemCount {
    // return  _items?.length?? 0;
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  //////---------- Add to Cart  ------------/////////////
  void addItem(int productId, id, int price, String name, String image,int quantity,String discription,size) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              image: existingCartItem.image,
              id: existingCartItem.id,
              name: existingCartItem.name,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price,
              discription:existingCartItem.discription,
              size: existingCartItem.size
              ));
      update();
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: id.toString(),
            image: image,
            name: name,
            price: price,
            quantity: quantity,
            discription: discription,
            size: size
            ),
      );
    }
    update();
  }

 
  ////---------- Add Address ------------/////////////

   void delete(int productId, id, int price, String name, String image,int quantity,String discription,size) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              image: existingCartItem.image,
              id: existingCartItem.id,
              name: existingCartItem.name,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price,
              discription: existingCartItem.discription,
              size: existingCartItem.size
              ));
      update();
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: id.toString(),
            image: image,
            name: name,
            price: price,
            quantity: quantity,
            discription: discription,
            size: size
            ),
      );
    }
    update();
  }

  

  void removeitem(int productId) {
    _items.remove(productId);
    update();
  }

  void clear() {
    _items = {};
    update();
  }
}
