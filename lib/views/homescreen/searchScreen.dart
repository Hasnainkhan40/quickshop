import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/product_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/category_Screen/item_details.dart';

class Searchscreen extends StatelessWidget {
  final String? title;
  const Searchscreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).make(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              padding: EdgeInsets.only(top: 10, left: 15, right: 4),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.15,
                ),
                children:
                    filtered
                        .mapIndexed(
                          (currentValue, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _productCard(
                                name: filtered[index]['P_name'],
                                image: filtered[index]['P_imgs'][0],
                                price: filtered[index]['P_price'],
                                onTap: () {
                                  Get.to(
                                    () => ItemDetails(
                                      title: filtered[index]['P_name'],
                                      data: filtered[index],
                                    ),
                                  );
                                },
                              ),
                              // Image.network(
                              //   filtered[index]['P_imgs'][0],
                              //   width: 130,
                              //   height: 130,
                              //   fit: BoxFit.cover,
                              // ),
                              // 10.heightBox,
                              // "${filtered[index]['P_name']}".text
                              //     .fontFamily(semibold)
                              //     .color(darkFontGrey)
                              //     .make(),
                              // 10.heightBox,
                              // "${filtered[index]['P_price']}"
                              //     .numCurrency
                              //     .text
                              //     .color(redColor)
                              //     .fontFamily(bold)
                              //     .size(16)
                              //     .make(),
                            ],
                          ),
                        )
                        .toList(),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _productCard({
    required String name,
    required String price,
    required String image,
    required VoidCallback onTap,
  }) {
    var controller = Get.put(ProductController());
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 14, bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- Product Image + Favorite ----------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Image.network(
                    image,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Favorite Button
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Icon(
                      controller.isFav.value
                          ? Icons.favorite_outline
                          : Icons.favorite_outline,
                      color:
                          controller.isFav.value ? Colors.black : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),

            /// ---------- Details Section ----------
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Product Name
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),

                  /// Price + Add Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$$price",
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),

                  /// Color Dots Row
                  Row(
                    children: [
                      _colorDot(Colors.blue),
                      _colorDot(Colors.black),
                      _colorDot(Colors.orange),
                      _colorDot(Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
    );
  }
}
