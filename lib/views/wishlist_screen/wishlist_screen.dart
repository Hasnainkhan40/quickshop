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
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title:
            "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllWishlist(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return "No Wishlist yet!..".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "${data[index]['P_imgs'][0]}",
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      12.widthBox,

                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Delete Icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child:
                                      "${data[index]['P_name']}".text
                                          .fontFamily(semibold)
                                          .size(16)
                                          .color(darkFontGrey)
                                          .make(),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await firebaseFirestore
                                        .collection(productsCollection)
                                        .doc(data[index].id)
                                        .set({
                                          'P_wishlist': FieldValue.arrayRemove([
                                            currentUser!.uid,
                                          ]),
                                        }, SetOptions(merge: true));
                                  },
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: orangeColor,
                                  ),
                                ),
                              ],
                            ),

                            4.heightBox,

                            // Category text
                            "${data[index]['P_subcategory']}".text
                                .size(14)
                                .color(Colors.grey)
                                .make(),

                            8.heightBox,

                            // Price + Quantity stepper
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "${data[index]['P_price']}".numCurrency.text
                                    .fontFamily(semibold)
                                    .size(16)
                                    .color(darkFontGrey)
                                    .make(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}








// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:quickshop/consts/consts.dart';
// import 'package:quickshop/consts/loding_indicator.dart';
// import 'package:quickshop/services/firestore_services.dart';
// import 'package:velocity_x/velocity_x.dart';

// class WishlistScreen extends StatelessWidget {
//   const WishlistScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         title:
//             "My Wishlist".text.color(darkFontGrey).fontFamily(semibold).make(),
//       ),
//       body: StreamBuilder(
//         stream: FirestoreServices.getAllWishlist(),
//         builder: (
//           BuildContext context,
//           AsyncSnapshot<QuerySnapshot> snapshort,
//         ) {
//           if (!snapshort.hasData) {
//             return Center(child: lodingIndicator());
//           } else if (snapshort.data!.docs.isEmpty) {
//             return "No Wishlist yet!..".text.color(darkFontGrey).makeCentered();
//           } else {
//             var data = snapshort.data!.docs;
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: data.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return ListTile(
//                         leading: Image.network(
//                           "${data[index]['P_imgs'][0]}",
//                           width: 80,
//                           fit: BoxFit.cover,
//                         ),
//                         title:
//                             "${data[index]['P_name']}".text
//                                 .fontFamily(semibold)
//                                 .size(16)
//                                 .make(),
//                         subtitle:
//                             "${data[index]['P_price']}".numCurrency.text
//                                 .fontFamily(semibold)
//                                 .color(redColor)
//                                 .make(),
//                         trailing: Icon(Icons.favorite, color: redColor).onTap(
//                           () async {
//                             await firebaseFirestore
//                                 .collection(productsCollection)
//                                 .doc(data[index].id)
//                                 .set({
//                                   'P_wishlist': FieldValue.arrayRemove([
//                                     currentUser!.uid,
//                                   ]),
//                                 }, SetOptions(merge: true));
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }


