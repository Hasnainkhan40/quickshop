import 'package:flutter/material.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/auth_controler.dart';
import 'package:quickshop/views/homescreen/home.dart';
import 'package:quickshop/views/widgets_common/appLogo_widget.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';
import 'package:quickshop/views/widgets_common/costom_textFiled.dart';
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
    return bgWidget(
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              appLogoWidget(),
              10.heightBox,
              "Jion the $appname".text.fontFamily(bold).size(16).white.make(),
              15.heightBox,
              Obx(
                () =>
                    Column(
                          children: [
                            costomTextField(
                              hint: nameHint,
                              titel: name,
                              controller: nameController,
                              isPass: false,
                            ),
                            costomTextField(
                              hint: emailHint,
                              titel: email,
                              controller: emailController,
                              isPass: false,
                            ),
                            costomTextField(
                              hint: passwordHint,
                              titel: password,
                              controller: passwordController,
                              isPass: true,
                            ),
                            costomTextField(
                              hint: passwordHint,
                              titel: retypePassword,
                              controller: passwordRetypeController,
                              isPass: true,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: forgetPass.text.make(),
                              ),
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
                                            color: redColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: termAndCond,
                                          style: TextStyle(
                                            fontFamily: regular,
                                            color: redColor,
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
                                            color: redColor,
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
                                  color: isCheck == true ? redColor : lightGrey,
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
                                                password:
                                                    passwordController.text,
                                                name: nameController.text,
                                              );
                                            })
                                            .then((value) {
                                              VxToast.show(
                                                context,
                                                msg: loggedin,
                                              );
                                              Get.offAll(() => const Homes());
                                            });
                                      } catch (e) {
                                        auth.signOut();
                                        VxToast.show(
                                          context,
                                          msg: e.toString(),
                                        );
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
                                      color: redColor,
                                    ),
                                  ),
                                ],
                              ),
                            ).onTap(() {
                              Get.back();
                            }),
                          ],
                        ).box.white.rounded
                        .padding(EdgeInsets.all(10))
                        .width(context.screenWidth - 70)
                        .shadowSm
                        .make(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
