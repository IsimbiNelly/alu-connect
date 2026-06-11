import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _chats = {};

  late final Future<void> initialized;

  ChatProvider() {
    initialized = _load();
  }

  List<ChatMessage> getMessages(String eventId) =>
      List.unmodifiable(_chats[eventId] ?? []);

  void sendMessage(String eventId, String text) {
    if (text.trim().isEmpty) return;
    _chats.putIfAbsent(eventId, () => []);
    _chats[eventId]!.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      eventId: eventId,
      sender: 'You',
      text: text.trim(),
      timestamp: DateTime.now(),
      isMe: true,
    ));
    notifyListeners();
    _save(eventId);
  }

  void ensureWelcome(String eventId, String eventTitle) {
    if (_chats.containsKey(eventId) && _chats[eventId]!.isNotEmpty) return;
    _chats[eventId] = [
      ChatMessage(
        id: 'welcome_$eventId',
        eventId: eventId,
        sender: 'System',
        text: 'Welcome to the $eventTitle chatroom! Start the conversation.',
        timestamp: DateTime.now(),
        isSystem: true,
      ),
    ];
    notifyListeners();
    _save(eventId);
  }

  void editMessage(String eventId, String messageId, String newText) {
    if (newText.trim().isEmpty) return;
    final msgs = _chats[eventId];
    if (msgs == null) return;
    final idx = msgs.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;
    msgs[idx] = msgs[idx].copyWith(text: newText.trim(), isEdited: true);
    notifyListeners();
    _save(eventId);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final chatKeys = prefs.getKeys().where((k) => k.startsWith('chat_'));
    for (final key in chatKeys) {
      final eventId = key.substring(5); // remove 'chat_' prefix
      final jsonList = prefs.getStringList(key) ?? [];
      _chats[eventId] = jsonList
          .map((j) => ChatMessage.fromJson(
              jsonDecode(j) as Map<String, dynamic>))
          .toList();
    }
    if (_chats.isNotEmpty) notifyListeners();
  }

  Future<void> _save(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final msgs = _chats[eventId] ?? [];
    await prefs.setStringList(
      'chat_$eventId',
      msgs.map((m) => jsonEncode(m.toJson())).toList(),
    );
  }
}
