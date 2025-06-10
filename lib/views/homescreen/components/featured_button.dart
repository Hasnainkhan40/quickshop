import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/views/category_Screen/categoryScreen.dart';
import 'package:quickshop/views/category_Screen/category_details.dart';

Widget featuredButton({String? title, icon}) {
  return Row(
        children: [
          Image.asset(icon, width: 60, fit: BoxFit.fill),
          10.widthBox,
          title!.text.fontFamily(semibold).color(darkFontGrey).make(),
        ],
      ).box
      .width(200)
      .margin(EdgeInsets.symmetric(horizontal: 4))
      .white
      .padding(const EdgeInsets.all(4))
      .roundedSM
      .outerShadowSm
      .make()
      .onTap(() {
        Get.to(() => CategoryDetails(title: title));
      });
}
