import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/home_controller.dart';

class CartController extends GetxController {
  var totalp = 0.obs;

  //text controller for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var postalcodeController = TextEditingController();
  var phoneController = TextEditingController();
  var stateController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var products = [];

  calculate(data) {
    totalp.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalp.value = totalp.value + int.parse("${data[i]['tprice']}");
    }
  }

  chanagePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({orderPaymentMethod, totalAmount}) async {
    await getProductDetail();
    await firebaseFirestore.collection(ordersCollection).doc().set({
      'order_code': "1564654341",
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().userName,
      'order_by_email': currentUser!.email,
      'order_by_address': addressController.text,
      'order_by_state': stateController.text,
      'order_by_city': cityController.text,
      'order_by_phone': phoneController.text,
      "order_by_postalcode": "Home Delivery",
      'shipping_method': orderPaymentMethod,
      'order_placed': true,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products),
    });
  }

  getProductDetail() {
    products.clear();
    for (var i = 0; i < productSnapshot.lenhth; i++) {
      products.add({
        'color': productSnapshot[i]['color'],
        'img': productSnapshot[i]['img'],
        'qty': productSnapshot[i]['qty'],
        'title': productSnapshot[i]['title'],
      });
    }
  }
}
