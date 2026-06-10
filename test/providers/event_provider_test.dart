import 'package:flutter_test/flutter_test.dart';
import 'package:alu_connect/providers/event_provider.dart';

void main() {
  group('EventProvider', () {
    late EventProvider provider;

    setUp(() {
      provider = EventProvider();
    });

    test('starts with 6 events', () {
      expect(provider.events.length, 6);
    });

    test('starts with no saved events', () {
      expect(provider.savedEvents, isEmpty);
      expect(provider.savedCount, 0);
    });

    test('starts with no RSVPed events', () {
      expect(provider.rsvpedCount, 0);
    });

    test('toggleSave adds eventId', () {
      provider.toggleSave('event_001');
      expect(provider.isSaved('event_001'), true);
      expect(provider.savedCount, 1);
    });

    test('toggleSave removes eventId when already saved', () {
      provider.toggleSave('event_001');
      provider.toggleSave('event_001');
      expect(provider.isSaved('event_001'), false);
      expect(provider.savedCount, 0);
    });

    test('toggleRsvp adds eventId', () {
      provider.toggleRsvp('event_002');
      expect(provider.isRsvped('event_002'), true);
      expect(provider.rsvpedCount, 1);
    });

    test('toggleRsvp removes eventId when already RSVPed', () {
      provider.toggleRsvp('event_002');
      provider.toggleRsvp('event_002');
      expect(provider.isRsvped('event_002'), false);
      expect(provider.rsvpedCount, 0);
    });

    test('savedEvents returns only saved events', () {
      provider.toggleSave('event_001');
      provider.toggleSave('event_003');
      final saved = provider.savedEvents;
      expect(saved.length, 2);
      expect(saved.any((e) => e.eventId == 'event_001'), true);
      expect(saved.any((e) => e.eventId == 'event_003'), true);
    });

    test('isSaved returns false for unsaved event', () {
      expect(provider.isSaved('event_999'), false);
    });

    test('isRsvped returns false for non-RSVPed event', () {
      expect(provider.isRsvped('event_999'), false);
    });
  });
}
