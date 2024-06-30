import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  final ChatMessage message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.auth.currentUser!.uid == widget.message.fromId
        ? sendMessage()
        : receiveMessage();
  }

  Widget receiveMessage() {

    if(widget.message.read!.isEmpty){
      print('update');
      APIs.updateReadMessage(widget.message);
    }
    return Container(
      margin: const EdgeInsets.only(
          //left: 14, right: 14,
          left: 10,
          right: 10),
      padding: const EdgeInsets.only(
          //left: 14, right: 14,
          top: 10,
          bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.green.shade200),
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.message.msg ?? '',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(Utils.getFormatDate(context, widget.message.sent ?? '')),
          ],
        ),
      ),
    );
  }

  Widget sendMessage() {
    return Container(
      margin: const EdgeInsets.only(
          //left: 14, right: 14,
          left: 10,
          right: 10),
      padding: const EdgeInsets.only(
          //left: 14, right: 14,
          top: 10,
          bottom: 10),
      child: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  color: Colors.deepPurple.shade200),
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.message.msg ?? '',
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(Utils.getFormatDate(context, widget.message.sent ?? '')),
                const SizedBox(
                  width: 3,
                ),
                (widget.message.read == '')? const Icon(Icons.done_all_outlined,size: 15) :const Icon(Icons.done_all_outlined,color: Colors.blue,size: 15),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
