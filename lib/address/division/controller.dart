import 'package:get/state_manager.dart';
import 'package:purer/address/division/model.dart';
import 'package:purer/address/division/service.dart';

class DivisionController extends GetxController {
  var isLoading = true.obs;
  var statetList = <Division>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServiceDivision.fetchProducts();
      if (products != null) {
        statetList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}