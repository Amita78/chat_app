// To parse this JSON data, do
//
//     final chatMessage = chatMessageFromJson(jsonString);

import 'dart:convert';

ChatMessage chatMessageFromJson(String str) =>
    ChatMessage.fromJson(json.decode(str));

String chatMessageToJson(ChatMessage data) => json.encode(data.toJson());

class ChatMessage {
  String? msg;
  String? read;
  String? told;
  Type? type;
  String? sent;
  String? fromId;

  ChatMessage({
    this.msg,
    this.read,
    this.told,
    this.type,
    this.sent,
    this.fromId,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        msg: json["msg"],
        read: json["read"],
        told: json["told"],
        type:
            json["type"].toString() == Type.image.name ? Type.image : Type.text,
        sent: json["sent"],
        fromId: json["fromId"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "read": read,
        "told": told,
        "type": type?.name,
        "sent": sent,
        "fromId": fromId,
      };
}

enum Type { text, image }
