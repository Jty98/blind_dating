import 'package:blind_dating/components/image_widget.dart';
import 'package:flutter/material.dart';

class ChatRoomTile extends StatelessWidget {
  final String uid;
  final String uncikname;
  final String lastTime;
  final String lasgChat;
  const ChatRoomTile({
    super.key,
    required this.uid,
    required this.uncikname,
    required this.lastTime,
    required this.lasgChat,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: showImageWidget(uid: uid, size: 60),
      title: Row(
        children: [
          Text(
            uncikname,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
              child: Text(
                lastTime,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        lasgChat,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
