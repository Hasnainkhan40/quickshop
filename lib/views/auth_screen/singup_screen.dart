import 'package:flutter/material.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/auth_controler.dart';
import 'package:quickshop/views/homescreen/home.dart';
import 'package:quickshop/views/widgets_common/appLogo_widget.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';
import 'package:quickshop/views/widgets_common/costom_textFiled.dart';
import 'package:quickshop/views/widgets_common/massage.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';
import 'package:get/get.dart';

class SingupScreen extends StatefulWidget {
  const SingupScreen({super.key});

  @override
  State<SingupScreen> createState() => _SingupScreenState();
}

class _SingupScreenState extends State<SingupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthControler());

  //text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.orange,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            // appLogoWidget(),
            // 10.heightBox,
            // "Log in to $appname".text.fontFamily(bold).white.make(),
            15.heightBox,
            Obx(
              () => Container(
                width: double.infinity,
                height: 755,
                decoration: const BoxDecoration(
                  color: lightGrey, // dark green shade
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's Get Started",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "create an account to get all features",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black26,
                        ),
                      ),
                      costomTextField(
                        hint: nameHint,
                        title: name,
                        controller: nameController,
                        isPass: false,
                      ),
                      costomTextField(
                        hint: emailHint,
                        title: email,
                        controller: emailController,
                        isPass: false,
                      ),
                      costomTextField(
                        hint: passwordHint,
                        title: password,
                        controller: passwordController,
                        isPass: true,
                      ),
                      costomTextField(
                        hint: passwordHint,
                        title: retypePassword,
                        controller: passwordRetypeController,
                        isPass: true,
                      ),

                      5.heightBox,
                      Row(
                        children: [
                          Checkbox(
                            checkColor: redColor,
                            value: isCheck,
                            onChanged: (newValue) {
                              setState(() {
                                isCheck = newValue;
                              });
                            },
                          ),
                          10.heightBox,
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "I agree to the ",
                                    style: TextStyle(
                                      fontFamily: regular,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: termAndCond,
                                    style: TextStyle(
                                      fontFamily: regular,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " &",
                                    style: TextStyle(
                                      fontFamily: regular,
                                      color: fontGrey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: privacyPolicy,
                                    style: TextStyle(
                                      fontFamily: regular,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      5.heightBox,
                      controller.isLoding.value
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                          : ourButton(
                            color: isCheck == true ? Colors.black : orangeColor,
                            title: singup,
                            textcolor: whiteColor,
                            onPress: () async {
                              if (isCheck != false) {
                                controller.isLoding(true);
                                try {
                                  await controller
                                      .signupMethod(
                                        context: context,
                                        email: emailController.text,
                                        password: passwordController.text,
                                      )
                                      .then((value) {
                                        return controller.storeUserDat(
                                          email: emailController.text,
                                          password: passwordController.text,
                                          name: nameController.text,
                                        );
                                      })
                                      .then((value) {
                                        //VxToast.show(context, msg: loggedin);
                                        showModernToast(context, loggedin);

                                        Get.offAll(() => const Homes());
                                      });
                                } catch (e) {
                                  auth.signOut();
                                  // VxToast.show(context, msg: e.toString());
                                  showModernToast(context, e.toString());
                                  controller.isLoding(false);
                                }
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: alreadyhaveAccount,
                              style: TextStyle(
                                fontFamily: bold,
                                color: fontGrey,
                              ),
                            ),
                            TextSpan(
                              text: login,
                              style: TextStyle(
                                fontFamily: bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ).onTap(() {
                        Get.back();
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
