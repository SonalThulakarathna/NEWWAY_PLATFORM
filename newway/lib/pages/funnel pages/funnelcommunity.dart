import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class Funnelcommunity extends StatefulWidget {
  final String channelId;

  const Funnelcommunity({
    super.key,
    required this.channelId,
  });

  @override
  State<Funnelcommunity> createState() => _FunnelcommunityState();
}

class _FunnelcommunityState extends State<Funnelcommunity> {
  final TextEditingController _messageController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  final List<Map<String, dynamic>> _messages = [];
  late final RealtimeChannel _messageChannel;
  bool _isMember = false;
  bool _loading = true;

  // YouTube-style dark theme colors
  final Color backgroundColor = const Color(0xFF0F0F0F);
  final Color surfaceColor = const Color(0xFF1F1F1F);
  final Color cardColor = const Color(0xFF282828);
  final Color accentColor = const Color(0xFFFF0000); // YouTube red
  final Color textColor = Colors.white;
  final Color textSecondary = const Color(0xFFAAAAAA);
  final Color dividerColor = const Color(0xFF303030);

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Not authenticated'),
            backgroundColor: cardColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context);
      }
      return;
    }

    // Check membership
    final membership = await _supabase
        .from('funnelmembers')
        .select()
        .eq('userid', user.id)
        .eq('funnelid', widget.channelId)
        .maybeSingle();

    if (membership == null) {
      if (mounted) {
        setState(() {
          _loading = false;
          _isMember = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() => _isMember = true);
    }

    // Load channel messages
    final initialMessages = await _supabase
        .from('messages')
        .select('*')
        .eq('channel_id', widget.channelId)
        .order('created_at', ascending: true)
        .limit(100);

    if (mounted) {
      setState(() {
        _messages.addAll(initialMessages.reversed.toList());
        _loading = false;
      });
    }

    _messageChannel = _supabase.channel('channel_${widget.channelId}')
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'messages',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'channel_id',
          value: widget.channelId,
        ),
        callback: (payload) => _handleNewMessage(payload.newRecord),
      )
      ..subscribe();
  }

  void _handleNewMessage(Map<String, dynamic> message) {
    if (message['channel_id'] != widget.channelId) return;

    if (mounted) {
      setState(() {
        _messages.insert(
            0, message); // Insert at the beginning since ListView is reversed
      });
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final user = _supabase.auth.currentUser;
    if (user == null || !_isMember) return;

    try {
      await _supabase.from('messages').insert({
        'content': text,
        'sender_id': user.id,
        'channel_id': widget.channelId,
      });
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: accentColor,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    // ignore: unnecessary_null_comparison
    if (_messageChannel != null) {
      _messageChannel.unsubscribe();
    }
    super.dispose();
  }

  Widget _buildChatContent() {
    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: accentColor,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading messages...',
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (!_isMember) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'You are not a member of this channel',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Join this funnel to participate in the community discussion',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: textColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Chat header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(bottom: BorderSide(color: dividerColor, width: 1)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.forum_rounded,
                color: accentColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Community Discussion',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      color: textSecondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Members',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Messages list
        Expanded(
          child: _messages.isEmpty
              ? _buildEmptyChat()
              : ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _ChatMessageBubble(
                      message: message,
                      channelId: widget.channelId,
                      accentColor: accentColor,
                      cardColor: cardColor,
                      textColor: textColor,
                      textSecondary: textSecondary,
                    );
                  },
                ),
        ),

        // Input area
        _ChatInputArea(
          controller: _messageController,
          onSend: _sendMessage,
          isMember: _isMember,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          surfaceColor: surfaceColor,
          cardColor: cardColor,
          textColor: textColor,
          textSecondary: textSecondary,
        ),
      ],
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No messages yet',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Be the first to start a conversation!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: _buildChatContent(),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final String channelId;
  final Color accentColor;
  final Color cardColor;
  final Color textColor;
  final Color textSecondary;

  const _ChatMessageBubble({
    required this.message,
    required this.channelId,
    required this.accentColor,
    required this.cardColor,
    required this.textColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
        message['sender_id'] == Supabase.instance.client.auth.currentUser?.id;
    final isSameChannel = message['channel_id'] == channelId;

    if (!isSameChannel) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar for other users
          if (!isCurrentUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: cardColor,
              child: Icon(
                Icons.person,
                size: 16,
                color: textSecondary,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message content
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser ? accentColor : cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message text
                  Text(
                    message['content'],
                    style: TextStyle(
                      color: isCurrentUser
                          ? textColor
                          : textColor.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Timestamp
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 10,
                        color: isCurrentUser
                            ? textColor.withOpacity(0.7)
                            : textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        timeago.format(DateTime.parse(message['created_at'])),
                        style: TextStyle(
                          fontSize: 10,
                          color: isCurrentUser
                              ? textColor.withOpacity(0.7)
                              : textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Avatar space for current user
          if (isCurrentUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: accentColor.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 16,
                color: accentColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isMember;
  final Color accentColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color cardColor;
  final Color textColor;
  final Color textSecondary;

  const _ChatInputArea({
    required this.controller,
    required this.onSend,
    required this.isMember,
    required this.accentColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.cardColor,
    required this.textColor,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: cardColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Attachment button
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: isMember ? textColor : textSecondary,
                size: 20,
              ),
              onPressed: isMember
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Attachments coming soon'),
                          backgroundColor: cardColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }
                  : null,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              padding: EdgeInsets.zero,
            ),
          ),

          const SizedBox(width: 12),

          // Text input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                enabled: isMember,
                style: TextStyle(color: textColor, fontSize: 14),
                decoration: InputDecoration(
                  hintText:
                      isMember ? 'Type a message...' : 'Join channel to chat',
                  hintStyle: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => onSend(),
                maxLines: 1,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Send button
          Container(
            decoration: BoxDecoration(
              color: isMember ? accentColor : cardColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: isMember ? textColor : textSecondary,
                size: 20,
              ),
              onPressed: isMember ? onSend : null,
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
