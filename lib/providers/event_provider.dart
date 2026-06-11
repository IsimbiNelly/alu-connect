import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event_model.dart';

class EventProvider extends ChangeNotifier {
  static const _savedIdsKey = 'saved_ids';
  static const _rsvpedIdsKey = 'rsvped_ids';
  static const _userEventsKey = 'user_events';

  final List<Event> _events = [
    Event(
      id: '1',
      title: 'ALU Entrepreneurship Pitch Night',
      description:
          'Showcase your startup idea, get feedback from mentors, and connect with fellow entrepreneurs at ALU Kigali.',
      date: 'May 24, 2026',
      time: '06:00 PM - 09:00 PM',
      location: 'Kigali Campus',
      category: 'Events',
      organizer: 'ALU Entrepreneurship Club',
      goingConnections: ['Placide', 'Rolande', 'Blessing'],
    ),
    Event(
      id: '2',
      title: 'AI for Social Impact Workshop',
      description:
          'Learn how AI tools can be used to drive social impact in Africa. Hands-on session with group projects.',
      date: 'Jun 5, 2026',
      time: '09:00 AM - 01:00 PM',
      location: 'Mauritius Campus',
      category: 'Workshop',
      organizer: 'ALU Tech Hub',
      goingConnections: ['Nkhomotabo', 'Tiffany'],
    ),
    Event(
      id: '3',
      title: 'Design Thinking Bootcamp',
      description:
          'A full day bootcamp on human-centered design. Perfect for students working on startup ideas or community projects.',
      date: 'May 30, 2026',
      time: '08:00 AM - 05:00 PM',
      location: 'Kigali Campus',
      category: 'Workshop',
      organizer: 'ALU Innovation Lab',
      goingConnections: ['Esther', 'Placide'],
    ),
    Event(
      id: '4',
      title: 'Sustainable Solutions Hackathon',
      description:
          'Build tech solutions for sustainability challenges facing East Africa. Teams of 3-5 students. Prizes available.',
      date: 'Jun 15, 2026',
      time: '08:00 AM - 08:00 PM',
      location: 'Kigali Campus',
      category: 'Hackathon',
      organizer: 'ALU Climate Action Club',
      goingConnections: ['Blessing', 'Rolande', 'Esther', 'Tiffany'],
    ),
    Event(
      id: '5',
      title: 'Campus Ambassador Program',
      description:
          'Apply to become an ALU Campus Ambassador and represent ALU at regional events and outreach programs.',
      date: 'May 22, 2026',
      time: '10:00 AM - 12:00 PM',
      location: 'Kigali Campus',
      category: 'Opportunity',
      organizer: 'ALU Student Affairs',
      goingConnections: ['Nkhomotabo'],
    ),
    Event(
      id: '6',
      title: 'Women in Leadership Summit',
      description:
          'A powerful summit bringing together women leaders from across Africa to inspire the next generation of ALU students.',
      date: 'Jun 20, 2026',
      time: '09:00 AM - 04:00 PM',
      location: 'Kigali Campus',
      category: 'Events',
      organizer: 'ALU Women in Leadership Club',
      goingConnections: ['Rolande', 'Blessing', 'Esther', 'Tiffany'],
    ),
    Event(
      id: '7',
      title: 'ALU Leadership Accelerator',
      description:
          'A 4-week leadership program designed to develop the next generation of African leaders through mentorship and real-world challenges.',
      date: 'Jul 1, 2026',
      time: '08:00 AM - 12:00 PM',
      location: 'Kigali Campus',
      category: 'Leadership',
      organizer: 'ALU Student Affairs',
      goingConnections: ['Placide', 'Esther'],
    ),
    Event(
      id: '8',
      title: 'Google Africa Internship Program',
      description:
          'Apply for a paid internship at Google Africa. Open to ALU students in tech, business, and design tracks.',
      date: 'Jul 10, 2026',
      time: '10:00 AM - 11:00 AM',
      location: 'Remote',
      category: 'Internships',
      organizer: 'Google Africa',
      goingConnections: ['Tiffany', 'Nkhomotabo', 'Blessing'],
    ),
  ];

  late final Future<void> initialized;

  EventProvider() {
    initialized = _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_savedIdsKey) ?? [];
    final rsvpedIds = prefs.getStringList(_rsvpedIdsKey) ?? [];
    final userEventsJson = prefs.getStringList(_userEventsKey) ?? [];

    for (final id in savedIds) {
      final idx = _events.indexWhere((e) => e.id == id);
      if (idx != -1) _events[idx].isSaved = true;
    }
    for (final id in rsvpedIds) {
      final idx = _events.indexWhere((e) => e.id == id);
      if (idx != -1) _events[idx].isRsvped = true;
    }
    for (final json in userEventsJson) {
      final event = Event.fromJson(jsonDecode(json) as Map<String, dynamic>);
      if (!_events.any((e) => e.id == event.id)) {
        _events.add(event);
      }
    }
    notifyListeners();
  }

  Future<void> _saveFlags() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _savedIdsKey, _events.where((e) => e.isSaved).map((e) => e.id).toList());
    await prefs.setStringList(
        _rsvpedIdsKey, _events.where((e) => e.isRsvped).map((e) => e.id).toList());
  }

  Future<void> _saveUserEvents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _userEventsKey,
      _events
          .where((e) => e.userCreated)
          .map((e) => jsonEncode(e.toJson()))
          .toList(),
    );
  }

  List<Event> get events => _events;

  List<Event> get savedEvents => _events.where((e) => e.isSaved).toList();
  List<Event> get rsvpedEvents => _events.where((e) => e.isRsvped).toList();

  int get savedCount => _events.where((e) => e.isSaved).length;
  int get rsvpedCount => _events.where((e) => e.isRsvped).length;

  List<Event> getByCategory(String category) {
    if (category == 'All') return _events;
    return _events.where((e) => e.category == category).toList();
  }

  void toggleSave(String eventId) {
    final event = _events.firstWhere((e) => e.id == eventId);
    event.isSaved = !event.isSaved;
    notifyListeners();
    _saveFlags();
  }

  void toggleRsvp(String eventId) {
    final event = _events.firstWhere((e) => e.id == eventId);
    event.isRsvped = !event.isRsvped;
    notifyListeners();
    _saveFlags();
  }

  void addEvent(Event event) {
    _events.insert(0, event);
    notifyListeners();
    _saveUserEvents();
  }
}
