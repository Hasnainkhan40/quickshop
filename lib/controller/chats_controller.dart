import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/home_controller.dart';

class ChatsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var isNearBottom = true.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to user scrolling
    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;

      // If user is within 100px of bottom → consider "at bottom"
      isNearBottom.value = (maxScroll - currentScroll) < 100;
    });

    getChatId();
  }

  var chats = firebaseFirestore.collection(chatsCollction);

  var friendName = Get.arguments[0];
  var frinedId = Get.arguments[1];

  var senderName = Get.find<HomeController>().userName;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();
  var messageText = "".obs;

  dynamic chatDocId;

  var isLoading = false.obs;

  getChatId() async {
    isLoading(true);
    await chats
        .where('users', isEqualTo: {frinedId: null, currentId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chats
                .add({
                  'created_on': null,
                  'last_msg': '',
                  'users': {frinedId: null, currentId: null},
                  'toId': '',
                  'fromId': '',
                  'friend_name': friendName,
                  'sender_name': senderName,
                })
                .then((value) {
                  chatDocId = value.id;
                });
          }
        });
    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': frinedId,
        'fromId': currentId,
      });
      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }

  /// 👇 helper to scroll smoothly
  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:quickshop/consts/consts.dart';
// import 'package:quickshop/controller/home_controller.dart';

// class ChatsController extends GetxController {
//   @override
//   void onInit() {
//     getChatId();

//     super.onInit();
//   }

//   var chats = firebaseFirestore.collection(chatsCollction);

//   var friendName = Get.arguments[0];
//   var frinedId = Get.arguments[1];

//   var senderName = Get.find<HomeController>().userName;
//   var currentId = currentUser!.uid;

//   var msgController = TextEditingController();
//   var messageText = "".obs;

//   dynamic chatDocId;

//   var isLoading = false.obs;

//   getChatId() async {
//     isLoading(true);
//     await chats
//         .where('users', isEqualTo: {frinedId: null, currentId: null})
//         .limit(1)
//         .get()
//         .then((QuerySnapshot snapshot) {
//           if (snapshot.docs.isNotEmpty) {
//             chatDocId = snapshot.docs.single.id;
//           } else {
//             chats
//                 .add({
//                   'created_on': null,
//                   'last_msg': '',
//                   'users': {frinedId: null, currentId: null},
//                   'toId': '',
//                   'fromId': '',
//                   'friend_name': friendName,
//                   'sender_name': senderName,
//                 })
//                 .then((value) {
//                   chatDocId = value.id;
//                 });
//           }
//         });
//     isLoading(false);
//   }

//   sendMsg(String msg) async {
//     if (msg.trim().isNotEmpty) {
//       chats.doc(chatDocId).update({
//         'created_on': FieldValue.serverTimestamp(),
//         'last_msg': msg,
//         'toId': frinedId,
//         'fromId': currentId,
//       });
//       chats.doc(chatDocId).collection(messageCollection).doc().set({
//         'created_on': FieldValue.serverTimestamp(),
//         'msg': msg,
//         'uid': currentId,
//       });
//     }
//   }
// }
