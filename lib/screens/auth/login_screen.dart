import 'package:Rashdi_Mobile/controller/auth/login_controller.dart';
import 'package:Rashdi_Mobile/screens/auth/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // variables and stuf
final LoginController loginController = Get.put(LoginController());

  //=================================================
  @override
  Widget build(BuildContext context) {

    // variables
      final width = Get.width;
    final height = Get.height;

    //========================================
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          IconButton(onPressed: ()=> Get.off(const SignUpScreen()), icon: const Icon(Icons.arrow_back_ios)),
          const Text('Login')
        ],),
       automaticallyImplyLeading: false,
        backgroundColor: Colors.amber,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: loginController.email,
                decoration: const InputDecoration(
                    hintText: 'Name',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.amber)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.amber))),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Obx(() => TextFormField(
                    controller: loginController.pass,
                    obscureText: !loginController.isPasswordVisible.value,
                    decoration: InputDecoration(
                      // ... other decoration properties
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(loginController.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: loginController.togglePasswordVisibility,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.amber)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.amber))),
                    ),
                  )),
            ),
          SizedBox(
            height: height * 0.04,
          ),
          Obx(
                () => ElevatedButton(
                  onPressed: loginController.isLoading.value
                      ? null
                      : () => loginController.loginUser(),
                  child: Text(loginController.isLoading.value ? 'Loading...' : 'Login'),
                ),
              ),
          Row(
          
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Dont have an account? '),
              TextButton(
                  onPressed: () => Get.off(const SignUpScreen()),
                  child: const Text('Create account')),
            ],
          )
        ],
      ),
    );
  }
}
