import 'package:flutter/material.dart';

class NewNotePage extends StatelessWidget {
  const NewNotePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const NoteForm(),
      // body: Text('Note Form'),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // text fields and elevated button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              autofillHints: const [AutofillHints.name],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null; // Return null when the input is valid
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null; // Return null when the input is valid
              },
            ),
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
