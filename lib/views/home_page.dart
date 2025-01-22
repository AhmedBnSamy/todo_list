import 'package:flutter/material.dart';

import '../database_helper.dart';
import 'add_notes.dart';
import 'archive_page.dart';
import 'favorite_note_page.dart';
import 'note_item.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.book,
            color: Colors.black,
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('All Notes'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteNotePage()),
              );
            },
          )
        ],
      ),
      body: notes.isEmpty
          ? const Center(
        child: Text(
          'No notes',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : ListView.builder(
        shrinkWrap: true,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          isFavorite.add(false);
          isArchived.add(false);
          return  Dismissible(
            key: Key(notes[index]['id'].toString()), // Unique key for each note
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
                onArchiveToggle: (bool isArchived) {
                  setState(() {
                    this.isArchived[index] = isArchived;
                    final updatedNotes =
                    List<Map<String, dynamic>>.from(notes);
                    updatedNotes[index] = {
                      ...updatedNotes[index], // Copy the original map
                      'isArchived': isArchived ? 1 : 0, // Update the field
                    };
                    notes = updatedNotes;
                    DBHelper.updateArchiveNote(
                        notes[index]['id'], isArchived);
                    notes.remove(notes[index]); // Update home list
                  });
                },
                onFavoriteToggle: (bool isFav) {
                  setState(() {
                    isFavorite[index] = isFav;
                    final updatedNotes =
                    List<Map<String, dynamic>>.from(notes);
                    updatedNotes[index] = {
                      ...updatedNotes[index], // Copy the original map
                      'isFavorite': isFav ? 1 : 0, // Update the field
                    };
                    notes = updatedNotes;
                    DBHelper.updateFavoriteStatus(
                        notes[index]['id'], isFav);
                  });
                },
                note: notes[index],
                isFavorite: isFavorite,
                isArchived: isArchived,
                index: index,
                onDelete: (){
                  setState(() async {
                    await deleteNote(notes[index]['id']);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: FloatingActionButton(
          backgroundColor: Colors.grey.shade200,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddNotes()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
//
//   Widget noteItem(Map<String, dynamic> note) {
//     return Card(
//       margin: const EdgeInsets.all(10),
//       child: ListTile(
//         title: Text(
//           note['title']??'',
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         subtitle: Text(note['note']??''),
//         trailing: IconButton(
//           icon: Icon(
//
//             isFavorite[index] ? Icons.favorite : Icons.favorite_border,
//             color: Colors.redAccent,
//           ),
//           onPressed: () async {
//
//
//             fetchNotes();
//           },
//         ),
//       ),
//     );
//   }
// }
}