import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  // Read saved theme or default to false (light mode)
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    isDarkMode.value = box.read("darkMode") ?? false;
    _applyTheme(isDarkMode.value);
    super.onInit();
  }

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    box.write("darkMode", value);
    _applyTheme(value);
  }

  void _applyTheme(bool dark) {
    if (dark) {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
  }
}
