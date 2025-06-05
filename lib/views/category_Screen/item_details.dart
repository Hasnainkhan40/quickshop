import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/product_controller.dart';

import 'package:quickshop/views/widgets_common/our_button.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, required this.data});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValue();
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),

          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.share)),
            IconButton(onPressed: () {}, icon: Icon(Icons.favorite_outline)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                        autoPlay: true,
                        height: 350,
                        itemCount: data['P_imgs'].length,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        itemBuilder: (contex, index) {
                          return Image.network(
                            data['P_imgs'][index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      5.heightBox,
                      //title and detail section
                      title!.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      5.heightBox,
                      //rating
                      VxRating(
                        isSelectable: false,
                        value: double.parse(data['P_reting']),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 25,
                        maxRating: 5,
                      ),
                      5.heightBox,
                      "${data['P_price']}".numCurrency.text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),

                      10.heightBox,
                      Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "Seller".text.white
                                        .fontFamily(semibold)
                                        .make(),
                                    5.heightBox,
                                    "${data['P_seller']}".text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .size(16)
                                        .make(),
                                  ],
                                ),
                              ),
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.message_rounded,
                                  color: darkFontGrey,
                                ),
                              ),
                            ],
                          ).box
                          .height(70)
                          .padding(const EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),

                      //color section
                      10.heightBox,
                      Obx(
                        () =>
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child:
                                          "Color: ".text
                                              .color(textfieldGrey)
                                              .make(),
                                    ),
                                    Row(
                                      children: List.generate(
                                        data['P_colors'].length,
                                        (index) => Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            VxBox()
                                                .size(40, 40)
                                                .roundedFull
                                                .color(
                                                  Color(
                                                    data['P_colors'][index],
                                                  ).withOpacity(1.0),
                                                )
                                                .margin(
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                                )
                                                .make()
                                                .onTap(() {
                                                  controller.changeColorIndex(
                                                    index,
                                                  );
                                                }),
                                            Visibility(
                                              visible:
                                                  index ==
                                                  controller.colorIndex.value,
                                              child: const Icon(
                                                Icons.done,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ).box.padding(const EdgeInsets.all(8)).make(),

                                //qouentity section
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child:
                                          "Quantity: ".text
                                              .color(textfieldGrey)
                                              .make(),
                                    ),
                                    Obx(
                                      () => Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              controller.decreaseQuantity();
                                              controller.calculateTotalPrice(
                                                int.parse(data['P_price']),
                                              );
                                            },
                                            icon: const Icon(Icons.remove),
                                          ),
                                          controller.quantity.value.text
                                              .size(16)
                                              .color(darkFontGrey)
                                              .fontFamily(bold)
                                              .make(),
                                          IconButton(
                                            onPressed: () {
                                              controller.increaseQuantity(
                                                int.parse(data['P_quantity']),
                                              );
                                              controller.calculateTotalPrice(
                                                int.parse(data['P_price']),
                                              );
                                            },
                                            icon: const Icon(Icons.add),
                                          ),
                                          10.heightBox,
                                          "( ${data['P_quantity']} available)"
                                              .text
                                              .color(textfieldGrey)
                                              .make(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).box.padding(const EdgeInsets.all(8)).make(),
                                //title row
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child:
                                          "Color: ".text
                                              .color(textfieldGrey)
                                              .make(),
                                    ),
                                    "${controller.totalprice.value}".text
                                        .color(redColor)
                                        .size(16)
                                        .fontFamily(bold)
                                        .make(),
                                  ],
                                ).box.padding(const EdgeInsets.all(8)).make(),
                              ],
                            ).box.white.shadowSm.make(),
                      ),

                      //description section
                      10.heightBox,
                      "Description".text
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      "${data['P_desc']} ".text.color(darkFontGrey).make(),

                      //buttons section
                      10.heightBox,
                      ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                          itemDetailsButtonsList.length,
                          (index) => ListTile(
                            title:
                                itemDetailsButtonsList[index].text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                            trailing: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ),
                      20.heightBox,
                      //products may like section
                      productsyoumayLike.text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            6,
                            (index) =>
                                Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          imgP1,
                                          width: 130,
                                          fit: BoxFit.cover,
                                        ),
                                        10.heightBox,
                                        "Leptop 4GB/64Gb".text
                                            .fontFamily(semibold)
                                            .color(darkFontGrey)
                                            .make(),
                                        10.heightBox,
                                        "\$600".text
                                            .color(redColor)
                                            .fontFamily(bold)
                                            .size(16)
                                            .make(),
                                      ],
                                    ).box.white
                                    .margin(EdgeInsets.symmetric(horizontal: 4))
                                    .roundedSM
                                    .padding(const EdgeInsets.all(8))
                                    .make(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  controller.addCart(
                    color: data['P_colors'][controller.colorIndex.value],
                    context: context,
                    img: data['P_imgs'][0],
                    qty: controller.quantity.value,
                    sellername: data['P_seller'],
                    title: data['P_name'],
                    tprice: controller.totalprice.value,
                  );
                  VxToast.show(context, msg: "Added to cart");
                },
                textcolor: whiteColor,
                title: "Add to",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
