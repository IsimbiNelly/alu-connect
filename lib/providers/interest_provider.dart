import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterestProvider extends ChangeNotifier {
  static const _key = 'user_interests';
  static const _defaults = [
    'Technology',
    'Leadership',
    'Startups',
    'Design',
    'Community',
  ];

  static const availableInterests = [
    'Technology',
    'Leadership',
    'Startups',
    'Design',
    'Community',
    'Artificial Intelligence',
    'Data Science',
    'Entrepreneurship',
    'Climate & Sustainability',
    'Finance',
    'Marketing',
    'Healthcare',
    'Education',
    'Agriculture',
    'Policy & Governance',
    'Media & Communications',
    'Social Impact',
    'Research',
    'Sports',
    'Arts & Culture',
    'Networking',
    'Public Speaking',
    'Software Engineering',
    'Cybersecurity',
  ];

  List<String> _interests = List.of(_defaults);

  late final Future<void> initialized;

  InterestProvider() {
    initialized = _load();
  }

  List<String> get interests => List.unmodifiable(_interests);

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    if (saved != null) {
      _interests = saved;
      notifyListeners();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _interests);
  }

  void add(String interest) {
    final trimmed = interest.trim();
    if (trimmed.isEmpty) return;
    if (_interests.any(
        (i) => i.toLowerCase() == trimmed.toLowerCase())) {
      return;
    }
    _interests.add(trimmed);
    notifyListeners();
    _save();
  }

  void remove(String interest) {
    _interests.remove(interest);
    notifyListeners();
    _save();
  }
}
