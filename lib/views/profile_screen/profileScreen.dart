import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/auth_controler.dart';
import 'package:quickshop/controller/profile_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/auth_screen/login_screen.dart';
import 'package:quickshop/views/chat_screen/message_screen.dart';
import 'package:quickshop/views/order_screen/order_screen.dart';
import 'package:quickshop/views/profile_screen/componets/details_cart.dart';
import 'package:quickshop/views/profile_screen/edit_profile_screen.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';
import 'package:quickshop/views/wishlist_screen/wishlist_screen.dart';

class Profilescreen extends StatelessWidget {
  const Profilescreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
      Scaffold(
        body: StreamBuilder(
          stream: FirestoreServices.getUser(currentUser!.uid),
          builder: (
            BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(redColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              return SafeArea(
                child: Column(
                  children: [
                    //edit profile button
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.edit, color: whiteColor),
                      ).onTap(() {
                        controller.nameController.text = data['name'];

                        Get.to(() => EditProfileScreen(data: data));
                      }),
                    ),
                    //User details sections
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          data['imageUrl'] != null &&
                                  data['imageUrl'].toString().isNotEmpty
                              ? Image.network(
                                data['imageUrl'],
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

                          10.widthBox,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "${data['name']}".text
                                    .fontFamily(semibold)
                                    .white
                                    .make(),
                                "${data['email']}".text.white.make(),
                              ],
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: whiteColor),
                            ),
                            onPressed: () async {
                              await Get.put(
                                AuthControler(),
                              ).signoutMethod(context);
                              Get.offAll(() => const LoginScreen());
                            },
                            child:
                                logout.text.fontFamily(semibold).white.make(),
                          ),
                        ],
                      ),
                    ),
                    20.heightBox,
                    FutureBuilder(
                      future: FirestoreServices.getCounts(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: lodingIndicator());
                        } else {
                          var countData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              detailsCard(
                                count: countData[0].toString(),
                                title: "in your cart",
                                width: context.screenWidth / 3.4,
                              ),
                              detailsCard(
                                count: countData[1].toString(),
                                title: "in your wishlist",
                                width: context.screenWidth / 3.4,
                              ),
                              detailsCard(
                                count: countData[2].toString(),
                                title: "your orders",
                                width: context.screenWidth / 3.4,
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     detailsCard(
                    //       count: data['cart_count'],
                    //       title: "in your cart",
                    //       width: context.screenWidth / 3.4,
                    //     ),
                    //     detailsCard(
                    //       count: data['wishlist_count'],
                    //       title: "in your wishlist",
                    //       width: context.screenWidth / 3.4,
                    //     ),
                    //     detailsCard(
                    //       count: data['order_count'],
                    //       title: "your orders",
                    //       width: context.screenWidth / 3.4,
                    //     ),
                    //   ],
                    // ),
                    ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const Divider(color: lightGrey);
                          },
                          itemCount: profileButtonsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Get.to(() => OrderScreen());
                                    break;
                                  case 1:
                                    Get.to(() => WishlistScreen());
                                    break;
                                  case 2:
                                    Get.to(() => MessageScreen());
                                    break;
                                  default:
                                }
                              },
                              leading: Image.asset(
                                profileButtonIcons[index],
                                width: 22,
                              ),
                              title:
                                  profileButtonsList[index].text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                            );
                          },
                        ).box.white.rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
