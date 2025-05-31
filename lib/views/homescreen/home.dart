import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/home_controller.dart';
import 'package:quickshop/views/cart_screen/cartScreen.dart';
import 'package:quickshop/views/category_Screen/categoryScreen.dart';
import 'package:quickshop/views/homescreen/homeScreen.dart';
import 'package:quickshop/views/profile_screen/profileScreen.dart';

class Homes extends StatelessWidget {
  const Homes({super.key});
  @override
  Widget build(BuildContext context) {
    //init home controller
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(
        icon: Image.asset(icHome, width: 26),
        label: home,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCategories, width: 26),
        label: categories,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icCart, width: 26),
        label: cart,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(icProfile, width: 26),
        label: account,
      ),
    ];

    var navBody = [
      const Homescreen(),
      const Categoryscreen(),
      const Cartscreen(),
      const Profilescreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: navBody.elementAt(controller.currentNavIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          selectedItemColor: redColor,
          selectedLabelStyle: const TextStyle(fontFamily: semibold),
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: navbarItem,
          onTap: (value) {
            controller.currentNavIndex.value = value;
          },
        ),
      ),
    );
  }
}
