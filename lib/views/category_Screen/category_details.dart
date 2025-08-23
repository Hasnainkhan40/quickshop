import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/product_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/category_Screen/item_details.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key, required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title) {
    if (controller.subcat.contains(title)) {
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    } else {
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  dynamic productMethod;
  @override
  Widget build(BuildContext context) {
    return bgWidget(
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: widget.title!.text.fontFamily(bold).white.make(),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.subcat.length,
                  (index) => "${controller.subcat[index]}".text
                      .size(12)
                      .fontFamily(bold)
                      .color(whiteColor)
                      .makeCentered()
                      .box
                      .color(Colors.orange)
                      .roundedLg
                      .size(120, 50)
                      .margin(const EdgeInsets.symmetric(horizontal: 4))
                      .make()
                      .onTap(() {
                        switchCategory("${controller.subcat[index]}");
                        setState(() {});
                      }),
                ),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: FirestoreServices.getProducts(widget.title),
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshort,
              ) {
                if (!snapshort.hasData) {
                  return Expanded(child: Center(child: lodingIndicator()));
                } else if (snapshort.data!.docs.isEmpty) {
                  return Expanded(
                    child: Center(
                      child:
                          "No products found!".text
                              .color(darkFontGrey)
                              .makeCentered(),
                    ),
                  );
                } else {
                  var data = snapshort.data!.docs;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 250,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                        itemBuilder: (context, index) {
                          return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// ---------- Product Image + Favorite ----------
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(18),
                                            ),
                                        child: Image.network(
                                          data[index]['P_imgs'][0],
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
                                                color: Colors.black.withOpacity(
                                                  0.1,
                                                ),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.favorite_border,
                                            size: 18,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Image.network(
                                  //   data[index]['P_imgs'][0],
                                  //   height: 130,
                                  //   width: 150,
                                  //   fit: BoxFit.cover,
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        "${data[index]['P_name']}".text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,

                                        // "${data[index]['P_price']}".numCurrency.text
                                        //     .color(redColor)
                                        //     .fontFamily(bold)
                                        //     .size(16)
                                        //     .make(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            "${data[index]['P_price']}"
                                                .numCurrency
                                                .text
                                                .color(Colors.orange)
                                                .fontFamily(bold)
                                                .size(16)
                                                .make(),
                                            Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                              ).box.white
                              .margin(EdgeInsets.symmetric(horizontal: 4))
                              .roundedLg
                              .outerShadowSm
                              .make()
                              .onTap(() {
                                controller.checkIffav(data[index]);
                                Get.to(
                                  () => ItemDetails(
                                    title: "${data[index]['P_name']}",
                                    data: data[index],
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Small helper widget for color dots
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
