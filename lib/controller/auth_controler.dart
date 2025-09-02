import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // ✅ for TextEditingController
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/views/widgets_common/massage.dart';

class AuthControler extends GetxController {
  var isLoding = false.obs;

  // text controllers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  // ✅ add password visibility state
  var isPassHidden = true.obs;
  void togglePassword() => isPassHidden.toggle();

  // (optional) for confirm password in SignUp screen
  var isConfirmPassHidden = true.obs;
  void toggleConfirmPassword() => isConfirmPassHidden.toggle();

  // login method
  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (error) {
      //VxToast.show(context, msg: e.message ?? e.toString());
      showModernToast(context, error.message ?? error.toString());
    }
    return userCredential;
  }

  // signup method
  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      // VxToast.show(context, msg: e.message ?? e.toString());
      showModernToast(context, error.message ?? error.toString());
    }
    return userCredential;
  }

  // storing data method
  storeUserDat({name, password, email}) async {
    DocumentReference store = firebaseFirestore
        .collection(usersCollection)
        .doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      "imageUrl": '',
      "id": currentUser!.uid,
      "cart_count": "00",
      "wishlist": "00",
      "order_count": "00",
    });
  }

  // signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (error) {
      //VxToast.show(context, msg: e.toString());
      showModernToast(context, error.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:quickshop/consts/consts.dart';

// class AuthControler extends GetxController {
//   var isLoding = false.obs;
//   //textController
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();

//   //login method
//   Future<UserCredential?> loginMethod({context}) async {
//     UserCredential? userCredential;
//     try {
//       userCredential = await auth.signInWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//     } on FirebaseAuthException catch (e) {
//       VxToast.show(context, msg: e.toString());
//     }
//     return userCredential;
//   }

//   //signup Method
//   Future<UserCredential?> signupMethod({email, password, context}) async {
//     UserCredential? userCredential;
//     try {
//       userCredential = await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } on FirebaseAuthException catch (e) {
//       VxToast.show(context, msg: e.toString());
//     }
//     return userCredential;
//   }

//   //storing data method
//   storeUserDat({name, password, email}) async {
//     DocumentReference store = firebaseFirestore
//         .collection(usersCollection)
//         .doc(currentUser!.uid);
//     store.set({
//       'name': name,
//       'password': password,
//       'email': email,
//       "imageUrl": '',
//       "id": currentUser!.uid,
//       "cart_count": "00",
//       "wishlist": "00",
//       "order_count": "00",
//     });
//   }

//   //signout method
//   signoutMethod(context) async {
//     try {
//       await auth.signOut();
//     } catch (e) {
//       VxToast.show(context, msg: e.toString());
//     }
//   }
// }
