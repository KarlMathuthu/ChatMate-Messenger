import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _userRef =
      FirebaseDatabase.instance.ref().child('users');
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Create Account
  Future<void> createAccount({
    required String email,
    required String password,
    required String userName,
    required CustomLoader customLoader,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String? fcmToken = await messaging.getToken();

      if (userCredential.user != null) {
        final String userUid = userCredential.user!.uid;
        final userModel = UserModel(
          userName: userName,
          email: email,
          photoUrl: "none",
          userUid: userUid,
          fcmToken: fcmToken ?? "",
        );
        Map<String, dynamic> userData = userModel.toMap();
        await _userRef.child(userUid).set(userData);
        customLoader.hideLoader();
        Get.offAllNamed(RouteClass.checkUserState);
      }
    } catch (e) {
      Get.snackbar("Error creating account", "$e");
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
    required CustomLoader customLoader,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      customLoader.hideLoader();
      Get.offAllNamed(RouteClass.checkUserState);
    } catch (e) {
      Get.snackbar("Error logging in", "$e");
    }
  }

  // Reset Password
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Check your email to change password!");
    } catch (e) {
      Get.snackbar("Error sending password reset email", "$e");
    }
  }

  // Logout
  Future<void> logout({required CustomLoader customLoader}) async {
    try {
      await _auth.signOut();
      customLoader.hideLoader();
      Get.offAllNamed(RouteClass.checkUserState);
    } catch (e) {
      Get.snackbar("Error logging out", "$e");
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        // Optionally, remove user data from the Realtime Database as well.
        await _userRef.child(user.uid).remove();
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }
}
