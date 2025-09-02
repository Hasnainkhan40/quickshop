import 'package:quickshop/consts/consts.dart';

Widget bgWidget(Widget? child) {
  return Container(
    color: lightGrey,
    // decoration: const BoxDecoration(
    //   // image: DecorationImage(
    //   //   image: AssetImage("assets/images/white-wave.png"),
    //   //   //white-wave.png
    //   //   fit: BoxFit.fill,
    //   // ),
    // ),
    child: child,
  );
}
