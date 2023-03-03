import 'package:get/state_manager.dart';
import 'package:purer/address/state/model.dart';
import 'package:purer/address/state/service.dart';

class StateController extends GetxController {
  var isLoading = true.obs;
  var statetList = <State1>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServicesstate.fetchProducts();
      if (products != null) {
        statetList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}