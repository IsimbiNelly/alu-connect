import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alu_connect/providers/chat_provider.dart';

void main() {
  late ChatProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = ChatProvider();
    await provider.initialized;
  });

  group('ChatProvider', () {
    test('getMessages returns empty list for unknown event', () {
      expect(provider.getMessages('unknown'), isEmpty);
    });

    test('sendMessage adds a message from "You"', () {
      provider.sendMessage('e1', 'Hello');
      final msgs = provider.getMessages('e1');
      expect(msgs.length, 1);
      expect(msgs.first.text, 'Hello');
      expect(msgs.first.isMe, true);
      expect(msgs.first.sender, 'You');
      expect(msgs.first.eventId, 'e1');
    });

    test('sendMessage ignores blank text', () {
      provider.sendMessage('e1', '   ');
      expect(provider.getMessages('e1'), isEmpty);
    });

    test('sendMessage trims whitespace from text', () {
      provider.sendMessage('e1', '  Hello  ');
      expect(provider.getMessages('e1').first.text, 'Hello');
    });

    test('editMessage updates text and sets isEdited', () {
      provider.sendMessage('e1', 'Original');
      final id = provider.getMessages('e1').first.id;
      provider.editMessage('e1', id, 'Updated');
      final msg = provider.getMessages('e1').first;
      expect(msg.text, 'Updated');
      expect(msg.isEdited, true);
    });

    test('editMessage ignores blank new text', () {
      provider.sendMessage('e1', 'Original');
      final id = provider.getMessages('e1').first.id;
      provider.editMessage('e1', id, '   ');
      expect(provider.getMessages('e1').first.text, 'Original');
      expect(provider.getMessages('e1').first.isEdited, false);
    });

    test('editMessage does nothing for unknown message id', () {
      provider.sendMessage('e1', 'Hello');
      provider.editMessage('e1', 'nonexistent-id', 'Updated');
      expect(provider.getMessages('e1').first.text, 'Hello');
    });

    test('ensureWelcome seeds a system message for empty room', () {
      provider.ensureWelcome('e1', 'Flutter Workshop');
      final msgs = provider.getMessages('e1');
      expect(msgs.length, 1);
      expect(msgs.first.isSystem, true);
      expect(msgs.first.text, contains('Flutter Workshop'));
    });

    test('ensureWelcome does not overwrite an existing room', () {
      provider.sendMessage('e1', 'Already here');
      provider.ensureWelcome('e1', 'Flutter Workshop');
      expect(provider.getMessages('e1').length, 1);
      expect(provider.getMessages('e1').first.isSystem, false);
    });

    test('messages are independent per event', () {
      provider.sendMessage('e1', 'Chat 1');
      provider.sendMessage('e2', 'Chat 2');
      expect(provider.getMessages('e1').length, 1);
      expect(provider.getMessages('e2').length, 1);
      expect(provider.getMessages('e1').first.text, 'Chat 1');
      expect(provider.getMessages('e2').first.text, 'Chat 2');
    });
  });
}
