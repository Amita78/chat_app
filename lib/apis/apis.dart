import 'dart:io';

import 'package:chat_app/models/chat_messages.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static late ChatUser me;

  static Future<void> getSelfInfo() async {
    await fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        final data = ChatUser(
          id: auth.currentUser!.uid,
          name: auth.currentUser!.displayName,
          email: auth.currentUser!.email,
          image: auth.currentUser!.photoURL,
          createdAt: time,
          lastActive: time,
          isOnline: false,
          pushToken: '',
          about: "Hi, I am using Chat App",
        );
        await createUser(data.toJson()).then((value) => getSelfInfo());
      }
    });
  }

  static Future<bool> userExist() async {
    return (await fireStore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> createUser(data) async {
    return (await fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(data));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return APIs.fireStore
        .collection("users")
        .where('id', isNotEqualTo: auth.currentUser?.uid)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersInfo(
      ChatUser user) {
    return APIs.fireStore
        .collection("users")
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    APIs.fireStore.collection("users").doc(auth.currentUser!.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  static Future<void> updateUserInfo() async {
    return (await fireStore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({
      "name": me.name,
      "about": me.about,
    }));
  }

  static Future<void> updateUserProfilePicture(File file) async {
    final image = file.path.split('.').last;
    final reference =
        storage.ref().child('profile_pictures/${auth.currentUser!.uid}.');
    await reference.putFile(
        file, SettableMetadata(contentType: 'image/$image'));
    me.image = await reference.getDownloadURL();
    await fireStore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'image': me.image});
  }

  ///chat messages

  static String getConversationId(String id) =>
      auth.currentUser!.uid.hashCode <= id.hashCode
          ? "${auth.currentUser!.uid}_$id"
          : "${id}_${auth.currentUser!.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return APIs.fireStore
        .collection("chats/${getConversationId(user.id ?? '')}/messages/")
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser user, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ChatMessage message = ChatMessage(
        msg: msg,
        read: '',
        told: user.id,
        fromId: auth.currentUser!.uid,
        type: Type.text,
        sent: time);

    final ref = fireStore
        .collection("chats/${getConversationId(user.id ?? '')}/messages/");
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateReadMessage(ChatMessage msg) async {
    final ref = fireStore
        .collection("chats/${getConversationId(msg.fromId ?? '')}/messages/")
        .doc(msg.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return APIs.fireStore
        .collection("chats/${getConversationId(user.id ?? '')}/messages/")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
