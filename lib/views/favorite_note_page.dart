import 'package:flutter/material.dart';

import '../database_helper.dart';

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
              ),
            );
                    },
                  ),
          ),
    );
  }
}
