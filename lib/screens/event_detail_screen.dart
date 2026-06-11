import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_message.dart';
import '../models/event_model.dart';
import '../providers/chat_provider.dart';
import '../providers/event_provider.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();
  bool _welcomeEnsured = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_welcomeEnsured) {
      _welcomeEnsured = true;
      Provider.of<ChatProvider>(context, listen: false)
          .ensureWelcome(widget.event.id, widget.event.title);
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(ChatProvider provider) {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    provider.sendMessage(widget.event.id, text);
    _chatController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showEditDialog(BuildContext context, ChatProvider provider,
      String messageId, String currentText) {
    final editController = TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit message'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.editMessage(
                  widget.event.id, messageId, editController.text);
              Navigator.pop(context);
            },
            child: const Text('Save',
                style: TextStyle(color: Color(0xFF5B21B6))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF5B21B6)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Consumer<EventProvider>(
              builder: (context, provider, _) => IconButton(
                icon: Icon(
                  widget.event.isSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: const Color(0xFF5B21B6),
                ),
                onPressed: () => provider.toggleSave(widget.event.id),
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Color(0xFF5B21B6),
            unselectedLabelColor: Color(0xFF9CA3AF),
            indicatorColor: Color(0xFF5B21B6),
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Chat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetailsTab(),
            _buildChatTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return Consumer<EventProvider>(
      builder: (context, provider, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventHeader(),
            const SizedBox(height: 24),
            _infoRow(Icons.calendar_today, widget.event.date),
            const SizedBox(height: 12),
            _infoRow(Icons.access_time, widget.event.time),
            const SizedBox(height: 12),
            _infoRow(Icons.location_on, widget.event.location),
            const SizedBox(height: 24),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.event.description,
              style: const TextStyle(
                  fontSize: 14, color: Colors.black54, height: 1.6),
            ),
            const SizedBox(height: 24),
            if (widget.event.goingConnections.isNotEmpty) ...[
              const Text(
                'People you know going',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Color(0xFF5B21B6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${widget.event.goingConnections.join(', ')} are going',
                        style: const TextStyle(
                          color: Color(0xFF5B21B6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => provider.toggleRsvp(widget.event.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.event.isRsvped
                      ? Colors.grey.shade300
                      : const Color(0xFF5B21B6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  widget.event.isRsvped ? 'Cancel RSVP' : 'RSVP Now',
                  style: TextStyle(
                    color: widget.event.isRsvped
                        ? Colors.black54
                        : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventHeader() {
    final hasImage = widget.event.imagePath != null &&
        widget.event.imagePath!.isNotEmpty;
    if (hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.file(
              File(widget.event.imagePath!),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5B21B6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.event.category,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.event.organizer,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5B21B6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.event.category,
              style:
                  const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.event.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.event.organizer,
            style: TextStyle(
                color: Colors.white.withAlpha(200), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTab() {
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        final messages = provider.getMessages(widget.event.id);
        return Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet.\nBe the first to say something!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF9CA3AF), fontSize: 14),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) =>
                          _buildMessage(context, provider, messages[index]),
                    ),
            ),
            _buildInput(provider),
          ],
        );
      },
    );
  }

  Widget _buildMessage(BuildContext context, ChatProvider provider,
      ChatMessage msg) {
    if (msg.isSystem) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            msg.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF5B21B6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: msg.isMe
          ? () => _showEditDialog(context, provider, msg.id, msg.text)
          : null,
      child: Align(
        alignment:
            msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          child: Column(
            crossAxisAlignment: msg.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (!msg.isMe)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 4, bottom: 4),
                  child: Text(
                    msg.sender,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: msg.isMe
                      ? const Color(0xFF5B21B6)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft:
                        Radius.circular(msg.isMe ? 16 : 4),
                    bottomRight:
                        Radius.circular(msg.isMe ? 4 : 16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      msg.text,
                      style: TextStyle(
                        color: msg.isMe
                            ? Colors.white
                            : const Color(0xFF1F1F1F),
                        fontSize: 14,
                      ),
                    ),
                    if (msg.isEdited)
                      Text(
                        'edited',
                        style: TextStyle(
                          fontSize: 10,
                          color: msg.isMe
                              ? Colors.white.withValues(alpha: 0.7)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(ChatProvider provider) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(provider),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle:
                    const TextStyle(color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF5B21B6),
            child: IconButton(
              icon: const Icon(Icons.send,
                  color: Colors.white, size: 18),
              onPressed: () => _send(provider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5B21B6), size: 20),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                fontSize: 14, color: Colors.black87)),
      ],
    );
  }
}
