import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

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
          'Saved Opportunities',
          style: TextStyle(
              color: Color(0xFF1F1F1F), fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, _) {
          final saved = provider.savedEvents;
          if (saved.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bookmark_border,
                        size: 64, color: Color(0xFF9CA3AF)),
                    SizedBox(height: 16),
                    Text(
                      'No saved opportunities yet',
                      style: TextStyle(
                          fontSize: 16, color: Color(0xFF6B7280)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the bookmark icon on any event to save it here.',
                      style: TextStyle(
                          fontSize: 13, color: Color(0xFF9CA3AF)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: saved.length,
            itemBuilder: (context, index) {
              final event = saved[index];
              return EventCard(
                event: event,
                isSaved: true,
                onSave: () => provider.toggleSave(event.eventId),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventDetailsScreen(event: event),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
