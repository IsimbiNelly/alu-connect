import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';
import '../widgets/custom_button.dart';
import 'chat_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F1F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Event Details',
          style: TextStyle(
              color: Color(0xFF1F1F1F), fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          final saved = provider.isSaved(event.eventId);
          final rsvped = provider.isRsvped(event.eventId);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFF5B21B6),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              color: Color(0xFF5B21B6), size: 18),
                          const SizedBox(width: 8),
                          Text(event.date,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF1F1F1F))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Color(0xFF5B21B6), size: 18),
                          const SizedBox(width: 8),
                          Text(event.location,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF1F1F1F))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Color(0xFF5B21B6), size: 18),
                          const SizedBox(width: 8),
                          Text(event.organizer,
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF1F1F1F))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'About this Event',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F1F)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            height: 1.6),
                      ),
                      const SizedBox(height: 28),
                      CustomButton(
                        label: rsvped ? "RSVP'd ✓" : 'RSVP to Event',
                        filled: true,
                        onPressed: () =>
                            provider.toggleRsvp(event.eventId),
                        icon: rsvped
                            ? Icons.check_circle
                            : Icons.event_available,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        label:
                            saved ? 'Saved ✓' : 'Save Opportunity',
                        filled: false,
                        onPressed: () =>
                            provider.toggleSave(event.eventId),
                        icon: saved
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatScreen(eventTitle: event.title),
                          ),
                        ),
                        icon: const Icon(Icons.chat_bubble_outline,
                            color: Color(0xFF5B21B6)),
                        label: const Text(
                          'Open Chat',
                          style: TextStyle(
                              color: Color(0xFF5B21B6),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
