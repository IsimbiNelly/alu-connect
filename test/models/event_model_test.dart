import 'package:flutter_test/flutter_test.dart';
import 'package:alu_connect/models/event_model.dart';

void main() {
  group('Event', () {
    test('creates an event with all required fields', () {
      const event = Event(
        eventId: 'event_001',
        title: 'Flutter Workshop',
        category: 'Workshops',
        date: 'June 15, 2025',
        location: 'Room 204',
        description: 'Learn Flutter',
        organizer: 'Tech Club',
      );

      expect(event.eventId, 'event_001');
      expect(event.title, 'Flutter Workshop');
      expect(event.category, 'Workshops');
      expect(event.date, 'June 15, 2025');
      expect(event.location, 'Room 204');
      expect(event.description, 'Learn Flutter');
      expect(event.organizer, 'Tech Club');
    });
  });
}
