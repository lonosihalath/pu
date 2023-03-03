import 'package:get/state_manager.dart';
import 'package:purer/staff/staff_api/order_api/model.dart';
import 'package:purer/staff/staff_api/order_api/service.dart';

class StaffOrderController extends GetxController {
  var isLoading = true.obs;
  var statetList = <StaffOrder>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await RemoteServiceStaffOrder.fetchdata();
      if (products != null) {
        statetList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}