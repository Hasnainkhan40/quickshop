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
      body: StreamBuilder(
        stream: FirestoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No profile data found",
                style: TextStyle(color: whiteColor),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Hello, Welcome 👋",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              data['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            data['imageUrl'],
                          ), // Replace with user profile
                        ),
                      ],
                    ),
                  ),

                  /// 🔎 Search Bar + Icons Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
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
                                  .margin(
                                    const EdgeInsets.symmetric(horizontal: 8),
                                  )
                                  .make();
                            },
                          ),

                          const SizedBox(height: 16),

                          ///Category row (circle icons)
                          SizedBox(
                            height: 90,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                _categoryItem(
                                  "Shoes",
                                  "assets/images/shose-logs.jpg",
                                  double.infinity,
                                ),
                                _categoryItem(
                                  "Beauty",
                                  "assets/images/p2.jpeg",
                                  double.infinity,
                                ),
                                _categoryItem(
                                  "Womens Fashion",
                                  "assets/images/Womens-Clothing.jpg",
                                  double.infinity,
                                ),
                                _categoryItem(
                                  "jewellers",
                                  "assets/images/jewellers.jpg",
                                  double.infinity,
                                ),
                                _categoryItem(
                                  "Men Fashion",
                                  "assets/images/man-Clothing.jpg",
                                  double.infinity,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

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

                          /// Special product cards
                          SizedBox(
                            height: 500,
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
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.7,
                                      ),
                                  itemBuilder: (context, index) {
                                    return _productCard(
                                      context: context,
                                      data: allproductsdata[index],
                                      name: allproductsdata[index]['P_name'],
                                      price:
                                          allproductsdata[index]['P_price']
                                              .toString(),
                                      image:
                                          allproductsdata[index]['P_imgs'][0],
                                      onTap: () {
                                        Get.to(
                                          () => ItemDetails(
                                            title:
                                                allproductsdata[index]['P_name'],
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
            );
          }
        },
      ),
    );
  }

  /// Circle icon (for top right actions)
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

  /// Category Item
  Widget _categoryItem(String title, String iconPath, double isHight) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(
              iconPath,
              height: 56,
              width: 56,
              fit: BoxFit.cover,
            ),
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

  //Product Card
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
                Obx(
                  () => Positioned(
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
                              : Icons.favorite_border,
                          color:
                              controller.isFav.value
                                  ? Colors.orange
                                  : Colors.red,
                        ),
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
