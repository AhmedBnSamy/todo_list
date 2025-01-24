// import 'package:flutter/material.dart';
// import 'package:todo_list/custom_form_text_field.dart';
// import '../database_helper.dart';
// import 'home_page.dart';
//
// class EditNote extends StatefulWidget {
//   final int noteId; // ID of the note to edit
//   final String initialTitle; // Initial title of the note
//   final String initialContent; // Initial content of the note
//
//   const EditNote({
//     super.key,
//     required this.noteId,
//     required this.initialTitle,
//     required this.initialContent,
//   });
//
//   @override
//   State<EditNote> createState() => _EditNoteState();
// }
//
// class _EditNoteState extends State<EditNote> {
//   late TextEditingController _titleController;
//   late TextEditingController _contentController;
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(text: widget.initialTitle);
//     _contentController = TextEditingController(text: widget.initialContent);
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _updateNote() async {
//     String updatedTitle = _titleController.text.trim();
//     String updatedContent = _contentController.text.trim();
//
//     if (updatedTitle.isNotEmpty && updatedContent.isNotEmpty) {
//       await DBHelper.updateNote(widget.noteId, updatedTitle, updatedContent);
//      Navigator.push(context, MaterialPageRoute(builder: (context) =>  HomePage()));// Return true to indicate success
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Both title and content are required.'),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Note'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _updateNote,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomFormTextField(
//               labelText: 'Title',
//               maxLines: 1,
//               controller: _titleController,
//               hintText: 'Title',
//             ),
//             const SizedBox(height: 16),
//             CustomFormTextField(
//               labelText: 'Content',
//               maxLines: 16,
//               controller: _contentController,
//               hintText: 'Description',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
