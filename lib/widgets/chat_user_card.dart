import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  ChatMessage ? message;
  List<ChatMessage> chats = [];
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {
          Get.to(() => ChatScreen(user: widget.user));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessages(widget.user),
          builder: (context,snapshot) {
            if(snapshot.data != null) {
              final msg = snapshot.data!.docs;
              chats =
                  msg.map((e) => ChatMessage.fromJson(e.data())).toList();
            }
            if(chats.isNotEmpty) {
                message = chats[0];
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.image ?? ''),
              ),
              title: Text(widget.user.name ?? ''),
              subtitle: Text(message != null ? message!.msg ?? '' : widget.user.about ?? ''),
              trailing: Text(message != null ?(message!.read!.isEmpty)? '' : Utils.getLastMessageTime(context, message!.read ?? '')  ?? '' :  ''),
            );
          }
        ),
      ),
    );
  }
}
