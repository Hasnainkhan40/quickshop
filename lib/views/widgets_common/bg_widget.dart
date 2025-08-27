import 'package:quickshop/consts/consts.dart';

Widget bgWidget(Widget? child) {
  return Container(
    color: lightGrey,
    // decoration: const BoxDecoration(
    //   image: DecorationImage(
    //     image: AssetImage(imgBackground),
    //     fit: BoxFit.fill,
    //   ),
    // ),
    child: child,
  );
}
