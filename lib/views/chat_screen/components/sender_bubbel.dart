import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickshop/consts/consts.dart';
import 'package:intl/intl.dart' as intel;

class ChatBubble extends StatelessWidget {
  final DocumentSnapshot data;
  const ChatBubble({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isMe = data['uid'] == currentUser!.uid;
    final DateTime t =
        data['created_on'] == null
            ? DateTime.now()
            : data['created_on'].toDate();
    final String time = intel.DateFormat("h:mm a").format(t);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              data['msg'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 11,
                color: isMe ? Colors.white.withOpacity(0.7) : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
