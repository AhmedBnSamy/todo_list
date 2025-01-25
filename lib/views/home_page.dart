import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/themdata_cubit.dart';
import '../database_helper.dart';
import 'archive_page.dart';
import 'favorite_note_page.dart';
import 'note_item.dart';
import 'note_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> isFavorite = [];
  List<Map<String, dynamic>> notes = [];
  List<bool> isArchived = [];

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

  Future<void> archiveNote(int id) async {
    await DBHelper.updateArchiveNote(id, true);
    fetchNotes(); // Refresh notes list
  }

  Future<void> deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    fetchNotes(); // Refresh notes list after deletion
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
              icon: Icon(
                Icons.book,
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ArchivePage()),
                ).then((value) {
                  if (value == true) fetchNotes(); // Refresh home screen on return
                });
              },
            ),
            backgroundColor: theme == AppTheme.dark ? Colors.black12 : Colors.white,
            centerTitle: true,
            title: Text(
              'All Notes',
              style: TextStyle(
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: theme == AppTheme.dark ?  Colors.blueAccent:Colors.red ,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoriteNotePage()),
                  );
                },
              ),
              IconButton(
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                icon: Icon(
                  theme == AppTheme.dark ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme(); // Toggle theme
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    cursorColor: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                    style: theme == AppTheme.dark ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black),
                    onChanged: (query) async {
                      if (query.isEmpty) {
                        await fetchNotes();
                      } else {
                        final searchResults = await DBHelper.searchNotes(query);
                        setState(() {
                          notes = searchResults;
                        });
                      }
                    },
                    decoration:  InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red),
                      ),
                      prefixIcon: Icon(Icons.search, color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: theme == AppTheme.dark ? Colors.white : Colors.grey.shade500),
                    ),
                  ),
                ),
                notes.isEmpty
                    ?  Center(
                  child: Text(
                    'No notes',
                    style: TextStyle(
                      color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {

                    isFavorite.add(false);
                    isArchived.add(false);
                    return Dismissible(
                      key: Key(notes[index]['id'].toString()),
                      background: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.archive, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          await archiveNote(notes[index]['id']);
                        } else if (direction == DismissDirection.endToStart) {
                          await deleteNote(notes[index]['id']);
                        }
                        setState(() {
                          notes.removeAt(index); // Remove the note from the list
                        });
                      },

                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: NoteItem(
                          color: notes[index]['color'] ?? Colors.white,
                          onArchiveToggle: (bool isArchived) {
                            setState(() {
                              this.isArchived[index] = isArchived;
                              final updatedNotes = List<Map<String, dynamic>>.from(notes);
                              updatedNotes[index] = {
                                ...updatedNotes[index], // Copy the original map
                                'isArchived': isArchived ? 1 : 0, // Update the field
                              };
                              notes = updatedNotes;
                              DBHelper.updateArchiveNote(notes[index]['id'], isArchived);
                              notes.remove(notes[index]); // Update home list
                            });
                          },
                          onFavoriteToggle: (bool isFav) {
                            setState(() {
                              isFavorite[index] = isFav;
                              final updatedNotes = List<Map<String, dynamic>>.from(notes);
                              updatedNotes[index] = {
                                ...updatedNotes[index], // Copy the original map
                                'isFavorite': isFav ? 1 : 0, // Update the field
                              };
                              notes = updatedNotes;
                              DBHelper.updateFavoriteStatus(notes[index]['id'], isFav);
                            });
                          },
                          note: notes[index],
                          isFavorite: notes[index]['isFavorite'] == 1,
                          isArchived: notes[index]['isArchived'] == 1,
                          index: index,
                          onDelete: () {
                            setState(() async {
                              await deleteNote(notes[index]['id']);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FloatingActionButton(
              shape: CircleBorder(
                  side: BorderSide(
                    width: 3,
                      color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red)),
              backgroundColor: theme == AppTheme.dark ? Colors.black : Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NotePage()),
                );
              },
              child: Icon(
                Icons.add,
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}