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
  final bool userCreated;
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
    this.goingConnections = const [],
    this.userCreated = false,
    this.isRsvped = false,
    this.isSaved = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'category': category,
        'organizer': organizer,
        'goingConnections': goingConnections,
        'userCreated': userCreated,
        'isRsvped': isRsvped,
        'isSaved': isSaved,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        location: json['location'] as String,
        category: json['category'] as String,
        organizer: json['organizer'] as String,
        goingConnections:
            (json['goingConnections'] as List<dynamic>).cast<String>(),
        userCreated: json['userCreated'] as bool? ?? false,
        isRsvped: json['isRsvped'] as bool? ?? false,
        isSaved: json['isSaved'] as bool? ?? false,
      );
}
