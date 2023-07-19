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
  late Future<Note> futureNote;

  // use initState to call getNotes() and assign the result to futureNote
  // change to didChangeDependencies
  @override
  void initState() {
    super.initState();
    futureNote = getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taker',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: Scaffold(
          appBar: AppBar(title: const Text('Note Taker')),
          body: Center(
              child: FutureBuilder<Note>(
            future: futureNote,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // show default spinner by default
              return const CircularProgressIndicator();
            },
          ))), // This trailing comma makes auto-formatting nicer for build methods.
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

Future<Note> getNotes() async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));

  if (response.statusCode == 200) {
    return Note.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load note');
  }
}
