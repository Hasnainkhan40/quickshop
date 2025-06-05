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

  addCart({title, img, sellername, color, qty, tprice, context}) async {
    await firebaseFirestore
        .collection(cartCollection)
        .doc()
        .set({
          'title': title,
          'img': img,
          'sellername': sellername,
          'color': color,
          'qty': qty,
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
}
