import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // variables and stuf like this
  final _auth = FirebaseAuth.instance;
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var isPasswordVisible = false.obs;

  final email = TextEditingController();
  final pass = TextEditingController();

//==================================================


// password toggle
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  //============================

// Create user account

  void loginUser() async {
    try {
      isLoading.value = true;
      // errorMessage.value = ''; // Clear any previous errors

      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text.trim(),
      );

      if (email.text.isNotEmpty && pass.text.isNotEmpty) {
        if (userCredential.user != null) {
          // Handle successful user creation
          _auth.signInWithEmailAndPassword(
              email: email.text.trim(), password: pass.text.trim());
          isLoggedIn.value = true;
          Get.offAll(const HomeScreen());
          // Replace with your home screen route
        } else {
          Get.snackbar('Error', 'User already exists.');
        }
      } else {
        Get.snackbar('Error', 'Fill in all fields.');
      }
     
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong. ${e.toString()}');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong. ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
