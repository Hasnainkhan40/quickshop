import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/order_screen/order_details.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshort,
        ) {
          if (!snapshort.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshort.data!.docs.isEmpty) {
            return "No order yet!..".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshort.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading:
                      "${index + 1}".text
                          .fontFamily(bold)
                          .color(darkFontGrey)
                          .xl
                          .make(),
                  title:
                      data[index]['order_code']
                          .toString()
                          .text
                          .color(redColor)
                          .fontFamily(semibold)
                          .make(),
                  subtitle:
                      data[index]['total_amount']
                          .toString()
                          .numCurrency
                          .text
                          .fontFamily(bold)
                          .make(),
                  trailing: IconButton(
                    onPressed: () {
                      Get.to(() => OrderDetails(data: data[index]));
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: darkFontGrey,
                    ),
                  ),
                ).box.color(Colors.grey.shade100).roundedLg.make();
              },
            );
          }
        },
      ),
    );
  }
}
