import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickshop/consts/apis.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart' as dio;
import 'package:quickshop/consts/keys.dart';

class ProfileController extends GetxController {
  var profileImagePath = ''.obs; // local file path
  var profileImageUrl = ''.obs; // uploaded image URL
  //var profileImageLink = '';
  var isLoding = false.obs;
  //var imageUrlCloudy = '';

  //textFiled
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  // changeImage(context) async {
  //   try {
  //     final img = await ImagePicker().pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //     );
  //     if (img == null) return;
  //     profileImagePath.value = img.path;
  //   } on PlatformException catch (e) {
  //     VxToast.show(context, msg: e.toString());
  //   }
  // }

  //  UploadProfileImage() async {
  //   var filemane = basename(profileImagePath.value);
  //   var dastination = 'image/${currentUser!.uid}/$filemane';
  //   Reference ref = FirebaseStorage.instance.ref().child(dastination);
  //   await ref.putFile(File(profileImagePath.value));
  //   profileImageLink = await ref.getDownloadURL();
  // }

  Future<dio.Response> uploadImage(File image) async {
    try {
      String api = UApiUrls.uploadApi(UKeys.cloudName);

      final fileName = image.path.split('/').last;
      final formData = dio.FormData.fromMap({
        'upload_preset': UKeys.uploadPreset,
        'folder': UKeys.profileFolder,
        'file': await dio.MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final dioInstance = dio.Dio();
      dioInstance.interceptors.add(
        dio.LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );

      final response = await dioInstance.post(api, data: formData);
      return response;
    } catch (e) {
      debugPrint('❌ Error While Upload Profile: $e');
      throw 'Failed to upload profile picture, please try again';
    }
  }

  Future<void> uodateProfilePicture(context) async {
    try {
      // Pick Image from Gallery
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image == null) return;

      // Optionally save local path for display (not used in Firestore)
      profileImagePath.value = image.path;

      // Upload Image to Cloudinary
      File file = File(image.path);
      dio.Response response = await uploadImage(file);

      if (response.statusCode == 200) {
        final data = response.data;

        // Save secure network URL
        profileImageUrl.value = data['secure_url'] ?? '';
        // Correct print

        if (profileImageUrl.value.isEmpty) {
          throw 'Image upload did not return a valid URL.';
        }

        // NOW update Firestore with new image URL!
        await uodateProfile(
          imageUrl: profileImageUrl.value,
          name: nameController.text,
          password: oldpassController.text,
        );

        VxToast.show(context, msg: "Profile picture updated successfully!");
      } else {
        throw 'Failed to upload profile picture. Please try again.';
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uodateProfile({name, password, imageUrl}) async {
    var store = firebaseFirestore
        .collection(usersCollection)
        .doc(currentUser!.uid);
    await store.set({
      'name': name,
      'password': password,
      'imageUrl': imageUrl,
    }, SetOptions(merge: true));
    isLoding(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) {
          currentUser!.updatePassword(newpassword);
        })
        .catchError((error) {});
  }
}
