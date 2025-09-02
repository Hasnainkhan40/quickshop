import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/cart_controller.dart';
import 'package:quickshop/payment/payment_service.dart';
import 'package:quickshop/views/widgets_common/costom_textFiled.dart';
import 'package:quickshop/views/widgets_common/massage.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            "Shipping info".text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () async {
            final address = controller.addressController.text.trim();
            final totalAmount = controller.totalp.value;

            if (address.length <= 10) {
              //VxToast.show(context, msg: "Please fill the form");
              showModernToast(context, "Please fill the form");
              return;
            }

            try {
              // convert total amount
              final amount = totalAmount.toStringAsFixed(0);

              // make stripe payment and get result
              final paymentResult = await PaymentService().makePayment(
                int.parse(amount),
                "USD",
              );

              if (paymentResult == null || paymentResult == "incomplete") {
                VxToast.show(
                  // ignore: use_build_context_synchronously
                  context,
                  msg: "⚠️ You have not filled Stripe payment method",
                );
                return; // stop here, don't place order
              }

              if (paymentResult == "canceled") {
                // ignore: use_build_context_synchronously
                //VxToast.show(context, msg: "❌ Payment was canceled");
                showModernToast(context, "❌ Payment was canceled");
                return;
              }

              //only if payment success → place order
              await controller.placeMyOrder(
                orderPaymentMethod:
                    paymentMethods[controller.paymentIndex.value],
                totalAmount: totalAmount,
              );

              // clear cart
              await controller.clearCart();

              // ignore: use_build_context_synchronously
              //VxToast.show(context, msg: "Order placed successfully ✅");
              showModernToast(context, "Order placed successfully ✅");
            } catch (e) {
              // ignore: use_build_context_synchronously
              // VxToast.show(context, msg: "Payment failed: $e");
              showModernToast(context, "Payment failed: $e");
            }
          },
          color: orangeColor,
          textcolor: whiteColor,
          title: "Place my order",
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            costomTextField(
              hint: "Address",
              isPass: false,
              title: "Address",
              controller: controller.addressController,
            ),
            costomTextField(
              hint: "City",
              isPass: false,
              title: "City",
              controller: controller.cityController,
            ),

            costomTextField(
              hint: "State",
              isPass: false,
              title: "State",
              controller: controller.stateController,
            ),
            costomTextField(
              hint: "Postal Code",
              isPass: false,
              title: "Postal Code",
              controller: controller.postalcodeController,
            ),
            costomTextField(
              hint: "Phone",
              isPass: false,
              title: "Phone",
              controller: controller.phoneController,
            ),
          ],
        ),
      ),
    );
  }
}
