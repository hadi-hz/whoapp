import 'package:get/get.dart';

class ProfileController extends GetxController {
  RxBool showHello = false.obs;
  RxBool showWelcome = false.obs;
  RxBool showSignIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!isClosed) showHello.value = true;
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!isClosed) showWelcome.value = true;
    });
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!isClosed) showSignIn.value = true;
    });
  }
}
