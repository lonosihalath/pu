import 'package:get/state_manager.dart';
import 'package:purer/staff/staff_add_user/controller-user/model.dart';
import 'package:purer/staff/staff_add_user/controller-user/service.dart';

class UserAllController extends GetxController {
  var isLoading = true.obs;
  var statetList = <UserAll>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServicesUserall.fetchProducts();
      if (products != null) {
        statetList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}