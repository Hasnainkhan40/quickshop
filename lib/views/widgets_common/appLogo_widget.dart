import 'package:quickshop/consts/consts.dart';

Widget appLogoWidget() {
  //using velocity x hear
  return Image.asset(
    icAppLogo,
  ).box.white.size(77, 77).padding(const EdgeInsets.all(8)).rounded.make();
}
