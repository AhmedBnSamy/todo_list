import 'package:flutter/material.dart';

import '../database_helper.dart';
import 'home_page.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key ,});


  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {

  List<Map<String, dynamic>> archivedNotes = [];
  @override
  void initState() {
    super.initState();
    fetchArchivedNotes();
  }
  Future<void> unarchiveNote(int id) async {
    await DBHelper.updateArchiveNote(id, false);
    fetchArchivedNotes(); // Refresh archive list
  }


  Future<void> fetchArchivedNotes() async{
    final data = await DBHelper.getArchivedNotes();
    setState(() {
      archivedNotes = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Archive Notes',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  HomePage()),
            ).then((value) {
              if (value == true) fetchArchivedNotes(); // Refresh archive screen on return
            });
          }
        ),
      ),
      body: archivedNotes.isEmpty
          ? const Center(child: Text('No archived notes'),)
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: archivedNotes.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(archivedNotes[index]['title']),
                subtitle: Text(archivedNotes[index]['note']),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.bookmark_remove,
                    color: Colors.red,
                  ),
                  onPressed: () => unarchiveNote(archivedNotes[index]['id']),
                ),
              ),
            );
          },
        ),
      ),
      );
  }
}
