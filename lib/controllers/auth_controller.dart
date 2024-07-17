import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/ui/home_page.dart';
import 'package:to_do_list/ui/sign_up_page.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  Future<bool> checkAuth() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay for checking auth
    return firebaseUser.value != null; // Return true if user is authenticated
  }

  Future<void> register(String name, String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        // Add more fields as needed
      });

      Get.offAll(() => const HomePage()); // Navigate to HomePage after registration
    } catch (e) {
      Get.snackbar("Error registering", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const HomePage()); // Navigate to HomePage after login
    } catch (e) {
      Get.snackbar("Error logging in", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const SignUp()); // Navigate to SignUp after sign out
    } catch (e) {
      Get.snackbar("Error signing out", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Password Reset Email Sent",
          "Check your email to reset your password",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error resetting password", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
