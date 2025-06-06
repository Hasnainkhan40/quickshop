import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/chats_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/chat_screen/components/sender_bubbel.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title:
            "${controller.friendName}".text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () =>
                  controller.isLoading.value
                      ? Center(child: lodingIndicator())
                      : Expanded(
                        child: StreamBuilder(
                          stream: FirestoreServices.getChatMessages(
                            controller.chatDocId.toString(),
                          ),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                            if (!snapshot.hasData) {
                              return Center(child: lodingIndicator());
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child:
                                    "Send a message..".text
                                        .color(darkFontGrey)
                                        .make(),
                              );
                            } else {
                              return ListView(
                                children:
                                    snapshot.data!.docs.mapIndexed((
                                      currentValue,
                                      index,
                                    ) {
                                      var data = snapshot.data!.docs[index];
                                      return Align(
                                        alignment:
                                            data['uid'] == currentUser!.uid
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: senderBubbel(data),
                                      );
                                    }).toList(),
                              );
                            }
                          },
                        ),
                      ),
            ),
            10.heightBox,
            Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.msgController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: textfieldGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textfieldGrey),
                          ),
                          hintText: "Type a message...",
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.sendMsg(controller.msgController.text);
                        controller.msgController.clear();
                      },
                      icon: Icon(Icons.send, color: Vx.blue700, size: 35),
                    ),
                  ],
                ).box
                .height(80)
                .padding(EdgeInsets.all(12))
                .margin(EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
