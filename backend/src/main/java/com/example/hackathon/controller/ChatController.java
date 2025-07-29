package com.example.hackathon.controller;

import com.example.hackathon.dto.ApiResponse;
import com.example.hackathon.dto.SendMessageRequest;
import com.example.hackathon.dto.UserResponse;
import com.example.hackathon.model.ChatMessage;
import com.example.hackathon.model.ChatConversation;
import com.example.hackathon.model.User;
import com.example.hackathon.repository.ChatMessageRepository;
import com.example.hackathon.repository.ChatConversationRepository;
import com.example.hackathon.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/chat")
@CrossOrigin
public class ChatController {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    @Autowired
    private ChatConversationRepository chatConversationRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/send")
    public ResponseEntity<?> sendMessage(@RequestBody SendMessageRequest request) {
        try {
            ChatMessage message = new ChatMessage(
                request.getSenderId(),
                request.getReceiverId(),
                request.getMessage()
            );
            chatMessageRepository.save(message);
            
            // Update or create conversation
            updateConversation(request.getSenderId(), request.getReceiverId(), request.getMessage());
            
            return ResponseEntity.ok(new ApiResponse(true, "Message sent successfully!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body(new ApiResponse(false, "Failed to send message: " + e.getMessage()));
        }
    }

    @GetMapping("/messages/{userId1}/{userId2}")
    public ResponseEntity<List<ChatMessage>> getMessages(
            @PathVariable String userId1,
            @PathVariable String userId2) {
        List<ChatMessage> messages = chatMessageRepository.findMessagesBetweenUsers(userId1, userId2);
        
        // Mark messages as read
        markMessagesAsRead(userId1, userId2);
        
        return ResponseEntity.ok(messages);
    }

    @GetMapping("/conversations/{userId}")
    public ResponseEntity<List<Object>> getConversations(@PathVariable String userId) {
        List<ChatConversation> conversations = chatConversationRepository.findConversationsByUserId(userId);
        
        List<Object> conversationDetails = conversations.stream()
            .sorted((a, b) -> b.getLastMessageTime().compareTo(a.getLastMessageTime()))
            .map(conv -> {
                String otherUserId = conv.getUser1Id().equals(userId) ? conv.getUser2Id() : conv.getUser1Id();
                Optional<User> otherUser = userRepository.findById(otherUserId);
                
                if (otherUser.isPresent()) {
                    User user = otherUser.get();
                    int unreadCount = conv.getUser1Id().equals(userId) ? conv.getUnreadCountUser1() : conv.getUnreadCountUser2();
                    
                    return new Object() {
                        public final String id = user.getId();
                        public final String username = user.getUsername();
                        public final String email = user.getEmail();
                        public final String role = user.getRole().toString();
                        public final String lastMessage = conv.getLastMessage();
                        public final LocalDateTime lastMessageTime = conv.getLastMessageTime();
                        public final int unreadCount = unreadCount;
                        public final boolean isLastMessageFromMe = conv.getLastSenderId().equals(userId);
                    };
                }
                return null;
            })
            .filter(obj -> obj != null)
            .collect(Collectors.toList());
            
        return ResponseEntity.ok(conversationDetails);
    }

    private void updateConversation(String senderId, String receiverId, String message) {
        Optional<ChatConversation> existingConv = chatConversationRepository.findConversationBetweenUsers(senderId, receiverId);
        
        if (existingConv.isPresent()) {
            ChatConversation conv = existingConv.get();
            conv.setLastMessage(message);
            conv.setLastSenderId(senderId);
            conv.setLastMessageTime(LocalDateTime.now());
            
            // Increment unread count for receiver
            if (conv.getUser1Id().equals(receiverId)) {
                conv.setUnreadCountUser1(conv.getUnreadCountUser1() + 1);
            } else {
                conv.setUnreadCountUser2(conv.getUnreadCountUser2() + 1);
            }
            
            chatConversationRepository.save(conv);
        } else {
            ChatConversation newConv = new ChatConversation(senderId, receiverId, message, senderId);
            // Set unread count for receiver
            if (senderId.equals(newConv.getUser1Id())) {
                newConv.setUnreadCountUser2(1);
            } else {
                newConv.setUnreadCountUser1(1);
            }
            chatConversationRepository.save(newConv);
        }
    }

    private void markMessagesAsRead(String currentUserId, String otherUserId) {
        Optional<ChatConversation> conv = chatConversationRepository.findConversationBetweenUsers(currentUserId, otherUserId);
        if (conv.isPresent()) {
            ChatConversation conversation = conv.get();
            if (conversation.getUser1Id().equals(currentUserId)) {
                conversation.setUnreadCountUser1(0);
            } else {
                conversation.setUnreadCountUser2(0);
            }
            chatConversationRepository.save(conversation);
        }
    }
}