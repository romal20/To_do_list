
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_list/ui/sign_in_page.dart';
import 'package:to_do_list/ui/widgets/form_header.dart';

class ForgotPasswordMailScreen extends StatefulWidget {
  const ForgotPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordMailScreen> createState() => _ForgotPasswordMailScreenState();
}

class _ForgotPasswordMailScreenState extends State<ForgotPasswordMailScreen> {
  final emailController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        //automaticallyImplyLeading: true,
        leading: IconButton(onPressed: (){Get.offAll(() => Signin());},
            icon: const Icon(Icons.arrow_back_ios,size: 32)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20*4),
              FormHeaderWidget(
                //image: forgotPasswordImage,
                title: "Forgot Password?",
                subTitle: "Reset Password",
                crossAxisAlignment: CrossAxisAlignment.center,
                heightBetween:30.0,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.0,),
              Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          label: Text("Email"),
                          hintText: "Email",
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      SizedBox(width: double.infinity, child: ElevatedButton(
                          onPressed: resetPassword,
                          child: Text("Next")))
                    ],
                  )
              )
            ],
          ),
        ),
      ),

    );
  }

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator())
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      Get.snackbar("Password Reset Email Sent",
          "Please check your email to reset your password.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch(e){
      print(e);
      Get.snackbar("" , e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      Navigator.of(context).pop();
    }
  }
}