class ChatMessage {
  final String id;
  final String eventId;
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool isEdited;
  final bool isSystem;

  const ChatMessage({
    required this.id,
    required this.eventId,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isMe = false,
    this.isEdited = false,
    this.isSystem = false,
  });

  ChatMessage copyWith({String? text, bool? isEdited}) => ChatMessage(
        id: id,
        eventId: eventId,
        sender: sender,
        text: text ?? this.text,
        timestamp: timestamp,
        isMe: isMe,
        isEdited: isEdited ?? this.isEdited,
        isSystem: isSystem,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'sender': sender,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'isMe': isMe,
        'isEdited': isEdited,
        'isSystem': isSystem,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        eventId: json['eventId'] as String,
        sender: json['sender'] as String,
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isMe: json['isMe'] as bool,
        isEdited: json['isEdited'] as bool,
        isSystem: json['isSystem'] as bool? ?? false,
      );
}
