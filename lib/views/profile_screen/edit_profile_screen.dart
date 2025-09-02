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
          elevation: 0,
          backgroundColor: lightGrey,
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),

          // icon: Icon(Icons.arrow_back, color: Colors.white),
          title: const Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Center(
              child: Container(
                width: double.infinity,
                height: 900,
                child:
                    Column(
                          children: [
                            Center(
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Obx(
                                    () => CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.black,
                                      backgroundImage:
                                          controller.profileImageUrl.isNotEmpty
                                              ? NetworkImage(
                                                controller
                                                    .profileImageUrl
                                                    .value,
                                              )
                                              : AssetImage(imgB1)
                                                  as ImageProvider,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // open image picker
                                    },
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            10.heightBox,
                            ourButton(
                              color: orangeColor,
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
                              title: name,
                              isPass: false,
                            ),
                            10.heightBox,
                            costomTextField(
                              controller: controller.oldpassController,
                              hint: password,
                              title: oldpass,
                              isPass: true,
                            ),
                            10.heightBox,
                            costomTextField(
                              controller: controller.newpassController,
                              hint: password,
                              title: newpass,
                              isPass: true,
                            ),
                            20.heightBox,

                            controller.isLoding.value
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.black,
                                  ),
                                )
                                : SizedBox(
                                  width: double.infinity,
                                  child: ourButton(
                                    color: orangeColor,
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
                        .margin(const EdgeInsets.only(top: 50))
                        .roundedLg
                        .make(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
