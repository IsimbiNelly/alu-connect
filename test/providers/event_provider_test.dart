import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:alu_connect/models/event_model.dart';
import 'package:alu_connect/providers/event_provider.dart';

void main() {
  late EventProvider provider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    provider = EventProvider();
    await provider.initialized;
  });

  group('EventProvider', () {
    test('loads 8 seeded events', () {
      expect(provider.events.length, 8);
    });

    test('starts with no saved events', () {
      expect(provider.savedEvents, isEmpty);
      expect(provider.savedCount, 0);
    });

    test('starts with no RSVPed events', () {
      expect(provider.rsvpedCount, 0);
    });

    test('toggleSave marks event as saved', () {
      provider.toggleSave('1');
      expect(provider.events.firstWhere((e) => e.id == '1').isSaved, true);
      expect(provider.savedCount, 1);
    });

    test('toggleSave unmarks a saved event', () {
      provider.toggleSave('1');
      provider.toggleSave('1');
      expect(provider.events.firstWhere((e) => e.id == '1').isSaved, false);
      expect(provider.savedCount, 0);
    });

    test('toggleRsvp marks event as RSVPed', () {
      provider.toggleRsvp('2');
      expect(provider.events.firstWhere((e) => e.id == '2').isRsvped, true);
      expect(provider.rsvpedCount, 1);
    });

    test('toggleRsvp unmarks an RSVPed event', () {
      provider.toggleRsvp('2');
      provider.toggleRsvp('2');
      expect(provider.events.firstWhere((e) => e.id == '2').isRsvped, false);
      expect(provider.rsvpedCount, 0);
    });

    test('rsvpedEvents returns only RSVPed events', () {
      provider.toggleRsvp('1');
      provider.toggleRsvp('3');
      expect(provider.rsvpedEvents.length, 2);
      expect(provider.rsvpedEvents.any((e) => e.id == '1'), true);
      expect(provider.rsvpedEvents.any((e) => e.id == '3'), true);
    });

    test('savedEvents returns only saved events', () {
      provider.toggleSave('1');
      provider.toggleSave('3');
      expect(provider.savedEvents.length, 2);
      expect(provider.savedEvents.any((e) => e.id == '1'), true);
      expect(provider.savedEvents.any((e) => e.id == '3'), true);
    });

    test('addEvent inserts at front of list', () {
      final initial = provider.events.length;
      provider.addEvent(Event(
        id: 'new1',
        title: 'Test',
        description: 'Desc',
        date: 'Jun 11, 2026',
        time: '10:00 AM',
        location: 'Campus',
        category: 'Events',
        organizer: 'Me',
        userCreated: true,
      ));
      expect(provider.events.length, initial + 1);
      expect(provider.events.first.id, 'new1');
    });

    test('addEvent marks event with userCreated=true', () {
      provider.addEvent(Event(
        id: 'uc1',
        title: 'My Event',
        description: 'Desc',
        date: 'Jun 12, 2026',
        time: '11:00 AM',
        location: 'Online',
        category: 'Events',
        organizer: 'Student',
        userCreated: true,
      ));
      expect(provider.events.firstWhere((e) => e.id == 'uc1').userCreated, true);
    });
  });
}
