class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String location;
  final String category;
  final String organizer;
  final List<String> goingConnections;
  bool isRsvped;
  bool isSaved;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.category,
    required this.organizer,
    this.goingConnections = const[],
    this.isRsvped = false,
    this.isSaved = false,
  }); 

}
