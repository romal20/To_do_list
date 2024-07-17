/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:to_do_list/ui/home_page.dart';
import 'package:to_do_list/ui/sign_up_page.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> firebaseUser;

  @override
  void onInit() {
    super.onInit();

    // Initialize firebaseUser with current user
    firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);

    // Bind firebaseUser to userChanges stream to listen for authentication state changes
    firebaseUser.bindStream(FirebaseAuth.instance.userChanges());

    // Execute _setInitialScreen whenever firebaseUser changes
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    // Navigate to SignUp page if user is not authenticated
    if (user == null) {
      Get.offAll(() => const SignUp());
    } else {
      // Navigate to HomePage if user is authenticated
      Get.offAll(() => const HomePage());
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      // Create user using email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'password': password
        // Add more fields as needed
      });

      // Navigate to HomePage after successful registration
      Get.offAll(() => const HomePage());
    } catch (e) {
      // Display error message if registration fails
      Get.snackbar("Error registering", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      // Sign in user using email and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to HomePage after successful login
      Get.offAll(() => const HomePage());
    } catch (e) {
      // Display error message if login fails
      Get.snackbar("Error logging in", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void forgotPassword(String email) async {
    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Password Reset Email Sent",
          "Check your email to reset your password",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Display error message if password reset fails
      Get.snackbar("Error resetting password", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() async {
    try {
      // Sign out current user
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      // Display error message if sign out fails
      Get.snackbar("Error signing out", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
*/
/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // Create user using email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'password': password
        // Add more fields as needed
      });

      // Navigate to HomePage after successful registration
      Get.offAll(() => const HomePage());
    } catch (e) {
      // Display error message if registration fails
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
      Get.offAll(() => const HomePage());
    } catch (e) {
      Get.snackbar("Error logging in", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const SignUp());
    } catch (e) {
      Get.snackbar("Error signing out", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void forgotPassword(String email) async {
    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Password Reset Email Sent",
          "Check your email to reset your password",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Display error message if password reset fails
      Get.snackbar("Error resetting password", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
*/
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
