import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/loding_indicator.dart';
import 'package:quickshop/controller/cart_controller.dart';
import 'package:quickshop/services/firestore_services.dart';
import 'package:quickshop/views/cart_screen/shipping_screen.dart';
import 'package:quickshop/views/widgets_common/our_button.dart';

class Cartscreen extends StatelessWidget {
  const Cartscreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          color: redColor,
          onPress: () {
            Get.to(() => const ShippingScreen());
          },
          textcolor: whiteColor,
          title: "proceed To shipping",
        ),
      ),
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            "Shoping cart".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: lodingIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;

            controller.calculate(data);
            controller.productSnapshot = data;
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Image.network("${data[index]['img']}"),
                          title:
                              "${data[index]['title']} (x${data[index]['qty']})"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                          subtitle:
                              "${data[index]['tprice']}".numCurrency.text
                                  .fontFamily(semibold)
                                  .color(redColor)
                                  .make(),
                          trailing: Icon(Icons.delete, color: redColor).onTap(
                            () {
                              FirestoreServices.deleteDocument(data[index].id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Total price".text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          Obx(
                            () =>
                                "${controller.totalp.value}".text
                                    .fontFamily(semibold)
                                    .color(redColor)
                                    .make(),
                          ),
                        ],
                      ).box
                      .padding(EdgeInsets.all(12))
                      .color(lightGrey)
                      .width(context.screenWidth - 60)
                      .roundedSM
                      .make(),
                  10.heightBox,
                  /* SizedBox(
                    width: context.screenWidth - 60,
                    child: ourButton(
                      color: redColor,
                      onPress: () {},
                      textcolor: whiteColor,
                      title: "proceed To shipping",
                    ),
                  ),*/
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
