import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickshop/controller/product_controller.dart';

FirebaseAuth auth = FirebaseAuth.instance;

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

User? currentUser = auth.currentUser;

//collection
const usersCollection = "users";
const productsCollection = "products";
const cartCollection = "cart";
const chatsCollction = "chats";
const messageCollection = "messages";
const ordersCollection = "orders";
