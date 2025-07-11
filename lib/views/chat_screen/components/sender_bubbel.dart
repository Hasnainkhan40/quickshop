import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

Widget senderBubbel(DocumentSnapshot data) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  bool isCurrentUser = data['uid'] == currentUser!.uid;

  return Directionality(
    textDirection: isCurrentUser ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isCurrentUser ? redColor : darkFontGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(isCurrentUser ? 20 : 0),
          bottomRight: Radius.circular(isCurrentUser ? 0 : 20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.white.size(16).make(),
          10.heightBox,
          time.text.color(whiteColor.withOpacity(0.5)).make(),
        ],
      ),
    ),
  );
}
