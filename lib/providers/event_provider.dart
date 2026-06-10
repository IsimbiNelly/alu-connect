import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> events = [
    const Event(
      eventId: 'event_001',
      title: 'Flutter Development Workshop',
      category: 'Workshops',
      date: 'June 15, 2025',
      location: 'ALU Campus - Room 204',
      description:
          'Learn to build mobile apps with Flutter and Dart. This hands-on workshop covers widgets, state management, and navigation.',
      organizer: 'ALU Tech Club',
    ),
    const Event(
      eventId: 'event_002',
      title: 'ALU Hackathon 2025',
      category: 'Hackathons',
      date: 'June 20, 2025',
      location: 'ALU Main Hall',
      description:
          'Build innovative solutions for African challenges. Form teams, design, and prototype in 48 hours.',
      organizer: 'ALU Innovation Hub',
    ),
    const Event(
      eventId: 'event_003',
      title: 'Google Summer Internship',
      category: 'Internships',
      date: 'July 1, 2025',
      location: 'Remote',
      description:
          'Internship opportunity at Google for ALU students. Apply for a 12-week summer program with top engineers.',
      organizer: 'Career Services',
    ),
    const Event(
      eventId: 'event_004',
      title: 'Leadership Bootcamp',
      category: 'Leadership',
      date: 'June 25, 2025',
      location: 'ALU Campus',
      description:
          'Develop your leadership skills with industry mentors. Three-day intensive program covering communication, decision-making, and team building.',
      organizer: 'ALU Leadership Center',
    ),
    const Event(
      eventId: 'event_005',
      title: 'Startup Pitch Night',
      category: 'Startups',
      date: 'July 5, 2025',
      location: 'ALU Innovation Hub',
      description:
          'Pitch your startup idea to investors and mentors. Top pitches receive seed funding consideration.',
      organizer: 'ALU Entrepreneurship Club',
    ),
    const Event(
      eventId: 'event_006',
      title: 'Community Service Day',
      category: 'Events',
      date: 'July 10, 2025',
      location: 'Kigali City Center',
      description:
          'Join fellow students in giving back to the community. Activities include tutoring, clean-up, and outreach.',
      organizer: 'ALU Community Club',
    ),
  ];

  final Set<String> _savedIds = {};
  final Set<String> _rsvpedIds = {};

  bool isSaved(String eventId) => _savedIds.contains(eventId);
  bool isRsvped(String eventId) => _rsvpedIds.contains(eventId);

  int get savedCount => _savedIds.length;
  int get rsvpedCount => _rsvpedIds.length;

  List<Event> get savedEvents =>
      events.where((e) => _savedIds.contains(e.eventId)).toList();

  void toggleSave(String eventId) {
    if (_savedIds.contains(eventId)) {
      _savedIds.remove(eventId);
    } else {
      _savedIds.add(eventId);
    }
    notifyListeners();
  }

  void toggleRsvp(String eventId) {
    if (_rsvpedIds.contains(eventId)) {
      _rsvpedIds.remove(eventId);
    } else {
      _rsvpedIds.add(eventId);
    }
    notifyListeners();
  }
}
