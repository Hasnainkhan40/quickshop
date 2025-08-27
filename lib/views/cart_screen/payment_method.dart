import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/cart_controller.dart';
import 'package:quickshop/views/homescreen/home.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class PaymentScreene extends StatelessWidget {
  const PaymentScreene({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();

    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child:
              controller.placingOrder.value
                  ? Center(child: lodingIndicator())
                  : ourButton(
                    onPress: () async {
                      await controller.placeMyOrder(
                        orderPaymentMethod:
                            paymentMethods[controller.paymentIndex.value],
                        totalAmount: controller.totalp.value,
                      );
                      await controller.clearCart();
                      VxToast.show(context, msg: "Order placed successfuly");
                      Get.offAll(Homes());
                    },
                    color: orangeColor,
                    textcolor: whiteColor,
                    title: "Place my order",
                  ),
        ),

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),

          title: const Text(
            "Choose Payment Method",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(paymentMethodsimg.length, (index) {
                return GestureDetector(
                  onTap: () {
                    controller.chanagePaymentIndex(index);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            controller.paymentIndex.value == index
                                ? redColor
                                : Colors.transparent,
                        width: 4,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.asset(
                          paymentMethodsimg[index],
                          width: double.infinity,
                          height: 120,
                          colorBlendMode:
                              controller.paymentIndex.value == index
                                  ? BlendMode.darken
                                  : BlendMode.color,
                          color:
                              controller.paymentIndex.value == index
                                  ? Colors.black.withOpacity(0.4)
                                  : Colors.transparent,
                          fit: BoxFit.cover,
                        ),
                        controller.paymentIndex.value == index
                            ? Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                activeColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                value: true,
                                onChanged: (value) {},
                              ),
                            )
                            : Container(),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child:
                              paymentMethods[index].text.white
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
