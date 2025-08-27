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
      backgroundColor: const Color(0xFFF5F8F5), // ✅ light mint background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(
                  "assets/images/s9.jpg",
                ), // ✅ replace with friend image
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.friendName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Online",
                  style: TextStyle(fontSize: 13, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call, color: Colors.black87),
          ),
          const SizedBox(width: 8),
        ],
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
                              // Auto-scroll only if user is already near bottom
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (controller.isNearBottom.value) {
                                  controller.scrollToBottom();
                                }
                              });

                              return Obx(
                                () => Stack(
                                  children: [
                                    ListView.builder(
                                      controller: controller.scrollController,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var data = snapshot.data!.docs[index];
                                        return Align(
                                          alignment:
                                              data['uid'] == currentUser!.uid
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: ChatBubble(data: data),
                                        );
                                      },
                                    ),

                                    // 👇 Show "New message" button if not at bottom
                                    if (!controller.isNearBottom.value)
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: FloatingActionButton(
                                          mini: true,
                                          backgroundColor: Colors.green,
                                          child: const Icon(
                                            Icons.arrow_downward,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => controller.scrollToBottom(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
            ),
            30.heightBox,
            // ✅ Message Input Field
            Row(
              children: [
                // ✅ Input Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextFormField(
                      controller: controller.msgController,
                      minLines: 1,
                      maxLines: 4, // ✅ expands for long messages
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // ✅ Mic / Send Button
                GestureDetector(
                  onTap: () {
                    if (controller.msgController.text.trim().isNotEmpty) {
                      controller.sendMsg(controller.msgController.text.trim());
                      controller.msgController.clear();
                    }
                  },
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      icon: Icon(
                        controller.msgController.text.trim().isEmpty
                            ? Icons
                                .send // 📩 show send when typing
                            : Icons.mic, // 🎤 show mic when empty
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (controller.msgController.text.trim().isNotEmpty) {
                          controller.sendMsg(
                            controller.msgController.text.trim(),
                          );
                          controller.msgController.clear();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Row(
            //       children: [
            //         Expanded(
            //           child: TextFormField(
            //             controller: controller.msgController,
            //             decoration: const InputDecoration(
            //               border: OutlineInputBorder(
            //                 borderSide: BorderSide(color: textfieldGrey),
            //               ),
            //               focusedBorder: OutlineInputBorder(
            //                 borderSide: BorderSide(color: textfieldGrey),
            //               ),
            //               hintText: "Type a message...",
            //             ),
            //           ),
            //         ),
            //         IconButton(
            //           onPressed: () {
            //             controller.sendMsg(controller.msgController.text);
            //             controller.msgController.clear();
            //           },
            //           icon: Icon(Icons.send, color: Vx.red600, size: 35),
            //         ),
            //       ],
            //     ).box
            //     .height(80)
            //     .padding(EdgeInsets.all(12))
            //     .margin(EdgeInsets.only(bottom: 8))
            //     .make(),
          ],
        ),
      ),
    );
  }
}
