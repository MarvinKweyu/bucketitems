import 'package:bucketitems/models/note.dart';

class Notes {
  final List<Note> notes;

  Notes({
    required this.notes,
  });

  factory Notes.fromJson(List<dynamic> json) {
    List<Note> notes = [];
    notes = json.map((e) => Note.fromJson(e)).toList();
    return Notes(notes: notes);
  }
}
