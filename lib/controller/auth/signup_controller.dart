import 'package:Rashdi_Mobile/model/user.dart';
import 'package:Rashdi_Mobile/screens/auth/login_screen.dart';
import 'package:Rashdi_Mobile/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpController extends GetxController {
// variables and stuf like this
  final _auth = FirebaseAuth.instance;
  final _usser = FirebaseFirestore.instance.collection('usser');
  var isLoading = false.obs;
  var isLoggedIn = false.obs;
  var isPasswordVisible = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

//==================================================

// password toggle
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  //============================

// Create user account

  void createUser() async {
    try {
      isLoading.value = true;
       

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
     

      if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
        if (userCredential.user != null) {
          // Handle successful user creation
          _auth.createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
         Userr userr = Userr(name: emailController.text, password: passwordController.text);
         _usser.doc().set(userr.toMap());
          

          isLoggedIn.value = true;
          // Replace with your home screen route
        } else {
          Get.snackbar('Error', 'User already exists.');
        }
      } else {
      
      }
      
      Get.off(() => const HomeScreen());
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
  //============================
}
