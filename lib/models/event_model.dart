class Event {
  final String eventId;
  final String title;
  final String category;
  final String date;
  final String location;
  final String description;
  final String organizer;

  const Event({
    required this.eventId,
    required this.title,
    required this.category,
    required this.date,
    required this.location,
    required this.description,
    required this.organizer,
  });
}
