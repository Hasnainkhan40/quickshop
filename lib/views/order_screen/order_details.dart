// import 'package:quickshop/consts/consts.dart';
// import 'package:quickshop/views/order_screen/componets/order_placed_details.dart';
// import 'package:quickshop/views/order_screen/componets/order_status.dart';
// import 'package:intl/intl.dart' as intl;

// class OrderDetails extends StatelessWidget {
//   final dynamic data;
//   const OrderDetails({super.key, this.data});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: lightGrey,
//       appBar: AppBar(
//         elevation: 0,
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),

//         title: const Text(
//           "Orders Details",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               orderStatus(
//                 color: redColor,
//                 icon: Icons.done,
//                 title: "Order Placed",
//                 showDone: data['order_placed'],
//               ),
//               orderStatus(
//                 color: Colors.blue,
//                 icon: Icons.thumb_up,
//                 title: "Confirmed",
//                 showDone: data['order_confirmed'],
//               ),

//               orderStatus(
//                 color: Colors.yellow,
//                 icon: Icons.car_crash,
//                 title: "On Delivery",
//                 showDone: data['order_on_delivery'],
//               ),
//               orderStatus(
//                 color: Colors.purple,
//                 icon: Icons.done_all_rounded,
//                 title: "Delivery",
//                 showDone: data['order_delivered'],
//               ),
//               const Divider(),
//               10.heightBox,
//               Column(
//                 children: [
//                   orderPlaceDetails(
//                     d1: data['order_code'],
//                     d2: data['shipping_method'],
//                     title1: "Order Code",
//                     title2: "shipping Method",
//                   ),
//                   orderPlaceDetails(
//                     d1: intl.DateFormat().add_yMd().format(
//                       (data['order_date'].toDate()),
//                     ),
//                     d2: data['payment_method'],
//                     title1: "Order Date",
//                     title2: "Payment Method",
//                   ),
//                   orderPlaceDetails(
//                     d1: "Unpaid",
//                     d2: "Order Placed",
//                     title1: "Payment Status",
//                     title2: "Delivery Status",
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 8,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             "Shipping Address".text.fontFamily(semibold).make(),
//                             "${data['order_by_name']}".text.make(),
//                             "${data['order_by_email']}".text.make(),
//                             "${data['order_by_address']}".text.make(),
//                             "${data['order_by_city']}".text.make(),
//                             "${data['order_by_state']}".text.make(),
//                             "${data['order_by_phone']}".text.make(),
//                             "${data['order_by_postalcode']}".text.make(),
//                           ],
//                         ),
//                         SizedBox(
//                           width: 130,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               "Total Amount".text.fontFamily(semibold).make(),
//                               "${data['total_amount']}".text
//                                   .color(redColor)
//                                   .fontFamily(bold)
//                                   .make(),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ).box.outerShadowMd.white.make(),
//               const Divider(),
//               10.heightBox,
//               "Orderred Product".text
//                   .size(16)
//                   .color(darkFontGrey)
//                   .fontFamily(semibold)
//                   .makeCentered(),
//               10.heightBox,
//               ListView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     children:
//                         List.generate(data['orders'].length, (index) {
//                           return Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               orderPlaceDetails(
//                                 title1: data['orders'][index]['title'],
//                                 title2: data['orders'][index]['tprice'],
//                                 d1: "${data['orders'][index]['qty']}x",
//                                 d2: "Refundable",
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                 ),
//                                 child: Container(
//                                   width: 30,
//                                   height: 20,
//                                   color: Color(data['orders'][index]['color']),
//                                 ),
//                               ),
//                               20.heightBox,
//                             ],
//                           );
//                         }).toList(),
//                   ).box.outerShadowMd.white
//                   .margin(const EdgeInsets.only(bottom: 4))
//                   .make(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/views/order_screen/componets/order_placed_details.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double getProgress() {
    int completed = 0;
    if (widget.data['order_placed'] == true) completed++;
    if (widget.data['order_confirmed'] == true) completed++;
    if (widget.data['order_on_delivery'] == true) completed++;
    if (widget.data['order_delivered'] == true) completed++;
    return completed / 4;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Order Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modern Animated Order Status Timeline
            Card(
              color: whiteColor,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, _) {
                    double progress = getProgress() * _progressAnimation.value;
                    return Row(
                      children: [
                        _animatedStep(
                          "Placed",
                          Icons.check,
                          data['order_placed'],
                          redColor,
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress >= 0.25 ? 1 : 0,
                            backgroundColor: Colors.grey[300],
                            color: redColor,
                            minHeight: 4,
                          ),
                        ),
                        _animatedStep(
                          "Confirmed",
                          Icons.thumb_up,
                          data['order_confirmed'],
                          Colors.blue,
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress >= 0.5 ? 1 : 0,
                            backgroundColor: Colors.grey[300],
                            color: Colors.blue,
                            minHeight: 4,
                          ),
                        ),
                        _animatedStep(
                          "On Delivery",
                          Icons.local_shipping,
                          data['order_on_delivery'],
                          Colors.orange,
                        ),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress >= 0.75 ? 1 : 0,
                            backgroundColor: Colors.grey[300],
                            color: Colors.orange,
                            minHeight: 4,
                          ),
                        ),
                        _animatedStep(
                          "Delivered",
                          Icons.done_all_rounded,
                          data['order_delivered'],
                          Colors.purple,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Modern Order & Shipping Details Card
            Card(
              color: whiteColor,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.grey.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    orderPlaceDetails(
                      d1: data['order_code'],
                      d2: data['shipping_method'],
                      title1: "Order Code",
                      title2: "Shipping Method",
                    ),
                    const SizedBox(height: 12),
                    orderPlaceDetails(
                      d1: intl.DateFormat.yMMMd().format(
                        data['order_date'].toDate(),
                      ),
                      d2: data['payment_method'],
                      title1: "Order Date",
                      title2: "Payment Method",
                    ),
                    const SizedBox(height: 12),
                    orderPlaceDetails(
                      d1: "Unpaid",
                      d2: "Order Placed",
                      title1: "Payment Status",
                      title2: "Delivery Status",
                    ),
                    const Divider(height: 24, thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Shipping Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text("${data['order_by_name']}"),
                              Text("${data['order_by_email']}"),
                              Text("${data['order_by_address']}"),
                              Text("${data['order_by_city']}"),
                              Text("${data['order_by_state']}"),
                              Text("${data['order_by_phone']}"),
                              Text("${data['order_by_postalcode']}"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Total Amount",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "${data['total_amount']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: redColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Ordered Products Section with Fade & Slide Animation
            Text(
              "Ordered Products",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data['orders'].length,
              itemBuilder: (context, index) {
                final product = data['orders'][index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 500 + 100 * index),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(50 * (1 - value), 0),
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    color: whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Color Box
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(product['color']),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${product['title']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${product['qty']} x ${product['tprice']}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Refundable",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Modern Animated Status Step
  Widget _animatedStep(
    String title,
    IconData icon,
    bool completed,
    Color color,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: completed ? color : Colors.grey[300],
          child: Icon(
            completed ? icon : Icons.radio_button_unchecked,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
