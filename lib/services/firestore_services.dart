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
        .where('added_by', isEqualTo: uid)
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

  static getAllOrders() {
    return firebaseFirestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getAllWishlist() {
    return firebaseFirestore
        .collection(productsCollection)
        .where('P_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  static getAllMessages() {
    return firebaseFirestore
        .collection(chatsCollction)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  static getCounts() async {
    var res = await Future.wait([
      firebaseFirestore
          .collection(cartCollection)
          .where('added_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
            return value.docs.length;
          }),
      firebaseFirestore
          .collection(productsCollection)
          .where('P_wishlist', arrayContains: currentUser!.uid)
          .get()
          .then((value) {
            return value.docs.length;
          }),
      firebaseFirestore
          .collection(ordersCollection)
          .where('order_by', isEqualTo: currentUser!.uid)
          .get()
          .then((value) {
            return value.docs.length;
          }),
    ]);
    return res;
  }

  static allproducts() {
    return firebaseFirestore.collection(productsCollection).snapshots();
  }
}
