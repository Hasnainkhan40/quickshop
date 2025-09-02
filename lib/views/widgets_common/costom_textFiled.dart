import 'package:quickshop/consts/consts.dart';

Widget costomTextField({String? title, String? hint, controller, isPass}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(Colors.black).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
        obscureText: isPass,
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: semibold,
            fontSize: 14,
            color: textfieldGrey,
          ),

          isDense: true,
          fillColor: lightGrey,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), // rounded corners
            borderSide: BorderSide(color: Colors.black, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
        ),
      ),
      5.heightBox,
    ],
  );
}

// import 'package:quickshop/consts/consts.dart';
// import 'package:flutter/material.dart';

// Widget costomTextField({
//   required String title,
//   required String hint,
//   required TextEditingController controller,
//   bool isPass = false,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         title,
//         style: const TextStyle(
//           fontFamily: semibold,
//           fontSize: 14,
//           color: Colors.black,
//         ),
//       ),
//       8.heightBox,
//       TextFormField(
//         controller: controller,
//         obscureText: isPass,
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(
//             fontFamily: semibold,
//             fontSize: 14,
//             color: textfieldGrey,
//           ),
//           filled: true,
//           fillColor: lightGrey, // soft background
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12), // rounded corners
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: redColor, width: 1.2),
//           ),
//         ),
//       ),
//       12.heightBox,
//     ],
//   );
// }
