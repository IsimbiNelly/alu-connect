import 'package:flutter_test/flutter_test.dart';
import 'package:alu_connect/models/chat_message.dart';

void main() {
  group('ChatMessage', () {
    final msg = ChatMessage(
      id: 'm1',
      eventId: 'e1',
      sender: 'You',
      text: 'Hello world',
      timestamp: DateTime(2026, 6, 11, 10, 0),
      isMe: true,
    );

    test('creates with isEdited and isSystem defaulting to false', () {
      expect(msg.isEdited, false);
      expect(msg.isSystem, false);
      expect(msg.isMe, true);
      expect(msg.sender, 'You');
    });

    test('copyWith updates text and isEdited, preserves rest', () {
      final updated = msg.copyWith(text: 'Updated', isEdited: true);
      expect(updated.text, 'Updated');
      expect(updated.isEdited, true);
      expect(updated.id, msg.id);
      expect(updated.eventId, msg.eventId);
      expect(updated.sender, msg.sender);
      expect(updated.isMe, msg.isMe);
    });

    test('copyWith with no args is a no-op', () {
      final copy = msg.copyWith();
      expect(copy.text, msg.text);
      expect(copy.isEdited, msg.isEdited);
    });

    test('toJson/fromJson round-trips all fields', () {
      final json = msg.toJson();
      final restored = ChatMessage.fromJson(json);
      expect(restored.id, msg.id);
      expect(restored.eventId, msg.eventId);
      expect(restored.sender, msg.sender);
      expect(restored.text, msg.text);
      expect(restored.timestamp, msg.timestamp);
      expect(restored.isMe, msg.isMe);
      expect(restored.isEdited, msg.isEdited);
      expect(restored.isSystem, msg.isSystem);
    });

    test('system message has isSystem true and isMe false', () {
      final system = ChatMessage(
        id: 'welcome_e1',
        eventId: 'e1',
        sender: 'System',
        text: 'Welcome to the Test Event chatroom!',
        timestamp: DateTime(2026, 6, 11),
        isSystem: true,
      );
      expect(system.isSystem, true);
      expect(system.isMe, false);
    });
  });
}
