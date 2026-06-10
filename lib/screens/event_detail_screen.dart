import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event_model.dart';
import '../providers/event_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5B21B6)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              event.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: const Color(0xFF5B21B6),
            ),
            onPressed: () => provider.toggleSave(event.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF5B21B6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.category,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.organizer,
                    style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _infoRow(Icons.calendar_today, event.date),
            const SizedBox(height: 12),
            _infoRow(Icons.access_time, event.time),
            const SizedBox(height: 12),
            _infoRow(Icons.location_on, event.location),
            const SizedBox(height: 24),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
            ),
            const SizedBox(height: 24),
            if (event.goingConnections.isNotEmpty) ...[
              const Text(
                'People you know going',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Color(0xFF5B21B6)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${event.goingConnections.join(', ')} are going',
                        style: const TextStyle(
                          color: Color(0xFF5B21B6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => provider.toggleRsvp(event.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: event.isRsvped
                      ? Colors.grey.shade300
                      : const Color(0xFF5B21B6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  event.isRsvped ? 'Cancel RSVP' : 'RSVP Now',
                  style: TextStyle(
                    color: event.isRsvped ? Colors.black54 : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF5B21B6), size: 20),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }
}