import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

@JsonSerializable()
class ChatConversation {
  final String id;
  final String username;
  final String email;
  final String role;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final bool isLastMessageFromMe;

  ChatConversation({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    required this.isLastMessageFromMe,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) => _$ChatConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ChatConversationToJson(this);
}

@JsonSerializable()
class SendMessageRequest {
  final String senderId;
  final String receiverId;
  final String message;

  SendMessageRequest({
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) => _$SendMessageRequestFromJson(json);
  Map<String, dynamic> toJson() => _$SendMessageRequestToJson(this);
}