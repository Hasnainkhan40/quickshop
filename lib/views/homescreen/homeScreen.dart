import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/home_controller.dart';
import 'package:quickshop/controller/product_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/cart_screen/cartScreen.dart';
import 'package:quickshop/views/category_Screen/item_details.dart';
import 'package:quickshop/views/homescreen/searchScreen.dart';
import 'package:quickshop/consts/loding_indicator.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        "Hello, Welcome 👋",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Albert Stevano",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ), // Replace with user profile
                  ),
                ],
              ),
            ),

            /// 🔎 Search Bar + Icons Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: "Search...",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            Get.to(() => Searchscreen(title: value));
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _circleIcon(Icons.notifications_none),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CartScreen());
                    },
                    child: _circleIcon(Icons.shopping_cart_outlined),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            /// Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🟧 Banner (Swiper can be added later)
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(12),
                    //     child: Image.asset(
                    //       "assets/images/slider_2.png", // replace with your asset
                    //       fit: BoxFit.cover,
                    //       // height: 180,
                    //       width: double.infinity,
                    //     ),
                    //   ),
                    // ),

                    //swipers brands
                    VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 180,

                      enlargeCenterPage: true,
                      itemCount: secondSlidersList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                              secondSlidersList[index],
                              fit: BoxFit.fill,
                            ).box.rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 8))
                            .make();
                      },
                    ),

                    const SizedBox(height: 16),

                    /// 🔘 Category row (circle icons)
                    SizedBox(
                      height: 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _categoryItem("Shoes", "assets/icons/categories.png"),
                          _categoryItem(
                            "Beauty",
                            "assets/icons/categories.png",
                          ),
                          _categoryItem(
                            "Fashion",
                            "assets/icons/categories.png",
                          ),
                          _categoryItem(
                            "Jewelry",
                            "assets/icons/categories.png",
                          ),
                          _categoryItem("Men", "assets/icons/categories.png"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// 🛒 "Special For You" Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Special For You",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "See all",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// 🎁 Special product cards
                    SizedBox(
                      height: 500, // increase height for grid rows
                      child: StreamBuilder(
                        stream: FirestoreServices.allproducts(),
                        builder: (
                          context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                          if (!snapshot.hasData) {
                            return Center(child: lodingIndicator());
                          }
                          var allproductsdata = snapshot.data!.docs;
                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: allproductsdata.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 products in a row
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio:
                                      0.7, // control card height/width
                                ),
                            itemBuilder: (context, index) {
                              return _productCard(
                                context: context,
                                data: allproductsdata[index],
                                name: allproductsdata[index]['P_name'],
                                price:
                                    allproductsdata[index]['P_price']
                                        .toString(),
                                image: allproductsdata[index]['P_imgs'][0],
                                onTap: () {
                                  Get.to(
                                    () => ItemDetails(
                                      title: allproductsdata[index]['P_name'],
                                      data: allproductsdata[index],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /// ✅ Keep your own Bottom Navigation (not from example)
    );
  }

  /// 🔘 Circle icon (for top right actions)
  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black12,
      ),
      child: Icon(icon, color: Colors.black87, size: 22),
    );
  }

  /// 🏷️ Category Item
  Widget _categoryItem(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.orange[50],
            child: Image.asset(iconPath, height: 28),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// 🛍 Product Card
  /// 🛍 Modern Product Card
  /// 🛍 Modern Product Card
  Widget _productCard({
    required String name,
    required String price,
    required String image,
    required VoidCallback onTap,
    required dynamic data,
    required context,
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
                  child: GestureDetector(
                    onTap: () {
                      if (controller.isFav.value) {
                        controller.removeToWishlist(data.id, context);
                      } else {
                        controller.addToWishlist(data.id, context);
                      }
                    },
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
                            ? Icons.favorite_border_outlined
                            : Icons.favorite_border_outlined,
                        color:
                            controller.isFav.value ? Colors.orange : Colors.red,
                      ),
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

// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import 'package:get/utils.dart';
// import 'package:quickshop/consts/consts.dart';
// import 'package:quickshop/consts/list.dart';
// import 'package:quickshop/consts/loding_indicator.dart';
// import 'package:quickshop/controller/home_controller.dart';
// import 'package:quickshop/services/firestore_services.dart';
// import 'package:quickshop/views/category_Screen/item_details.dart';
// import 'package:quickshop/views/homescreen/components/featured_button.dart';
// import 'package:quickshop/views/homescreen/searchScreen.dart';
// import 'package:quickshop/views/widgets_common/home_buttons.dart';

// class Homescreen extends StatelessWidget {
//   const Homescreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<HomeController>();
//     return Container(
//       padding: const EdgeInsets.all(12),
//       color: Color(0xFFF9F9F9),
//       width: context.screenWidth,
//       height: context.screenHeight,
//       child: SafeArea(
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     SizedBox(height: 20),
//                     Text(
//                       "Hello, Welcome 👋",
//                       style: TextStyle(fontSize: 14, color: Colors.grey),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "Albert Stevano",
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const CircleAvatar(
//                   radius: 25,
//                   backgroundImage: NetworkImage(
//                     "https://i.pravatar.cc/150?img=3",
//                   ), // Replace with user profile
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Container(
//               alignment: Alignment.center,
//               height: 60,

//               child: TextFormField(
//                 controller: controller.searchController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide: BorderSide.none,
//                   ),
//                   suffixIcon: Icon(Icons.search).onTap(() {
//                     if (controller.searchController.text.isNotEmptyAndNotNull) {
//                       Get.to(
//                         () => Searchscreen(
//                           title: controller.searchController.text,
//                         ),
//                       );
//                     }
//                   }),
//                   filled: true,
//                   fillColor: whiteColor,
//                   hintText: searchanything,
//                   hintStyle: TextStyle(color: textfieldGrey),
//                 ),
//               ),
//             ),
//             //swipers brands
//             10.heightBox,
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   children: [
//                     VxSwiper.builder(
//                       aspectRatio: 16 / 9,
//                       autoPlay: true,
//                       height: 180,
//                       enlargeCenterPage: true,
//                       itemCount: slidersList.length,
//                       itemBuilder: (context, index) {
//                         return Image.asset(slidersList[index], fit: BoxFit.fill)
//                             .box
//                             .rounded
//                             .clip(Clip.antiAlias)
//                             .margin(const EdgeInsets.symmetric(horizontal: 8))
//                             .make();
//                       },
//                     ),
//                     10.heightBox,
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     //   children: List.generate(
//                     //     3,
//                     //     (index) => homeButtons(
//                     //       height: context.screenHeight * 0.15,
//                     //       width: context.screenWidth / 3.5,
//                     //       icon:
//                     //           index == 0
//                     //               ? icTopCategories
//                     //               : index == 1
//                     //               ? icBrands
//                     //               : icTodaysDeal,
//                     //       title:
//                     //           index == 0
//                     //               ? topCategories
//                     //               : index == 1
//                     //               ? brand
//                     //               : topSellers,
//                     //     ),
//                     //   ),
//                     // ),
//                     SizedBox(
//                       height: 40,
//                       child: ListView(
//                         scrollDirection: Axis.horizontal,
//                         children: [
//                           _buildFilterChip("All Items", true),
//                           const SizedBox(width: 8),
//                           _buildFilterChip("Dress", false),
//                           const SizedBox(width: 8),
//                           _buildFilterChip("T-Shirt", false),
//                           const SizedBox(width: 8),
//                           _buildFilterChip("T-Shirt", false),
//                           const SizedBox(width: 8),
//                           _buildFilterChip("T-Shirt", false),
//                           const SizedBox(width: 8),
//                           _buildFilterChip("T-Shirt", false),
//                           const SizedBox(width: 8),
//                           _buildFilterChip("T-Shirt", false),
//                         ],
//                       ),
//                     ),
//                     10.heightBox,
//                     // VxSwiper.builder(
//                     //   aspectRatio: 16 / 9,
//                     //   autoPlay: true,
//                     //   height: 150,
//                     //   enlargeCenterPage: true,
//                     //   itemCount: secondSlidersList.length,
//                     //   itemBuilder: (context, index) {
//                     //     return Image.asset(
//                     //           secondSlidersList[index],
//                     //           fit: BoxFit.fill,
//                     //         ).box.rounded
//                     //         .clip(Clip.antiAlias)
//                     //         .margin(const EdgeInsets.symmetric(horizontal: 8))
//                     //         .make();
//                     //   },
//                     // ),
//                     // //category buttons
//                     // 10.heightBox,
//                     // Row(
//                     //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     //   children: List.generate(
//                     //     3,
//                     //     (index) => homeButtons(
//                     //       height: context.screenHeight * 0.15,
//                     //       width: context.screenWidth / 3.5,
//                     //       icon:
//                     //           index == 0
//                     //               ? icTopCategories
//                     //               : index == 1
//                     //               ? icBrands
//                     //               : icTodaysDeal,
//                     //       title:
//                     //           index == 0
//                     //               ? topCategories
//                     //               : index == 1
//                     //               ? brand
//                     //               : topSellers,
//                     //     ),
//                     //   ),
//                     // ),
//                     // //featured categorys
//                     // 20.heightBox,
//                     // Align(
//                     //   alignment: Alignment.centerLeft,
//                     //   child:
//                     //       featuredCategories.text
//                     //           .color(darkFontGrey)
//                     //           .size(18)
//                     //           .fontFamily(semibold)
//                     //           .make(),
//                     // ),
//                     // 20.heightBox,
//                     // SingleChildScrollView(
//                     //   scrollDirection: Axis.horizontal,
//                     //   child: Row(
//                     //     children: List.generate(
//                     //       3,
//                     //       (index) => Column(
//                     //         children: [
//                     //           featuredButton(
//                     //             icon: featuredImages1[index],
//                     //             title: featuredTitles1[index],
//                     //           ),
//                     //           10.heightBox,
//                     //           featuredButton(
//                     //             icon: featuredImages2[index],
//                     //             title: featuredTitles2[index],
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                     // //featured product
//                     // 20.heightBox,
//                     // Container(
//                     //   padding: const EdgeInsets.all(12),
//                     //   width: double.infinity,
//                     //   decoration: const BoxDecoration(color: redColor),
//                     //   child: Column(
//                     //     crossAxisAlignment: CrossAxisAlignment.start,
//                     //     children: [
//                     //       fearturedProduct.text.white
//                     //           .fontFamily(bold)
//                     //           .size(18)
//                     //           .make(),
//                     //       10.heightBox,
//                     //       SingleChildScrollView(
//                     //         scrollDirection: Axis.horizontal,
//                     //         child: FutureBuilder(
//                     //           future: FirestoreServices.getFeaturedProduct(),
//                     //           builder: (
//                     //             context,
//                     //             AsyncSnapshot<QuerySnapshot> snapshot,
//                     //           ) {
//                     //             if (!snapshot.hasData) {
//                     //               return Center(child: lodingIndicator());
//                     //             } else if (snapshot.data!.docs.isEmpty) {
//                     //               return "No featured product..".text.white
//                     //                   .makeCentered();
//                     //             } else {
//                     //               var featuredData = snapshot.data!.docs;
//                     //               return Row(
//                     //                 children: List.generate(
//                     //                   featuredData.length,
//                     //                   (index) => Column(
//                     //                         crossAxisAlignment:
//                     //                             CrossAxisAlignment.start,
//                     //                         children: [
//                     //                           Image.network(
//                     //                             featuredData[index]['P_imgs'][0],
//                     //                             width: 130,
//                     //                             height: 130,
//                     //                             fit: BoxFit.cover,
//                     //                           ),
//                     //                           10.heightBox,
//                     //                           "${featuredData[index]['P_name']}"
//                     //                               .text
//                     //                               .fontFamily(semibold)
//                     //                               .color(darkFontGrey)
//                     //                               .make(),
//                     //                           10.heightBox,
//                     //                           "${featuredData[index]['P_price']}"
//                     //                               .numCurrency
//                     //                               .text
//                     //                               .color(redColor)
//                     //                               .fontFamily(bold)
//                     //                               .size(16)
//                     //                               .make(),
//                     //                         ],
//                     //                       ).box.white
//                     //                       .margin(
//                     //                         EdgeInsets.symmetric(horizontal: 4),
//                     //                       )
//                     //                       .roundedSM
//                     //                       .padding(const EdgeInsets.all(8))
//                     //                       .make()
//                     //                       .onTap(() {
//                     //                         Get.to(
//                     //                           () => ItemDetails(
//                     //                             title:
//                     //                                 "${featuredData[index]['P_name']}",
//                     //                             data: featuredData[index],
//                     //                           ),
//                     //                         );
//                     //                       }),
//                     //                 ),
//                     //               );
//                     //             }
//                     //           },
//                     //         ),
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     // 20.heightBox,
//                     // VxSwiper.builder(
//                     //   aspectRatio: 16 / 9,
//                     //   autoPlay: true,
//                     //   height: 150,
//                     //   enlargeCenterPage: true,
//                     //   itemCount: secondSlidersList.length,
//                     //   itemBuilder: (context, index) {
//                     //     return Image.asset(
//                     //           secondSlidersList[index],
//                     //           fit: BoxFit.fill,
//                     //         ).box.rounded
//                     //         .clip(Clip.antiAlias)
//                     //         .margin(const EdgeInsets.symmetric(horizontal: 8))
//                     //         .make();
//                     //   },
//                     // ),
//                     //all Product sections
//                     20.heightBox,
//                     StreamBuilder(
//                       stream: FirestoreServices.allproducts(),
//                       builder: (
//                         BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot,
//                       ) {
//                         if (!snapshot.hasData) {
//                           return Center(child: lodingIndicator());
//                         } else {
//                           var allproductsdata = snapshot.data!.docs;
//                           return GridView.builder(
//                             physics: const NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             itemCount: allproductsdata.length,
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   mainAxisSpacing: 10,
//                                   crossAxisSpacing: 2,
//                                   mainAxisExtent: 230,
//                                 ),
//                             itemBuilder: (context, index) {
//                               return Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Image.network(
//                                             "${allproductsdata[index]['P_imgs'][0]}",
//                                             height: 150,
//                                             width: 180,
//                                             fit: BoxFit.cover,
//                                           ).box.roundedSM
//                                           .color(Color(0xFFE0E0E0))
//                                           .make(),
//                                       // const Spacer(),
//                                       2.heightBox,
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 5),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             "${allproductsdata[index]['P_name']}"
//                                                 .text
//                                                 .fontFamily(regular)
//                                                 .size(20)
//                                                 .color(Color(0xFF1E1E1E))
//                                                 .make(),
//                                             4.heightBox,
//                                             "\$${allproductsdata[index]['P_price']}"
//                                                 .text
//                                                 .color(Color(0xFF1E1E1E))
//                                                 .fontFamily(bold)
//                                                 .size(20)
//                                                 .make(),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ).box.white
//                                   .margin(EdgeInsets.symmetric(horizontal: 4))
//                                   .roundedSM
//                                   .outerShadowSm
//                                   .make()
//                                   .onTap(() {
//                                     Get.to(
//                                       () => ItemDetails(
//                                         title:
//                                             "${allproductsdata[index]['P_name']}",
//                                         data: allproductsdata[index],
//                                       ),
//                                     );
//                                   });
//                             },
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // 🔹 Category Filter Chip Widget
// Widget _buildFilterChip(String label, bool isSelected) {
//   return Container(
//     height: 12,
//     width: 100,
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       color: isSelected ? Colors.black : Color(0xFFE0E0E0),
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: Colors.grey.shade300),
//     ),
//     child: Center(
//       child: Text(
//         label,
//         style: TextStyle(
//           color: isSelected ? Color(0xFFE0E0E0) : Colors.black,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     ),
//   );
// }
