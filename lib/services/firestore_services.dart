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

  static getSubCategoryProducts(title) {
    return firebaseFirestore
        .collection(productsCollection)
        .where('P_subcategory', isEqualTo: title)
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

  //Get all orders placed by the currently logged-in user.
  static getAllOrders() {
    return firebaseFirestore
        .collection(ordersCollection)
        .where('order_by', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // Get all products that the current user has added to their wishlist.
  static getAllWishlist() {
    return firebaseFirestore
        .collection(productsCollection)
        .where('P_wishlist', arrayContains: currentUser!.uid)
        .snapshots();
  }

  // Get all chat threads where the current user is the sender (`fromId`).
  static getAllMessages() {
    return firebaseFirestore
        .collection(chatsCollction)
        .where('fromId', isEqualTo: currentUser!.uid)
        .snapshots();
  }

  // Returns a list of counts in the same order as above.
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

  // Get all products in the database (real-time updates).
  static allproducts() {
    return firebaseFirestore.collection(productsCollection).snapshots();
  }

  // Get all products marked as featured (`is_featured = true`).
  static getFeaturedProduct() {
    return firebaseFirestore
        .collection(productsCollection)
        .where('is_featured', isEqualTo: true)
        .get();
  }

  // Search products by [title].
  static searchProducts(title) {
    return firebaseFirestore.collection(productsCollection).get();
  }
}
