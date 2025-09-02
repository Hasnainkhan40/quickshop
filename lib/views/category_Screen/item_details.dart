import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/product_controller.dart';
import 'package:quickshop/views/chat_screen/chat_screen.dart';
import 'package:quickshop/views/widgets_common/massage.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),

          title: Text(
            title ?? "",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () {},
            ),
            Obx(
              () => IconButton(
                onPressed: () {
                  if (controller.isFav.value) {
                    controller.removeToWishlist(data.id, context);
                  } else {
                    controller.addToWishlist(data.id, context);
                  }
                },
                icon: Icon(
                  controller.isFav.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFav.value ? Colors.orange : Colors.black,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Product Image
              Column(
                children: [
                  VxSwiper.builder(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    height: 250,
                    onPageChanged: (index) {
                      controller.currentImageIndex.value = index;
                    },
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    itemCount: data['P_imgs'].length,
                    itemBuilder: (context, index) {
                      final imageUrl = data['P_imgs'][index];

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          width: size.width,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  /// Dot Indicators
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data['P_imgs'].length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width:
                              controller.currentImageIndex.value == index
                                  ? 12
                                  : 8,
                          height:
                              controller.currentImageIndex.value == index
                                  ? 12
                                  : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                controller.currentImageIndex.value == index
                                    ? Colors.orange
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Title + Price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    "\$${data['P_price']}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Seller Section
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Seller",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data['P_seller'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: IconButton(
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Get.to(
                            () => ChatScreen(),
                            arguments: [data['P_seller'], data['vendor_id']],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Color Options
              Row(
                children: [
                  const Text(
                    "Color: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: List.generate(
                      data['P_colors'].length,
                      (index) => GestureDetector(
                        onTap: () {
                          controller.changeColorIndex(index);
                        },
                        child: Obx(
                          () => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  controller.colorIndex.value == index
                                      ? Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      )
                                      : null,
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(data['P_colors'][index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Quantity
              Row(
                children: [
                  const Text(
                    "Quantity:",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
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
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          controller.quantity.value.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            controller.increaseQuantity(
                              int.parse(data['P_quantity']),
                            );
                            controller.calculateTotalPrice(
                              int.parse(data['P_price']),
                            );
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "(${data['P_quantity']} available)",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Tabs (Description, Specifications, Reviews)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _tabButton("Description", true),
                  _tabButton("Specifications", false),
                  _tabButton("Reviews", false),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                data['P_desc'],
                style: const TextStyle(color: Colors.grey, height: 1.5),
              ),

              const SizedBox(height: 24),

              /// Products you may like
              const Text(
                "Products you may like",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.asset(
                              cosmeticimg,
                              height: 110,
                              width: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Beauty Kit",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "\$600",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        /// Bottom Button
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          height: 80,
          child: ourButton(
            color: Colors.orange,
            onPress: () {
              if (controller.quantity.value > 0) {
                controller.addCart(
                  color: data['P_colors'][controller.colorIndex.value],
                  context: context,
                  vendorID: data['vendor_id'],
                  img: data['P_imgs'][0],
                  qty: controller.quantity.value,
                  sellername: data['P_seller'],
                  title: data['P_name'],
                  tprice: controller.totalprice.value,
                );
                showModernToast(
                  context,
                  "Success"
                  "Added to cart",
                );
              } else {
                showModernToast(
                  context,
                  "Error  "
                  "Minimum 1 product required",
                );
              }
            },
            textcolor: Colors.white,
            title: "Add to Cart",
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.orange : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:quickshop/consts/consts.dart';
// import 'package:quickshop/consts/list.dart';
// import 'package:quickshop/controller/product_controller.dart';
// import 'package:quickshop/views/chat_screen/chat_screen.dart';

// import 'package:quickshop/views/widgets_common/our_button.dart';

// class ItemDetails extends StatelessWidget {
//   final String? title;
//   final dynamic data;
//   const ItemDetails({super.key, required this.title, required this.data});
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.put(ProductController());
//     return WillPopScope(
//       onWillPop: () async {
//         controller.resetValue();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: lightGrey,
//         appBar: AppBar(
//           leading: IconButton(
//             onPressed: () {
//               controller.resetValue();
//               Get.back();
//             },
//             icon: Icon(Icons.arrow_back),
//           ),
//           title: title!.text.color(darkFontGrey).fontFamily(bold).make(),

//           actions: [
//             IconButton(onPressed: () {}, icon: Icon(Icons.share)),
//             Obx(
//               () => IconButton(
//                 onPressed: () {
//                   if (controller.isFav.value) {
//                     controller.removeToWishlist(data.id, context);
//                   } else {
//                     controller.addToWishlist(data.id, context);
//                   }
//                 },
//                 icon: Icon(
//                   Icons.favorite_outline,
//                   color: controller.isFav.value ? redColor : darkFontGrey,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       VxSwiper.builder(
//                         autoPlay: true,
//                         height: 350,
//                         itemCount: data['P_imgs'].length,
//                         aspectRatio: 16 / 9,
//                         viewportFraction: 1.0,
//                         itemBuilder: (contex, index) {
//                           return Image.network(
//                             data['P_imgs'][index],
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                       5.heightBox,
//                       //title and detail section
//                       title!.text
//                           .size(16)
//                           .color(darkFontGrey)
//                           .fontFamily(semibold)
//                           .make(),
//                       5.heightBox,
//                       //rating
//                       VxRating(
//                         isSelectable: false,
//                         value: double.parse(data['P_reting']),
//                         onRatingUpdate: (value) {},
//                         normalColor: textfieldGrey,
//                         selectionColor: golden,
//                         count: 5,
//                         size: 25,
//                         maxRating: 5,
//                       ),
//                       5.heightBox,
//                       "${data['P_price']}".numCurrency.text
//                           .color(redColor)
//                           .fontFamily(bold)
//                           .size(18)
//                           .make(),

//                       10.heightBox,
//                       Row(
//                             children: [
//                               Expanded(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     "Seller".text.white
//                                         .fontFamily(semibold)
//                                         .make(),
//                                     5.heightBox,
//                                     "${data['P_seller']}".text
//                                         .fontFamily(semibold)
//                                         .color(darkFontGrey)
//                                         .size(16)
//                                         .make(),
//                                   ],
//                                 ),
//                               ),
//                               const CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 child: Icon(
//                                   Icons.message_rounded,
//                                   color: darkFontGrey,
//                                 ),
//                               ).onTap(() {
//                                 Get.to(
//                                   () => const ChatScreen(),
//                                   arguments: [
//                                     data['P_seller'],
//                                     data['vendor_id'],
//                                   ],
//                                 );
//                               }),
//                             ],
//                           ).box
//                           .height(70)
//                           .padding(const EdgeInsets.symmetric(horizontal: 16))
//                           .color(textfieldGrey)
//                           .make(),

//                       //color section
//                       10.heightBox,
//                       Obx(
//                         () =>
//                             Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 100,
//                                       child:
//                                           "Color: ".text
//                                               .color(textfieldGrey)
//                                               .make(),
//                                     ),
//                                     Row(
//                                       children: List.generate(
//                                         data['P_colors'].length,
//                                         (index) => Stack(
//                                           alignment: Alignment.center,
//                                           children: [
//                                             VxBox()
//                                                 .size(40, 40)
//                                                 .roundedFull
//                                                 .color(
//                                                   Color(
//                                                     data['P_colors'][index],
//                                                   ).withOpacity(1.0),
//                                                 )
//                                                 .margin(
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 4,
//                                                   ),
//                                                 )
//                                                 .make()
//                                                 .onTap(() {
//                                                   controller.changeColorIndex(
//                                                     index,
//                                                   );
//                                                 }),
//                                             Visibility(
//                                               visible:
//                                                   index ==
//                                                   controller.colorIndex.value,
//                                               child: const Icon(
//                                                 Icons.done,
//                                                 color: Colors.white,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ).box.padding(const EdgeInsets.all(8)).make(),

//                                 //qouentity section
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 100,
//                                       child:
//                                           "Quantity: ".text
//                                               .color(textfieldGrey)
//                                               .make(),
//                                     ),
//                                     Obx(
//                                       () => Row(
//                                         children: [
//                                           IconButton(
//                                             onPressed: () {
//                                               controller.decreaseQuantity();
//                                               controller.calculateTotalPrice(
//                                                 int.parse(data['P_price']),
//                                               );
//                                             },
//                                             icon: const Icon(Icons.remove),
//                                           ),
//                                           controller.quantity.value.text
//                                               .size(16)
//                                               .color(darkFontGrey)
//                                               .fontFamily(bold)
//                                               .make(),
//                                           IconButton(
//                                             onPressed: () {
//                                               controller.increaseQuantity(
//                                                 int.parse(data['P_quantity']),
//                                               );
//                                               controller.calculateTotalPrice(
//                                                 int.parse(data['P_price']),
//                                               );
//                                             },
//                                             icon: const Icon(Icons.add),
//                                           ),
//                                           10.heightBox,
//                                           "( ${data['P_quantity']} available)"
//                                               .text
//                                               .color(textfieldGrey)
//                                               .make(),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ).box.padding(const EdgeInsets.all(8)).make(),
//                                 //title row
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 100,
//                                       child:
//                                           "Color: ".text
//                                               .color(textfieldGrey)
//                                               .make(),
//                                     ),
//                                     "${controller.totalprice.value}".text
//                                         .color(redColor)
//                                         .size(16)
//                                         .fontFamily(bold)
//                                         .make(),
//                                   ],
//                                 ).box.padding(const EdgeInsets.all(8)).make(),
//                               ],
//                             ).box.white.shadowSm.make(),
//                       ),

//                       //description section
//                       10.heightBox,
//                       "Description".text
//                           .color(darkFontGrey)
//                           .fontFamily(semibold)
//                           .make(),
//                       10.heightBox,
//                       "${data['P_desc']} ".text.color(darkFontGrey).make(),

//                       //buttons section
//                       10.heightBox,
//                       ListView(
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         children: List.generate(
//                           itemDetailsButtonsList.length,
//                           (index) => ListTile(
//                             title:
//                                 itemDetailsButtonsList[index].text
//                                     .fontFamily(semibold)
//                                     .color(darkFontGrey)
//                                     .make(),
//                             trailing: const Icon(Icons.arrow_forward),
//                           ),
//                         ),
//                       ),
//                       20.heightBox,
//                       //products may like section
//                       productsyoumayLike.text
//                           .fontFamily(bold)
//                           .size(16)
//                           .color(darkFontGrey)
//                           .make(),
//                       10.heightBox,
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                             6,
//                             (index) =>
//                                 Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Image.asset(
//                                           imgP1,
//                                           width: 130,
//                                           fit: BoxFit.cover,
//                                         ),
//                                         10.heightBox,
//                                         "Leptop 4GB/64Gb".text
//                                             .fontFamily(semibold)
//                                             .color(darkFontGrey)
//                                             .make(),
//                                         10.heightBox,
//                                         "\$600".text
//                                             .color(redColor)
//                                             .fontFamily(bold)
//                                             .size(16)
//                                             .make(),
//                                       ],
//                                     ).box.white
//                                     .margin(EdgeInsets.symmetric(horizontal: 4))
//                                     .roundedSM
//                                     .padding(const EdgeInsets.all(8))
//                                     .make(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: double.infinity,
//               height: 60,
//               child: ourButton(
//                 color: redColor,
//                 onPress: () {
//                   if (controller.quantity.value > 0) {
//                     controller.addCart(
//                       color: data['P_colors'][controller.colorIndex.value],
//                       context: context,
//                       vendorID: data['vendor_id'],
//                       img: data['P_imgs'][0],
//                       qty: controller.quantity.value,
//                       sellername: data['P_seller'],
//                       title: data['P_name'],
//                       tprice: controller.totalprice.value,
//                     );
//                     VxToast.show(context, msg: "Added to cart");
//                   } else {
//                     VxToast.show(context, msg: "Minimum 1 product is requried");
//                   }
//                 },
//                 textcolor: whiteColor,
//                 title: "Add to",
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
