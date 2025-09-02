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
            } else if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No profile data found",
                  style: TextStyle(color: whiteColor),
                ),
              );
            } else {
              var data = snapshot.data!.docs[0];
              return Column(
                children: [
                  //edit profile button
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/orange-wave.png"),
                        fit: BoxFit.cover,
                      ),
                      // color: orangeColor, // dark green shade
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        //User details sections
                        SizedBox(height: 60),
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
                                        .size(25)
                                        .make(),
                                    "${data['email']}".text.white.make(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        30.heightBox,
                        FutureBuilder(
                          future: FirestoreServices.getCounts(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot snapshot,
                          ) {
                            if (!snapshot.hasData) {
                              return Center(child: lodingIndicator());
                            } else {
                              var countData = snapshot.data;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                      ],
                    ),
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
                  const SizedBox(height: 20),

                  // Account Overview section
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Account Overview",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              //SizedBox(width: 5),
                              Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.edit_note,
                                  color: Colors.black,
                                  size: 30,
                                ),
                              ).onTap(() {
                                controller.nameController.text = data['name'];

                                Get.to(() => EditProfileScreen(data: data));
                              }),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Menu items list
                          Column(
                            children: [
                              ListView.separated(
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) {
                                      return const Divider(color: lightGrey);
                                    },
                                    itemCount: profileButtonsList.length,
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
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
                                  .size(600, 260)
                                  .shadowSm
                                  .make()
                                  .box
                                  .make(),
                            ],
                          ),

                          SizedBox(height: 15),
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                // maximumSize: Size(350.0, 50.0),
                                // minimumSize: Size(350.0, 50.0),
                                backgroundColor: Colors.orange,
                                side: const BorderSide(
                                  color: orangeColor,
                                  width: 2.0,
                                ),
                              ),
                              onPressed: () async {
                                await Get.put(
                                  AuthControler(),
                                ).signoutMethod(context);
                                Get.offAll(() => const LoginScreen());
                              },
                              child:
                                  logout.text
                                      .fontFamily(bold)
                                      .color(whiteColor)
                                      .size(15)
                                      .make(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
