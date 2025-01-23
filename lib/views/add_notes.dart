import 'package:flutter/material.dart';

import '../custom_form_text_field.dart';
import '../database_helper.dart';
import 'home_page.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController controllerTitle = TextEditingController();
  TextEditingController controllerDescription = TextEditingController();

  void saveData() async {
    String title = controllerTitle.text; // Trim removes any extra spaces
    String description = controllerDescription.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      await DBHelper.insertDB(title, description);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved successfully!')),
      );
     Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage())); // Navigate back after saving
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter title and description'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.grey.shade100,
        title: const Text('Add Notes'),
        actions: [
          IconButton(
            onPressed: () {
              saveData();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: FloatingActionButton(
          onPressed: () {
            saveData();
          },
          backgroundColor: Colors.grey.shade100,
          child: const Icon(
            Icons.edit,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: CustomFormTextField(
                  controller: controllerTitle,
                  maxLines: 1,
                  hintText: 'Add new title',

                ),
              ),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: CustomFormTextField(
                  labelText: 'Description' ,
                  controller: controllerDescription,
                  maxLines: 10,
                  hintText: 'Add new description',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
