package com.smarteval.app.data.model

data class ChatMessage(
    val id: String,
    val senderId: String,
    val receiverId: String,
    val message: String,
    val timestamp: String
)

data class ChatConversation(
    val id: String,
    val username: String,
    val email: String,
    val role: String,
    val lastMessage: String?,
    val lastMessageTime: String?,
    val unreadCount: Int,
    val isLastMessageFromMe: Boolean
)

data class SendMessageRequest(
    val senderId: String,
    val receiverId: String,
    val message: String
)