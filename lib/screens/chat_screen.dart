import 'dart:io';

import 'package:chat_app/apis/apis.dart';
import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/utils/utils.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> chats = [];
  final msgCtrl = TextEditingController();
  RxBool isShowing = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: StreamBuilder(
            stream: APIs.getUsersInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  CircleAvatar(
                    backgroundImage: NetworkImage((list.isNotEmpty)? list[0].image ?? '':widget.user.image ?? ''),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (list.isNotEmpty)? list[0].name ?? '':widget.user.name ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        (list.isNotEmpty)? list[0].isOnline == true ? "Online" : Utils.getLastActiveTime(context: context, lastActive: list[0].lastActive ?? ''): Utils.getLastActiveTime(context: context, lastActive: widget.user.lastActive ?? ''),
                        style: const TextStyle(fontSize: 10),
                      )
                    ],
                  )
                ],
              );
            }
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final msg = snapshot.data?.docs;
                      chats =
                          msg!.map((e) => ChatMessage.fromJson(e.data())).toList();
                      if (chats.isNotEmpty) {
                        return ListView.separated(
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              return MessageCard(message: chats[index]);
                            },
                        separatorBuilder: (BuildContext context,int index){
                              return const SizedBox(
                                height: 10,
                              );
                        },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "Say hii..",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        );
                      }
                  }
                },
              ),

            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                isShowing.value = !isShowing.value;
                              },
                              icon: const Icon(Icons.emoji_emotions_outlined)),
                          Expanded(
                            child: TextFormField(
                              controller: msgCtrl,
                              maxLines: null,
                              onTapOutside: (point){
                                FocusScope.of(context).unfocus();
                              },
                              onTap: (){
                                if(isShowing.value) {isShowing.value = !isShowing.value;}
                              },
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type something...."),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.camera_alt_outlined)),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.photo)),
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(msgCtrl.text.isNotEmpty){
                        APIs.sendMessage(widget.user, msgCtrl.text);
                        msgCtrl.text = '';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      minimumSize: const Size(50, 50),
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 30,
                    ),
                  )
                ],
              ),
            ),
            Obx(()=>(isShowing.value == true)?SizedBox(
              width: double.infinity,
              height: 270,
              child: EmojiPicker(
                textEditingController: msgCtrl, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                ),
              ),
            ):const SizedBox(height: 0,width: 0,)),
          ],
        ),
      ),
     // bottomNavigationBar:
    );
  }
}
