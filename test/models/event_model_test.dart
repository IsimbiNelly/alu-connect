import 'package:flutter_test/flutter_test.dart';
import 'package:alu_connect/models/event_model.dart';

void main() {
  group('Event', () {
    final event = Event(
      id: 'e1',
      title: 'Flutter Workshop',
      description: 'Learn Flutter',
      date: 'Jun 15, 2026',
      time: '09:00 AM - 12:00 PM',
      location: 'Room 204',
      category: 'Workshop',
      organizer: 'Tech Club',
    );

    test('creates with required fields and sensible defaults', () {
      expect(event.id, 'e1');
      expect(event.title, 'Flutter Workshop');
      expect(event.isSaved, false);
      expect(event.isRsvped, false);
      expect(event.userCreated, false);
      expect(event.goingConnections, isEmpty);
    });

    test('toJson includes all fields', () {
      final json = event.toJson();
      expect(json['id'], 'e1');
      expect(json['title'], 'Flutter Workshop');
      expect(json['description'], 'Learn Flutter');
      expect(json['userCreated'], false);
      expect(json['isSaved'], false);
      expect(json['isRsvped'], false);
      expect(json['goingConnections'], isEmpty);
    });

    test('fromJson round-trips all fields', () {
      final modified = Event(
        id: 'e2',
        title: 'Leadership Summit',
        description: 'ALU leaders',
        date: 'Jul 1, 2026',
        time: '10:00 AM',
        location: 'Kigali',
        category: 'Leadership',
        organizer: 'Student Council',
        goingConnections: ['Alice', 'Bob'],
        userCreated: true,
        isRsvped: true,
        isSaved: true,
      );
      final restored = Event.fromJson(modified.toJson());
      expect(restored.id, modified.id);
      expect(restored.title, modified.title);
      expect(restored.description, modified.description);
      expect(restored.date, modified.date);
      expect(restored.time, modified.time);
      expect(restored.location, modified.location);
      expect(restored.category, modified.category);
      expect(restored.organizer, modified.organizer);
      expect(restored.goingConnections, ['Alice', 'Bob']);
      expect(restored.userCreated, true);
      expect(restored.isRsvped, true);
      expect(restored.isSaved, true);
    });
  });
}
