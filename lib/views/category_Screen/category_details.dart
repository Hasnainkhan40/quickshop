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
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .makeCentered()
                      .box
                      .white
                      .rounded
                      .size(120, 60)
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
                                Image.network(
                                  data[index]['P_imgs'][0],
                                  height: 150,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                "${data[index]['P_name']}".text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                10.heightBox,
                                "${data[index]['P_price']}".numCurrency.text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .size(16)
                                    .make(),
                              ],
                            ).box.white
                            .margin(EdgeInsets.symmetric(horizontal: 4))
                            .roundedSM
                            .outerShadowSm
                            .padding(const EdgeInsets.all(8))
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
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
