import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test3/features/auth/domain/usecase/change_password_usecase.dart';

class ForgetPasswordController extends GetxController {
  final ForgetPasswordUseCase _useCase;

  ForgetPasswordController(this._useCase);

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  final _isLoading = false.obs;
  final _message = ''.obs;
  final _isSuccess = false.obs;

  bool get isLoading => _isLoading.value;
  String get message => _message.value;
  bool get isSuccess => _isSuccess.value;

  Future<void> forgetPassword(String email) async {
    _isLoading.value = true;
    _message.value = '';

    try {
      final response = await _useCase.execute(email);
      _message.value = response.message;
      _isSuccess.value = response.success;
    } catch (e) {
      _message.value = 'Network error occurred';
      _isSuccess.value = false;
    }

    _isLoading.value = false;
  }

  void clearMessage() {
    _message.value = '';
    _isSuccess.value = false;
  }
}
