import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:velocity_x/velocity_x.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllWishlist(),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshort,
        ) {
          if (!snapshort.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshort.data!.docs.isEmpty) {
            return "No Wishlist yet!..".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshort.data!.docs;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network(
                          "${data[index]['P_imgs'][0]}",
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                        title:
                            "${data[index]['P_name']}".text
                                .fontFamily(semibold)
                                .size(16)
                                .make(),
                        subtitle:
                            "${data[index]['P_price']}".numCurrency.text
                                .fontFamily(semibold)
                                .color(redColor)
                                .make(),
                        trailing: Icon(Icons.favorite, color: redColor).onTap(
                          () async {
                            await firebaseFirestore
                                .collection(productsCollection)
                                .doc(data[index].id)
                                .set({
                                  'P_wishlist': FieldValue.arrayRemove([
                                    currentUser!.uid,
                                  ]),
                                }, SetOptions(merge: true));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
