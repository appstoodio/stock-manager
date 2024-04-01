import 'package:Rashdi_Mobile/controller/auth/signup_controller.dart';
import 'package:Rashdi_Mobile/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // varibales and stuff
  final SignUpController signUpController = Get.put(SignUpController());

  //======================================
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
         backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: signUpController.emailController,
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
                
                    controller: signUpController.passwordController,
                    obscureText: !signUpController.isPasswordVisible.value,
                    decoration: InputDecoration(
                      // ... other decoration properties
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(signUpController.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: signUpController.togglePasswordVisibility,
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
              onPressed: signUpController.isLoading.value
                  ? null
                  : () => signUpController.createUser(),
              child: Text(
                  signUpController.isLoading.value ? 'Loading...' : 'Sign Up'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account? '),
              TextButton(
                  onPressed: () => Get.off(const LoginScreen()),
                  child: const Text('Sign In')),
            ],
          )
        ],
      ),
    );
  }
}
