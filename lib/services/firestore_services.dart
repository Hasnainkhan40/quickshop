import 'package:quickshop/consts/consts.dart';

class FirestoreServices {
  static getUser(uid) {
    return firebaseFirestore
        .collection(usersCollection)
        .where("id", isEqualTo: uid)
        .snapshots();
  }
}
