import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/controllers/auth_controller.dart';
import 'package:to_do_list/ui/home_page.dart';
import 'package:to_do_list/ui/sign_in_page.dart';
import 'package:to_do_list/ui/styles/app_colors.dart';
import 'package:to_do_list/ui/widgets/auth_button.dart';
import 'package:to_do_list/ui/widgets/auth_form.dart';
import 'package:to_do_list/ui/widgets/auth_header.dart';
import 'package:to_do_list/ui/widgets/auth_richtext.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthController _authController = Get.put(AuthController());

  final _userName = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get userName => _userName.text.trim();
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _signUp() async {
    String name = _userName.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter all details.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _authController.register(name, email, password);
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to sign up: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: AppColors.blue,
              ),
              CustomHeader(
                  text: 'Sign Up',
                  onTap: () {
                    Get.off(() =>  const Signin());
                  }),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: AppColors.whiteshade,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09),
                        child: Image.asset("assets/images/login.png"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Name",
                        hintText: "Name",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        controller: _userName,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        headingText: "Email",
                        hintText: "Email",
                        obsecureText: false,
                        suffixIcon: const SizedBox(),
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomFormField(
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        controller: _passwordController,
                        headingText: "Password",
                        hintText: "At least 8 Character",
                        obsecureText: _obscureText,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AuthButton(
                        onTap: _signUp,
                        text: 'Sign Up',
                      ),
                      CustomRichText(
                        description: 'Already Have an account? ',
                        text: 'Log In here',
                        onTap: () {
                              Get.to(() => Signin());
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}