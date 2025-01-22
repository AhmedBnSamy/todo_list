import 'package:flutter/material.dart';

import '../database_helper.dart';
import 'edite_note.dart';

class NoteItem extends StatefulWidget {
  const NoteItem({
    super.key,
    required this.index,
    required this.note,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.isArchived,
    required this.onArchiveToggle,
    required this.onDelete, // New callback for deletion
  });

  final int index;
  final Map<String, dynamic> note;
  final List<bool> isFavorite;
  final List<bool> isArchived;
  final void Function(bool) onArchiveToggle;
  final void Function(bool) onFavoriteToggle;
  final VoidCallback onDelete; // Callback for deletion


  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  List<Map<String, dynamic>> notes = [];
  @override
  void initState() {
    super.initState();
    fetchNotes();

  }
  Future<void> fetchNotes() async {
    final data = await DBHelper.getDataFromDB(
      isArchived: false,
    );
    setState(() {
      notes = data ?? [];
    });
  }
  Future<void> deleteNote() async {
    // Perform the delete operation in the database
    await DBHelper.deleteNote(widget.note['id']);
    widget.onDelete(); // Notify the parent (HomePage) to remove the note from the UI
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.note['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                widget.note['note'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 134, 127, 127),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      widget.isFavorite[widget.index] ? Icons.favorite : Icons.favorite_border,
                      size: 24,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      widget.onFavoriteToggle(!widget.isFavorite[widget.index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isArchived[widget.index] ? Icons.bookmark : Icons.bookmark_border,
                      size: 24,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      widget.onArchiveToggle(!widget.isArchived[widget.index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_note_outlined ,
                      size: 24,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      final result = await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditNote(
                            noteId: widget.note['id'],
                            initialTitle: widget.note['title'],
                            initialContent: widget.note['note'],
                          ),
                        ),
                      );

                      if (result == true) {
                        setState(() {
                          // Refresh the UI after editing
                          widget.onFavoriteToggle(false);
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete ,
                      size: 24,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      await deleteNote();
                    },
                  ),



                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}