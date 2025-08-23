import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/home_controller.dart';
import 'package:quickshop/views/cart_screen/cartScreen.dart';
import 'package:quickshop/views/category_Screen/categoryScreen.dart';
import 'package:quickshop/views/homescreen/homeScreen.dart';
import 'package:quickshop/views/profile_screen/profileScreen.dart';
import 'package:quickshop/views/widgets_common/exit_dailog.dart';

class Homes extends StatelessWidget {
  const Homes({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    var navBody = const [
      Homescreen(),
      Categoryscreen(),
      CartScreen(),
      Profilescreen(),
    ];

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: Obx(() => navBody[controller.currentNavIndex.value]),

        /// ✅ Custom Modern Bottom Nav Bar
        bottomNavigationBar: Obx(
          () => Container(
            height: 65,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  label: "Home",
                  image: icHome,
                  isActive: controller.currentNavIndex.value == 0,
                  onTap: () => controller.currentNavIndex.value = 0,
                ),
                _buildNavItem(
                  label: "Categories",
                  image: icCategories,
                  isActive: controller.currentNavIndex.value == 1,
                  onTap: () => controller.currentNavIndex.value = 1,
                ),
                _buildNavItem(
                  label: "Cart",
                  image: icCart,
                  isActive: controller.currentNavIndex.value == 2,
                  onTap: () => controller.currentNavIndex.value = 2,
                ),
                _buildNavItem(
                  label: "Account",
                  image: icProfile,
                  isActive: controller.currentNavIndex.value == 3,
                  onTap: () => controller.currentNavIndex.value = 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Custom Nav Item Widget (active → pill shape with label, inactive → icon only)
  Widget _buildNavItem({
    required String image,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: isActive ? 16 : 0,
        ),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              image,
              width: 22,
              color: isActive ? Colors.white : Colors.grey.shade500,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: semibold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:quickshop/consts/consts.dart';
// import 'package:quickshop/controller/home_controller.dart';
// import 'package:quickshop/views/cart_screen/cartScreen.dart';
// import 'package:quickshop/views/category_Screen/categoryScreen.dart';
// import 'package:quickshop/views/homescreen/homeScreen.dart';
// import 'package:quickshop/views/profile_screen/profileScreen.dart';
// import 'package:quickshop/views/widgets_common/exit_dailog.dart';

// class Homes extends StatelessWidget {
//   const Homes({super.key});
//   @override
//   Widget build(BuildContext context) {
//     //init home controller
//     var controller = Get.put(HomeController());

//     var navbarItem = [
//       BottomNavigationBarItem(
//         icon: Image.asset(icHome, width: 26),
//         label: home,
//       ),
//       BottomNavigationBarItem(
//         icon: Image.asset(icCategories, width: 26),
//         label: categories,
//       ),
//       BottomNavigationBarItem(
//         icon: Image.asset(icCart, width: 26),
//         label: cart,
//       ),
//       BottomNavigationBarItem(
//         icon: Image.asset(icProfile, width: 26),
//         label: account,
//       ),
//     ];

//     var navBody = [
//       const Homescreen(),
//       const Categoryscreen(),
//       const Cartscreen(),
//       const Profilescreen(),
//     ];

//     return WillPopScope(
//       onWillPop: () async {
//         showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (context) => exitDialog(context),
//         );
//         return false;
//       },
//       child: Scaffold(
//         body: Column(
//           children: [
//             Obx(
//               () => Expanded(
//                 child: navBody.elementAt(controller.currentNavIndex.value),
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: Obx(
//           () => BottomNavigationBar(
//             currentIndex: controller.currentNavIndex.value,
//             selectedItemColor: redColor,
//             selectedLabelStyle: const TextStyle(fontFamily: semibold),
//             type: BottomNavigationBarType.fixed,
//             backgroundColor: whiteColor,
//             items: navbarItem,
//             onTap: (value) {
//               controller.currentNavIndex.value = value;
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
