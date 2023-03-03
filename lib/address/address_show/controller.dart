
import 'package:get/state_manager.dart';
import 'package:purer/address/address_show/model.dart';
import 'package:purer/address/address_show/service.dart';

class AddressShowController extends GetxController {
  var isLoading = true.obs;
  var statetList = <Showaddressmodel>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServicessaddress.fetchProducts();
      if (products != null) {
        statetList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}