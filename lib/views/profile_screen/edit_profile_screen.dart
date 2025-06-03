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
        appBar: AppBar(),
        body: Obx(
          () => SingleChildScrollView(
            child:
                Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.profileImagePath.isEmpty
                            ? Image.asset(
                              imgB1,
                              width: 100,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.file(
                              File(controller.profileImagePath.value),
                              width: 100,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                        10.heightBox,
                        ourButton(
                          color: redColor,
                          onPress: () {
                            controller.changeImage(context);
                          },
                          title: "Chenge",
                          textcolor: whiteColor,
                        ),
                        const Divider(),
                        20.heightBox,
                        costomTextField(
                          controller: controller.nameController,
                          hint: nameHint,
                          titel: name,
                          isPass: false,
                        ),
                        costomTextField(
                          controller: controller.passController,
                          hint: password,
                          titel: password,
                          isPass: true,
                        ),
                        20.heightBox,
                        controller.isLoding.value
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            )
                            : SizedBox(
                              width: 60,
                              child: ourButton(
                                color: redColor,
                                onPress: () async {
                                  controller.isLoding(true);
                                  await controller.uodateProfile(
                                    imageUrl: '',
                                    name: controller.nameController.text,
                                    password: controller.passController.text,
                                  );
                                  VxToast.show(context, msg: "Update");
                                },
                                title: "Save",
                                textcolor: whiteColor,
                              ),
                            ),
                      ],
                    ).box.white.shadowSm
                    .padding(const EdgeInsets.all(16))
                    .margin(const EdgeInsets.only(top: 50, left: 12, right: 12))
                    .rounded
                    .make(),
          ),
        ),
      ),
    );
  }
}
