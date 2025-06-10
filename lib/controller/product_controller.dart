import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/firebase_const.dart';
import 'package:quickshop/models/category_model.dart';

class ProductController extends GetxController {
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalprice = 0.obs;

  var subcat = [];

  var isFav = false.obs;

  getSubCategories(title) async {
    subcat.clear();
    var data = await rootBundle.loadString('lib/services/category_model.json');
    var decosed = categoryModelFromJson(data);
    var s =
        decosed.categories.where((element) => element.name == title).toList();

    for (var e in s[0].subcategory) {
      subcat.add(e);
    }
  }

  changeColorIndex(index) {
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity) {
    if (quantity.value < totalQuantity) {
      quantity++;
    }
  }

  decreaseQuantity() {
    if (quantity.value > 0) {
      quantity--;
    }
  }

  calculateTotalPrice(price) {
    totalprice.value = price * quantity.value;
  }

  addCart({
    title,
    img,
    sellername,
    color,
    qty,
    tprice,
    context,
    vendorID,
  }) async {
    await firebaseFirestore
        .collection(cartCollection)
        .doc()
        .set({
          'title': title,
          'img': img,
          'sellername': sellername,
          'color': color,
          'qty': qty,
          'vendor_id': vendorID,
          'tprice': tprice,
          'added_by': currentUser!.uid,
        })
        .catchError((error) {
          VxToast.show(context, msg: error.toString());
        });
  }

  resetValue() {
    totalprice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishlist(docId, context) async {
    await firebaseFirestore.collection(productsCollection).doc(docId).set({
      'P_wishlist': FieldValue.arrayUnion([currentUser!.uid]),
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeToWishlist(docId, context) async {
    await firebaseFirestore.collection(productsCollection).doc(docId).set({
      'P_wishlist': FieldValue.arrayRemove([currentUser!.uid]),
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Remove from wishlist");
  }

  checkIffav(data) async {
    if (data['P_wishlist'].contains(currentUser!.uid)) {
      isFav(true);
    } else {
      isFav(false);
    }
  }
}
