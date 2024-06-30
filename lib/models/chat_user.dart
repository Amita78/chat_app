// To parse this JSON data, do
//
//     final chatUser = chatUserFromJson(jsonString);

import 'dart:convert';

ChatUser chatUserFromJson(String str) => ChatUser.fromJson(json.decode(str));

String chatUserToJson(ChatUser data) => json.encode(data.toJson());

class ChatUser {
  String? id;
  String? image;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? email;
  String? pushToken;

  ChatUser({
    this.id,
    this.image,
    this.about,
    this.name,
    this.createdAt,
    this.isOnline,
    this.lastActive,
    this.email,
    this.pushToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
    id: json["id"],
    image: json["image"],
    about: json["about"],
    name: json["name"],
    createdAt: json["created_at"],
    isOnline: json["is_online"],
    lastActive: json["last_active"],
    email: json["email"],
    pushToken: json["push_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "about": about,
    "name": name,
    "created_at": createdAt,
    "is_online": isOnline,
    "last_active": lastActive,
    "email": email,
    "push_token": pushToken,
  };
}
