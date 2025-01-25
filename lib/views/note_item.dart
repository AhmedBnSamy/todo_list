import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/themdata_cubit.dart';
import '../database_helper.dart';
import 'note_page.dart';

class NoteItem extends StatefulWidget {
  const NoteItem({
    super.key,
    required this.index,
    required this.note,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.isArchived,
    required this.onArchiveToggle,
    required this.onDelete,
    required this.color, // New callback for deletion
  });

  final int index;
  final Color color;
  final Map<String, dynamic> note;
  final bool isFavorite;
  final bool isArchived;
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
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotePage(
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
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme == AppTheme.dark ? Colors.black12 : Colors.white,
                border: Border.all(
                  color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.note['title'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                        fontWeight: FontWeight.bold,
                      ), // Use Theme.of
                    ),
                    Text(
                      widget.note['note'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: theme == AppTheme.dark ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 24,
                            color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
                          ),
                          onPressed: () {
                            widget.onFavoriteToggle(!widget.isFavorite);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            widget.isArchived ? Icons.archive : Icons.archive_outlined,
                            size: 24,
                            color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
                          ),
                          onPressed: () {
                            widget.onArchiveToggle(!widget.isArchived);
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.edit_note_outlined,
                            size: 24,
                            color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotePage(
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
                            Icons.delete,
                            size: 24,
                            color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
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
          ),
        );
      },
    );
  }
}