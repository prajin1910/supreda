import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../models/chat.dart';
import '../../models/user.dart';
import '../../utils/helpers.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  ChatConversation? _selectedConversation;
  final _messageController = TextEditingController();
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadConversations() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      chatProvider.fetchConversations(authProvider.user!.id);
    }
  }

  void _loadMessages() {
    if (_selectedConversation == null) return;
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      chatProvider.fetchMessages(authProvider.user!.id, _selectedConversation!.id);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _selectedConversation == null) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    if (authProvider.user != null) {
      final request = SendMessageRequest(
        senderId: authProvider.user!.id,
        receiverId: _selectedConversation!.id,
        message: _messageController.text.trim(),
      );

      await chatProvider.sendMessage(request);
      
      if (chatProvider.error != null) {
        Helpers.showSnackBar(context, chatProvider.error!, isError: true);
      } else {
        _messageController.clear();
        _loadMessages();
        _loadConversations();
      }
    }
  }

  void _searchUsers(String query) {
    if (query.trim().isEmpty) {
      Provider.of<ChatProvider>(context, listen: false).clearSearchResults();
      return;
    }

    Provider.of<ChatProvider>(context, listen: false).searchUsers(query);
  }

  void _startNewChat(User user) {
    final newConversation = ChatConversation(
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      unreadCount: 0,
      isLastMessageFromMe: false,
    );

    setState(() {
      _selectedConversation = newConversation;
      _showSearch = false;
    });

    _searchController.clear();
    Provider.of<ChatProvider>(context, listen: false).clearSearchResults();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Conversations List
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Messages',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showSearch = !_showSearch;
                          });
                        },
                        icon: Icon(
                          _showSearch ? MdiIcons.close : MdiIcons.plus,
                          color: Colors.white,
                        ),
                        tooltip: 'Start new chat',
                      ),
                    ],
                  ),
                ),

                // Search Section
                if (_showSearch) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by email or username...',
                            prefixIcon: Icon(MdiIcons.magnify),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: _searchUsers,
                        ),
                        const SizedBox(height: 8),
                        Consumer<ChatProvider>(
                          builder: (context, chatProvider, child) {
                            if (chatProvider.isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (chatProvider.searchResults.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            return Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                itemCount: chatProvider.searchResults.length,
                                itemBuilder: (context, index) {
                                  final user = chatProvider.searchResults[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Helpers.getRoleColor(user.role),
                                      child: Text(
                                        Helpers.getInitials(user.username),
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(user.username),
                                    subtitle: Text(user.email),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Helpers.getRoleColor(user.role).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        user.role,
                                        style: TextStyle(
                                          color: Helpers.getRoleColor(user.role),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    onTap: () => _startNewChat(user),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                ],

                // Conversations
                Expanded(
                  child: Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      if (chatProvider.isLoading && chatProvider.conversations.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (chatProvider.conversations.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.chat,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No conversations yet',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a new chat to begin messaging',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: chatProvider.conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = chatProvider.conversations[index];
                          final isSelected = _selectedConversation?.id == conversation.id;

                          return Container(
                            color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Helpers.getRoleColor(conversation.role),
                                child: Text(
                                  Helpers.getInitials(conversation.username),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      conversation.username,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Helpers.getRoleColor(conversation.role).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      conversation.role,
                                      style: TextStyle(
                                        color: Helpers.getRoleColor(conversation.role),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                conversation.lastMessage ?? 'No messages yet',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (conversation.lastMessageTime != null)
                                    Text(
                                      Helpers.formatTime(conversation.lastMessageTime!),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  if (conversation.unreadCount > 0)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        conversation.unreadCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedConversation = conversation;
                                });
                                _loadMessages();
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        // Chat Area
        Expanded(
          flex: 2,
          child: _selectedConversation == null
              ? _buildEmptyChatState()
              : _buildChatArea(),
        ),
      ],
    );
  }

  Widget _buildEmptyChatState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.chat,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to SmartEval Chat',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a conversation to start messaging',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Helpers.getRoleColor(_selectedConversation!.role),
                child: Text(
                  Helpers.getInitials(_selectedConversation!.username),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _selectedConversation!.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Helpers.getRoleColor(_selectedConversation!.role).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _selectedConversation!.role,
                            style: TextStyle(
                              color: Helpers.getRoleColor(_selectedConversation!.role),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _selectedConversation!.email,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.isLoading && chatProvider.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (chatProvider.messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MdiIcons.chat,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No messages yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Start the conversation!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chatProvider.messages.length,
                itemBuilder: (context, index) {
                  final message = chatProvider.messages[index];
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                  final isMe = message.senderId == authProvider.user?.id;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.4,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.message,
                                style: TextStyle(
                                  color: isMe ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Helpers.formatTime(message.timestamp),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isMe ? Colors.white70 : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return IconButton(
                    onPressed: chatProvider.isLoading ? null : _sendMessage,
                    icon: chatProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(MdiIcons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}