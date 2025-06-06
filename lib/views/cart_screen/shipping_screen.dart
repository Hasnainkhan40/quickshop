import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/cart_controller.dart';
import 'package:quickshop/views/cart_screen/payment_method.dart';
import 'package:quickshop/views/widgets_common/costom_textFiled.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "Shipping info".text
                .fontFamily(semibold)
                .color(darkFontGrey)
                .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text.length > 10) {
              Get.to(() => PaymentScreene());
            } else {
              VxToast.show(context, msg: "Please fill the from");
            }
          },
          color: redColor,
          textcolor: whiteColor,
          title: "Countinue",
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            costomTextField(
              hint: "Address",
              isPass: false,
              titel: "Address",
              controller: controller.addressController,
            ),
            costomTextField(
              hint: "City",
              isPass: false,
              titel: "City",
              controller: controller.cityController,
            ),

            costomTextField(
              hint: "State",
              isPass: false,
              titel: "State",
              controller: controller.phoneController,
            ),
            costomTextField(
              hint: "Postal Code",
              isPass: false,
              titel: "Postal Code",
              controller: controller.postalcodeController,
            ),
            costomTextField(
              hint: "Phone",
              isPass: false,
              titel: "Phone",
              controller: controller.phoneController,
            ),
          ],
        ),
      ),
    );
  }
}
