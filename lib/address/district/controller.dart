import 'package:get/state_manager.dart';
import 'package:purer/address/district/model.dart';
import 'package:purer/address/district/service.dart';

class DistrictController extends GetxController {
  var isLoading = true.obs;
  var statetList = <District>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServiceDistrict.fetchProducts();
      if (products != null) {
        statetList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}