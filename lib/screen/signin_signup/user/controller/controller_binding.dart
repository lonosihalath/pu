
import 'package:get/instance_manager.dart';
import 'package:purer/screen/signin_signup/user/controller/controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<Controller>(Controller());
  }
}