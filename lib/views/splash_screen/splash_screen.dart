import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/views/auth_screen/login_screen.dart';
import 'package:quickshop/views/homescreen/home.dart';
import 'package:quickshop/views/widgets_common/appLogo_widget.dart';
import 'package:flutter/material.dart';
import 'package:quickshop/consts/colors.dart';
import 'package:quickshop/consts/images.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  //creating a method to chanage screen
  changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      //using getx
      //Get.to(() => const LoginScreen());
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => const LoginScreen());
        } else {
          Get.to(() => const Homes());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Image.asset(icSplashBg, width: 200),
            ),
            20.heightBox,
            appLogoWidget(),
            10.heightBox,
            appname.text.fontFamily(semibold).size(22).white.make(),
            5.heightBox,
            appversion.text.white.make(),
            const Spacer(),
            credits.text.white.fontFamily(semibold).make(),
            30.heightBox,
            //Our splash screen Ui is completed..,
          ],
        ),
      ),
    );
  }
}
