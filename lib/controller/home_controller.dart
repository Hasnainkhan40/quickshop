import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    getUsername();
    super.onInit();
  }

  var currentNavIndex = 0.obs;

  var userName = '';

  getUsername() async {
    var n = await firebaseFirestore
        .collection(usersCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
          return value.docs.single['name'];
        });
    userName = n;
  }
}
