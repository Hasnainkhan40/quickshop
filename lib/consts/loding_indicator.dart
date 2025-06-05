import 'package:quickshop/consts/consts.dart';

Widget lodingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}
