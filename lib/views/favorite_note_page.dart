import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/themdata_cubit.dart';
import '../database_helper.dart';
import 'home_page.dart';

class FavoriteNotePage extends StatefulWidget {
  const FavoriteNotePage({super.key});

  @override
  State<FavoriteNotePage> createState() => _FavoriteNotePageState();
}

class _FavoriteNotePageState extends State<FavoriteNotePage> {
  List<Map<String, dynamic>> favoriteNotes = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteNotes();
  }

  Future<void> fetchFavoriteNotes() async {
    final data = await DBHelper.getFavoriteNotes();
    setState(() {
      favoriteNotes = data ?? [];
    });
  }

  Future<void> unFavoriteNote(int id) async {
    await DBHelper.updateFavoriteStatus(id, false);
    fetchFavoriteNotes(); // Refresh favorite list
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, theme) {
        return Scaffold(
          backgroundColor: theme == AppTheme.dark ? Colors.black : Colors.white,
          appBar: AppBar(
            elevation: 1,
            backgroundColor: theme == AppTheme.dark ? Colors.black  : Colors.white,
            title: Text(
              'Favorite Notes',
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
                  MaterialPageRoute(builder: (context) => HomePage()),
                ).then((value) {
                  if (value == true) fetchFavoriteNotes(); // Refresh favorite screen on return
                });
              },
            ),
          ),
          body: favoriteNotes.isEmpty
              ? Center(
                  child: Text(
                    'No Favorite Notes',
                    style: TextStyle(
                      color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: favoriteNotes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: theme == AppTheme.dark ? Colors.black12 : Colors.white,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              favoriteNotes[index]['title'],
                              style: TextStyle(
                                color: theme == AppTheme.dark ? Colors.blueAccent : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              favoriteNotes[index]['note'],
                              style: TextStyle(
                                color: theme == AppTheme.dark ? Colors.white : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: theme == AppTheme.light ? Colors.red : Colors.blueAccent,
                              ),
                              onPressed: () => unFavoriteNote(favoriteNotes[index]['id']),
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
