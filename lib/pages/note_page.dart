import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bucketitems/models/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key, required this.title, required this.noteId});

  final String title;
  final int noteId;

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Future<Note> futureNote;

  @override
  void initState() {
    super.initState();
    // get the note with the id
    futureNote = getNote(widget.noteId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Center(
            child: FutureBuilder<Note>(
          future: futureNote,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      snapshot.data!.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(snapshot.data!.body)
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // show default spinner by default
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

Future<Note> getNote(int noteId) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/$noteId'));

  if (response.statusCode == 200) {
    return Note.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load note');
  }
}
