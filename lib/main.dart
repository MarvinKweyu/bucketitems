import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bucketitems/models/notes.dart';
import 'package:bucketitems/models/note.dart';
import 'package:bucketitems/pages/note_page.dart';
import 'package:bucketitems/pages/new_note.dart';

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
      home: const MyHomePage(title: 'Notes on the Go'),
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
                // print(snapshot.data)
                // return Text(snapshot.data!.title);
                return ListView.builder(
                    itemCount: snapshot.data!.notes.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            // item id

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotePage(
                                        title: 'Note',
                                        noteId:
                                            snapshot.data!.notes[index].id)));
                          },
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  title: Text(snapshot.data!.notes[index].title,
                                      style: MaterialStateTextStyle.resolveWith(
                                          (states) => const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20))),
                                  subtitle:
                                      Text(snapshot.data!.notes[index].body)),
                              // ignore: prefer_const_constructors
                              Divider(),
                            ],
                          ));
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
          onPressed: () {
            // go to the NotePage
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const NewNotePage(title: 'Create a memory')),
            );
          },
          tooltip: 'Take a note',
          child: const Icon(Icons.add),
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<Notes> getNotes() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode == 200) {
    return Notes.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load note');
  }
}
