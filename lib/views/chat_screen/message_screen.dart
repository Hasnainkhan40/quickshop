import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/chat_screen/chat_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title:
            "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllMessages(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshort,
        ) {
          if (!snapshort.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshort.data!.docs.isEmpty) {
            return "No Messages yet!..".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshort.data!.docs;
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(
                                () => const ChatScreen(),
                                arguments: [
                                  data[index]['friend_name'],
                                  data[index]['toId'],
                                ],
                              );
                            },
                            leading: const CircleAvatar(
                              backgroundColor: redColor,
                              child: Icon(Icons.person, color: whiteColor),
                            ),
                            title:
                                "${data[index]['friend_name']}".text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                            subtitle: "${data[index]['last_msg']}".text.make(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
