import 'package:quickshop/consts/consts.dart';

class FirestoreServices {
  //Get user data
  static getUser(uid) {
    return firebaseFirestore
        .collection(usersCollection)
        .where("id", isEqualTo: uid)
        .snapshots();
  }

  //Get products accoding to category
  static getProducts(category) {
    return firebaseFirestore
        .collection(productsCollection)
        .where('P_category', isEqualTo: category)
        .snapshots();
  }

  //get cart
  static getCart(uid) {
    return firebaseFirestore
        .collection(cartCollection)
        .where("added_by", isEqualTo: uid)
        .snapshots();
  }

  //deleat document
  static deleteDocument(docId) {
    return firebaseFirestore.collection(cartCollection).doc(docId).delete();
  }

  //get all chat msg
  static getChatMessages(docId) {
    return firebaseFirestore
        .collection(chatsCollction)
        .doc(docId)
        .collection(messageCollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }
}
