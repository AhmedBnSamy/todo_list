import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/themdata_cubit.dart';
import '../database_helper.dart';
import 'home_page.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

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

  Future<void> fetchArchivedNotes() async {
    final data = await DBHelper.getArchivedNotes();
    setState(() {
      archivedNotes = data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        return Scaffold(
          backgroundColor: theme == AppTheme.dark ? Colors.black12 : Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: theme == AppTheme.dark ? Colors.black12 : Colors.white,
            title: Text(
              'Archive Notes',
              style: TextStyle(
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  HomePage()),
                ).then((value) {
                  if (value == true) fetchArchivedNotes(); // Refresh archive screen on return
                });
              },
            ),
          ),
          body: archivedNotes.isEmpty
              ?  Center(
            child: Text('No archived notes',
              style: TextStyle(
                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: archivedNotes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Card(
                    color: theme == AppTheme.dark ? Colors.black12 : Colors.white,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        archivedNotes[index]['title'],
                        style: TextStyle(
                          color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        archivedNotes[index]['note'],
                        style: TextStyle(
                          color: theme == AppTheme.dark ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.bookmark_remove,
                          color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
                        ),
                        onPressed: () => unarchiveNote(archivedNotes[index]['id']),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}