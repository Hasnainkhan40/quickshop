import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/auth_controler.dart';
import 'package:quickshop/views/auth_screen/forgetPass.dart';
import 'package:quickshop/views/homescreen/home.dart';
import 'package:quickshop/views/auth_screen/singup_screen.dart';
import 'package:quickshop/views/widgets_common/appLogo_widget.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';
import 'package:quickshop/views/widgets_common/costom_textFiled.dart';
import 'package:quickshop/views/widgets_common/massage.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthControler());
    return Scaffold(
      backgroundColor: Colors.orange,
      resizeToAvoidBottomInset: false,
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
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          icAppLogo, // 🔹 Replace with your asset
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Title
                      Text(
                        "Welcome Back 👋",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Obx(
                        () => TextField(
                          controller: controller.passwordController,
                          obscureText: controller.isPassHidden.value,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPassHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                controller.isPassHidden.value =
                                    !controller.isPassHidden.value;
                              },
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.to(() => const ForgotPasswordScreen());
                          },
                          child: forgetPass.text.make(),
                        ),
                      ),
                      5.heightBox,
                      controller.isLoding.value
                          ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          )
                          : ourButton(
                            color: Colors.orange,
                            title: login,
                            textcolor: whiteColor,
                            onPress: () async {
                              controller.isLoding(true);
                              await controller
                                  .loginMethod(context: context)
                                  .then((value) {
                                    if (value != null) {
                                      //  VxToast.show(context, msg: loggedin);
                                      showModernToast(context, loggedin);

                                      Get.to(() => const Homes());
                                    } else {
                                      controller.isLoding(false);
                                    }
                                  });
                            },
                          ).box.width(context.screenWidth - 50).make(),
                      5.heightBox,
                      createNewAccount.text.color(fontGrey).make(),
                      5.heightBox,
                      ourButton(
                        color: Colors.orange,
                        title: singup,
                        textcolor: Colors.white,
                        onPress: () {
                          Get.to(() => SingupScreen());
                        },
                      ).box.width(context.screenWidth - 50).make(),
                      10.heightBox,
                      loginwhit.text.color(fontGrey).make(),
                      5.heightBox,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: lightGrey,
                              radius: 25,
                              child: Image.asset(
                                socialIconList[index],
                                width: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
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
