import 'package:flutter/material.dart';

import '../database_helper.dart';
import 'home_page.dart';

class FavoriteNotePage extends StatefulWidget {
  const FavoriteNotePage({super.key});

  @override
  State<FavoriteNotePage> createState() => _FavoriteNotePageState();
}

class _FavoriteNotePageState extends State<FavoriteNotePage> {
  List <Map <String,dynamic>> favoriteNotes = [];
  @override
  void initState() {
    super.initState();
    fetchFavoriteNotes();
  }
  Future <void> fetchFavoriteNotes() async {
    final data = await DBHelper.getFavoriteNotes();
    setState(() {
      favoriteNotes =data??[];
    });
  }
  Future<void> unFavoriteNote(int id) async {
    await DBHelper.updateFavoriteStatus(id, false);
    fetchFavoriteNotes(); // Refresh archive list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Favorite Notes',
          style: TextStyle(color: Colors.black),
        ),
        leading:IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  HomePage()),
              ).then((value) {
                if (value == true) fetchFavoriteNotes(); // Refresh archive screen on return
              });
            }
        ),
      ),
      body: favoriteNotes.isEmpty
          ? const Center(child: Text('No favorite notes'),)
          : Padding(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
                    itemCount: favoriteNotes.length,
                    itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(favoriteNotes[index]['title']),
                subtitle: Text(favoriteNotes[index]['note']),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite,color: Colors.red,),
                  onPressed: () => unFavoriteNote(favoriteNotes[index]['id'])
                ),

              ),
            );
                    },
                  ),
          ),
    );
  }
}
