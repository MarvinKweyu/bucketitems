
class Note {
  final int id;
  final int userId;
  final String title;
  final String body;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }
}