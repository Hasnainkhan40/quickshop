import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  var profileImagePath = ''.obs;
  //var profileImageLink = '';
  var isLoding = false.obs;

  //textFiled
  var nameController = TextEditingController();
  var passController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (img == null) return;
      profileImagePath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  /* UploadProfileImage() async {
    var filemane = basename(profileImagePath.value);
    var dastination = 'image/${currentUser!.uid}/$filemane';
    Reference ref = FirebaseStorage.instance.ref().child(dastination);
    await ref.putFile(File(profileImagePath.value));
    profileImageLink = await ref.getDownloadURL();
  }*/

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
}
