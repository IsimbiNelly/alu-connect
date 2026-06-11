import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/event_provider.dart';
import 'chat_screen.dart';

class ChatroomsScreen extends StatelessWidget {
  const ChatroomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>().events;
    final chatProvider = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
              color: Color(0xFF1F1F1F), fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.separated(
        itemCount: events.length,
        separatorBuilder: (context, i) =>
            const Divider(height: 1, indent: 72, endIndent: 16),
        itemBuilder: (context, index) {
          final event = events[index];
          final messages = chatProvider.getMessages(event.id);
          final lastMsg = messages.isEmpty ? null : messages.last;

          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF5B21B6),
              radius: 24,
              child: Text(
                event.title[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              event.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              lastMsg != null
                  ? (lastMsg.isSystem
                      ? lastMsg.text
                      : '${lastMsg.isMe ? "You" : lastMsg.sender}: ${lastMsg.text}')
                  : 'Tap to open chatroom',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                  color: Color(0xFF6B7280), fontSize: 13),
            ),
            trailing: lastMsg != null
                ? Text(
                    _formatTime(lastMsg.timestamp),
                    style: const TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 11),
                  )
                : const Icon(Icons.chevron_right,
                    color: Color(0xFF9CA3AF)),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(event: event)),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    return '${dt.day}/${dt.month}';
  }
}
