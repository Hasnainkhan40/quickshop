import 'dart:io';

import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/controller/profile_controller.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';
import 'package:quickshop/views/widgets_common/costom_textFiled.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;
  const EditProfileScreen({super.key, this.data});
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
      Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child:
                    Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            controller.profileImageUrl.isNotEmpty
                                ? Image.network(
                                  controller.profileImageUrl.value,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make()
                                : Image.asset(
                                  imgB1,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ).box.roundedFull.clip(Clip.antiAlias).make(),

                            10.heightBox,
                            ourButton(
                              color: redColor,
                              onPress: () {
                                controller.uodateProfilePicture(context);
                              },
                              title: "Change",
                              textcolor: whiteColor,
                            ),
                            const Divider(),
                            20.heightBox,

                            /// TextFields
                            costomTextField(
                              controller: controller.nameController,
                              hint: nameHint,
                              titel: name,
                              isPass: false,
                            ),
                            10.heightBox,
                            costomTextField(
                              controller: controller.oldpassController,
                              hint: password,
                              titel: oldpass,
                              isPass: true,
                            ),
                            10.heightBox,
                            costomTextField(
                              controller: controller.newpassController,
                              hint: password,
                              titel: newpass,
                              isPass: true,
                            ),
                            20.heightBox,

                            controller.isLoding.value
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(redColor),
                                )
                                : SizedBox(
                                  width: double.infinity,
                                  child: ourButton(
                                    color: redColor,
                                    onPress: () async {
                                      controller.isLoding(true);

                                      if (data['password'] ==
                                          controller.oldpassController.text) {
                                        await controller.changeAuthPassword(
                                          email: data['email'],
                                          password:
                                              controller.oldpassController.text,
                                          newpassword:
                                              controller.newpassController.text,
                                        );

                                        await controller.uodateProfile(
                                          imageUrl:
                                              controller.profileImageUrl.value,
                                          name: controller.nameController.text,
                                          password:
                                              controller.newpassController.text,
                                        );
                                        VxToast.show(context, msg: "Update");
                                      } else {
                                        VxToast.show(
                                          context,
                                          msg: "Wrong old password",
                                        );
                                      }
                                    },
                                    title: "Save",
                                    textcolor: whiteColor,
                                  ),
                                ),
                          ],
                        ).box.white.shadowSm
                        .padding(const EdgeInsets.all(16))
                        .margin(
                          const EdgeInsets.only(top: 50, left: 12, right: 12),
                        )
                        .rounded
                        .make(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
