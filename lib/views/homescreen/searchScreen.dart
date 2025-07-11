import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/category_Screen/item_details.dart';

class Searchscreen extends StatelessWidget {
  final String? title;
  const Searchscreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(title: title!.text.color(darkFontGrey).make()),
      body: FutureBuilder(
        future: FirestoreServices.searchProducts(title),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshort,
        ) {
          if (!snapshort.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshort.data!.docs.isEmpty) {
            return "No products found".text.makeCentered();
          } else {
            var data = snapshort.data!.docs;
            var filtered =
                data
                    .where(
                      (element) => element['P_name']
                          .toString()
                          .toLowerCase()
                          .contains(title!.toLowerCase()),
                    )
                    .toList();
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 230,
                ),
                children:
                    filtered
                        .mapIndexed(
                          (currentValue, index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    filtered[index]['P_imgs'][0],
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                  10.heightBox,
                                  "${filtered[index]['P_name']}".text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  10.heightBox,
                                  "${filtered[index]['P_price']}"
                                      .numCurrency
                                      .text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .size(16)
                                      .make(),
                                ],
                              ).box.white
                              .margin(EdgeInsets.symmetric(horizontal: 4))
                              .roundedSM
                              .outerShadowLg
                              .padding(const EdgeInsets.all(12))
                              .make()
                              .onTap(() {
                                Get.to(
                                  () => ItemDetails(
                                    title: "${filtered[index]['P_name']}",
                                    data: filtered[index],
                                  ),
                                );
                              }),
                        )
                        .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
