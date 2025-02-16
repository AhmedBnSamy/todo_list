import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/themdata_cubit.dart';
import '../custom_form_text_field.dart';
import '../database_helper.dart';
import 'home_page.dart';

class NotePage extends StatefulWidget {
  final int? noteId; // ID of the note to edit (null for adding a new note)
  final String? initialTitle; // Initial title of the note (null for adding a new note)
  final String? initialContent; // Initial content of the note (null for adding a new note)

  const NotePage({
    super.key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveOrUpdateNote() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      if (widget.noteId == null) {
        // Adding a new note
        await DBHelper.insertDB(title, content);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully!')),
        );
      } else {
        // Updating an existing note
        await DBHelper.updateNote(widget.noteId!, title, content);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note updated successfully!')),
        );
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage()));
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
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        return Scaffold(
          backgroundColor: theme == AppTheme.dark ? Colors.black12 : Colors.white,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage()));
              },
              icon: const Icon(Icons.arrow_back),
            ),
            backgroundColor: theme == AppTheme.dark ? Colors.black12 : Colors.white,
            title: Text(
              widget.noteId == null ? 'Add Notes' : 'Edit Note',
              style: TextStyle(
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
            ),
            actions: [
              IconButton(
                onPressed: _saveOrUpdateNote,
                icon: Icon(
                  Icons.save,
                  color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: widget.noteId == null
              ? Padding(
            padding:  EdgeInsets.symmetric(vertical: 20),
            child: FloatingActionButton(
              shape: CircleBorder(side: BorderSide(
                  width: 3,
                  color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red)),

          onPressed: _saveOrUpdateNote,
              backgroundColor: theme == AppTheme.light ? Colors.white : Colors.black,
              child: Icon(
                Icons.edit,
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
            ),
          )
              : null,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: CustomFormTextField(
                      controller: _titleController,
                      maxLines: 1,
                      hintText: 'Add new title',

                    ),
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: CustomFormTextField(
                      labelText: 'Description',
                      controller: _contentController,
                      maxLines: 10,
                      hintText: 'Add new description',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}