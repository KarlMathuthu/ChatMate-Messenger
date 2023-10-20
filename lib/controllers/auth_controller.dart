import 'package:chat_mate_messanger/routes/route_class.dart';
import 'package:chat_mate_messanger/widgets/custom_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Initialize Cloud Firestore
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
          userBio: "I'm new to ChatMate!",
          userStatus: 'online',
        );

        // Add user data to Cloud Firestore
        await _firestore
            .collection('users')
            .doc(userUid)
            .set(userModel.toMap());

        customLoader.hideLoader();
        Get.offAllNamed(RouteClass.checkUserState);
      }
    } catch (e) {
      customLoader.hideLoader();
      Get.snackbar("Error creating account", "$e");
    }
  }

  // Function to update user status
  Future<void> updateUserStatus(String status) async {
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser!.uid;
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({"userStatus": status});
      } catch (e) {}
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
      await updateUserStatus("online");
      await updateUserToken();
      customLoader.hideLoader();
      Get.offAllNamed(RouteClass.checkUserState);
    } catch (e) {
      customLoader.hideLoader();
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
      await updateUserStatus("${DateTime.now()}");
      await _auth.signOut();
      customLoader.hideLoader();
      Get.offAllNamed(RouteClass.checkUserState);
    } catch (e) {
      customLoader.hideLoader();
      Get.snackbar("Error logging out", "$e");
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        // Remove user data from Cloud Firestore
        await _firestore.collection('users').doc(user.uid).delete();
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  //Update user token
  Future<void> updateUserToken() async {
    if (_auth.currentUser != null) {
      String uid = _auth.currentUser!.uid;
      String? fcmToken = await messaging.getToken();
      try {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .update({"fcmToken": fcmToken});
      } catch (e) {}
    }
  }
}
