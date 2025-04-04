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

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not authenticated')),
      );
      Navigator.pop(context);
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
      setState(() {
        _loading = false;
        _isMember = false;
      });
      return;
    }

    setState(() => _isMember = true);

    // Load channel messages
    final initialMessages = await _supabase
        .from('messages')
        .select('*')
        .eq('channel_id', widget.channelId)
        .order('created_at', ascending: true)
        .limit(100);

    setState(() {
      _messages.addAll(initialMessages.reversed.toList());
      _loading = false;
    });

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

    setState(() {
      _messages.add(message);
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending message: $e')),
      );
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
      return const Center(
          child: CircularProgressIndicator(
        color: Color(0xFF6C63FF),
      ));
    }

    if (!_isMember) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are not a member of this channel',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _ChatMessageBubble(
                message: message,
                channelId: widget.channelId,
              );
            },
          ),
        ),
        _ChatInputArea(
          controller: _messageController,
          onSend: _sendMessage,
          isMember: _isMember,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      body: SafeArea(
        child: _buildChatContent(),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final String channelId;

  const _ChatMessageBubble({
    required this.message,
    required this.channelId,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrentUser =
        message['sender_id'] == Supabase.instance.client.auth.currentUser?.id;
    final isSameChannel = message['channel_id'] == channelId;

    if (!isSameChannel) return const SizedBox.shrink();

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color:
              isCurrentUser ? const Color(0xFF6C63FF) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['content'],
              style: TextStyle(
                color: isCurrentUser
                    ? Colors.white
                    : Colors.white.withOpacity(0.9),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              timeago.format(DateTime.parse(message['created_at'])),
              style: TextStyle(
                fontSize: 11,
                color: isCurrentUser
                    ? Colors.white.withOpacity(0.7)
                    : Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isMember;

  const _ChatInputArea({
    required this.controller,
    required this.onSend,
    required this.isMember,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file_rounded,
              color: isMember ? const Color(0xFF6C63FF) : Colors.grey[700],
              size: 24,
            ),
            onPressed: isMember ? () {} : null,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF3A3A3A),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                enabled: isMember,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText:
                      isMember ? 'Type a message...' : 'Join channel to chat',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => onSend(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isMember
                  ? const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF5A52CC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMember ? null : Colors.grey[800],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: isMember ? onSend : null,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.send_rounded,
                    color: isMember ? Colors.white : Colors.grey[600],
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
