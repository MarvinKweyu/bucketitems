import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Notes> futureNotes;

  // use initState to call getNotes() and assign the result to futureNote
  // change to didChangeDependencies
  @override
  void initState() {
    super.initState();
    futureNotes = getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taker',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
        appBar: AppBar(title: const Text('Note Taker')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: FutureBuilder<Notes>(
            future: futureNotes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // return Text(snapshot.data!.title);
                return ListView.builder(
                    itemCount: snapshot.data!.notes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data!.notes[index].title),
                        subtitle: Text(snapshot.data!.notes[index].body),
                        autofocus: true,
                      );
                    });
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // show default spinner by default
              return const CircularProgressIndicator();
            },
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _createNote,
          tooltip: 'Take a note',
          child: const Icon(Icons.add),
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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

Future<Notes> getNotes() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    print(response.body);
    return Notes.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load note');
  }
}

_createNote() {
  print("Create a note");
}
