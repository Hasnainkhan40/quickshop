import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/views/auth_screen/singup_screen.dart';
import 'package:quickshop/widgets_common/appLogo_widget.dart';
import 'package:quickshop/widgets_common/bg_widget.dart';
import 'package:quickshop/widgets_common/costom_textFiled.dart';
import 'package:quickshop/widgets_common/our_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
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
              "Log in to $appname".text.fontFamily(bold).white.make(),
              15.heightBox,
              Column(
                    children: [
                      costomTextField(hint: emailHint, titel: email),
                      costomTextField(hint: passwordHint, titel: password),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: forgetPass.text.make(),
                        ),
                      ),
                      5.heightBox,
                      ourButton(
                        color: redColor,
                        title: login,
                        textcolor: whiteColor,
                        onPress: () {},
                      ).box.width(context.screenWidth - 50).make(),
                      5.heightBox,
                      createNewAccount.text.color(fontGrey).make(),
                      5.heightBox,
                      ourButton(
                        color: const Color.fromARGB(46, 230, 42, 4),
                        title: singup,
                        textcolor: redColor,
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
                  ).box.white.rounded
                  .padding(EdgeInsets.all(10))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
