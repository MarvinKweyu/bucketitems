// ignore_for_file: unnecessary_const

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bucketitems/models/notes.dart';

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
                      return Column(
                        children: <Widget>[
                          ListTile(
                              title: Text(snapshot.data!.notes[index].title,
                                  style: MaterialStateTextStyle.resolveWith(
                                      (states) => const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))),
                              subtitle: Text(snapshot.data!.notes[index].body)),
                          // ignore: prefer_const_constructors
                          Divider(),
                        ],
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

class NotePage extends StatelessWidget {
  const NotePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Text('Note Page'),
      ),
    );
  }
}

class NewNotePage extends StatelessWidget {
  const NewNotePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const NoteForm(),
    );
  }
}

class NoteForm extends StatefulWidget {
  const NoteForm({super.key});

  @override
  NoteFormState createState() => NoteFormState();
}

class NoteFormState extends State<NoteForm> {
  // create global key that uniquely identifies the Form widget
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // build a form widget using _formkey created above
    return Form(
      key: _formKey,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // text fields and elevated button
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null; // Return null when the input is valid
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // return true of the form is valid or false otherwise
                if (_formKey.currentState!.validate()) {
                  // if the form is valid, display a snackbar
                  // ToDo: change this to a post request
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          )
        ],
      ),
    );
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
