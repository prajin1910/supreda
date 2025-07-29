package com.example.hackathon.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Document(collection = "chat_conversations")
public class ChatConversation {
    @Id
    private String id;
    
    private String user1Id;
    private String user2Id;
    private String lastMessage;
    private String lastSenderId;
    private LocalDateTime lastMessageTime = LocalDateTime.now();
    private int unreadCountUser1 = 0;
    private int unreadCountUser2 = 0;

    // Constructors
    public ChatConversation() {}

    public ChatConversation(String user1Id, String user2Id, String lastMessage, String lastSenderId) {
        this.user1Id = user1Id;
        this.user2Id = user2Id;
        this.lastMessage = lastMessage;
        this.lastSenderId = lastSenderId;
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getUser1Id() { return user1Id; }
    public void setUser1Id(String user1Id) { this.user1Id = user1Id; }

    public String getUser2Id() { return user2Id; }
    public void setUser2Id(String user2Id) { this.user2Id = user2Id; }

    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }

    public String getLastSenderId() { return lastSenderId; }
    public void setLastSenderId(String lastSenderId) { this.lastSenderId = lastSenderId; }

    public LocalDateTime getLastMessageTime() { return lastMessageTime; }
    public void setLastMessageTime(LocalDateTime lastMessageTime) { this.lastMessageTime = lastMessageTime; }

    public int getUnreadCountUser1() { return unreadCountUser1; }
    public void setUnreadCountUser1(int unreadCountUser1) { this.unreadCountUser1 = unreadCountUser1; }

    public int getUnreadCountUser2() { return unreadCountUser2; }
    public void setUnreadCountUser2(int unreadCountUser2) { this.unreadCountUser2 = unreadCountUser2; }
}