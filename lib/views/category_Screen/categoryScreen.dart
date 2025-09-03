import 'package:get/get.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:quickshop/consts/list.dart';
import 'package:quickshop/controller/product_controller.dart';
import 'package:quickshop/views/category_Screen/category_details.dart';
import 'package:quickshop/views/widgets_common/bg_widget.dart';

class Categoryscreen extends StatelessWidget {
  const Categoryscreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return bgWidget(
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,

          title: const Text(
            "Categories",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 175,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  14.heightBox,
                  Image.asset(
                    categoryImages[index],
                    height: 100,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  10.heightBox,
                  categoriesList[index].text
                      .color(darkFontGrey)
                      .align(TextAlign.center)
                      .make(),
                ],
              ).box.white.roundedLg.clip(Clip.antiAlias).shadowSm.make().onTap(
                () {
                  controller.getSubCategories(categoriesList[index]);
                  Get.to(() => CategoryDetails(title: categoriesList[index]));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
