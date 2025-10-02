import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/cart_controller.dart';
import 'package:quickshop/controller/product_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/cart_screen/shipping_screen.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    var controller2 = Get.put(ProductController());

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: lightGrey,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
        ) {
          if (!snapshot.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Cart is empty",
                style: TextStyle(color: Colors.black54),
              ),
            );
          } else {
            var data = snapshot.data!.docs;

            controller.calculate(data);
            controller.productSnapshot = data;

            return Column(
              children: [
                // CART ITEMS LIST
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      var item = data[index];
                      final m = item.data();

                      final img = (m['img'] as String?) ?? '';
                      final title = (m['title'] as String?) ?? 'Untitled';
                      final category = (m['category'] as String?) ?? '';
                      final price = (m['tprice'] as num?)?.toDouble() ?? 0.0;
                      final qty = (m['qty'] as num?)?.toInt() ?? 1;

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child:
                                  img.isNotEmpty
                                      ? Image.network(
                                        img,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(
                                        width: 70,
                                        height: 70,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          color: Colors.white70,
                                        ),
                                      ),
                            ),
                            const SizedBox(width: 12),

                            // Product details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "\$$price",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Delete + Quantity
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: orangeColor,
                                  ),
                                  onPressed: () {
                                    FirestoreServices.deleteDocument(item.id);
                                  },
                                ),
                                Row(
                                  children: [
                                    _qtyButton(
                                      icon: Icons.remove,
                                      onTap: () {
                                        // controller.decreaseQty(item);
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "$qty",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _qtyButton(
                                      icon: Icons.add,
                                      onTap: () {
                                        // controller.increaseQty(item);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // DISCOUNT + TOTAL + CHECKOUT
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildPriceRow(
                        "Subtotal",
                        "\$${controller.totalp.value.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        "Total",
                        "\$${controller.totalp.value.toStringAsFixed(2)}",
                        isTotal: true,
                      ),
                      const SizedBox(height: 20),

                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ourButton(
                          color: orangeColor,
                          onPress: () {
                            Get.to(() => const ShippingScreen());
                          },
                          textcolor: whiteColor,
                          title: "Proceed To Shipping",
                        ),
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ).box.shadow.make(),
              ],
            );
          }
        },
      ),
    );
  }

  // Qty button
  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  // Price row
  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }
}
