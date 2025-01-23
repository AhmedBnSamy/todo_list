import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? db;

  static Future<void> createDB() async {
    if (db != null) return;
    try {
      String path = "${await getDatabasesPath()}/notes.db";
      db = await openDatabase(path, version: 3, onCreate: (db, version) async {
        await db.execute(
            '''
       CREATE TABLE "notes"(
       id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
       title TEXT NOT NULL,
       note TEXT NOT NULL,
       isFavorite INTEGER Default 0,
       isArchived INTEGER DEFAULT 0
      ) 
        '''
        );
        print('Database and table created successfully');

      });

    } catch (e) {
      print('Database creation error: $e');
    }
  }

  static Future<void> insertDB(String title, String note) async {
    try {
      await DBHelper.db!.insert('notes', {'title': title, 'note': note});
    } catch (e) {
      print('Insert error: $e');
    }
  }

  static Future<void> deleteDB(int id) async {
    try {
      String path = "${await getDatabasesPath()}/notes.db";
      await deleteDatabase(path);
    } catch (e) {
      print('Delete error: $e');
    }
  }
  static Future<void> deleteNote(int id) async {
    await db?.delete(
      'notes', // Replace 'notes' with your table name if different
      where: 'id = ?', // Use the id column to identify the note
      whereArgs: [id], // Pass the id as an argument to prevent SQL injection
    );
  }

  static Future<void> updateNote(int id, String title, String note) async {
    try {
      await db?.update(
        'notes',
        {'title': title, 'note': note},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update error: $e');
    }
  }




  static Future<List<Map<String, dynamic>>?> getDataFromDB({required bool isArchived} ) async {
    try {
      final data = await db?.query(
          "notes",
        where: "isArchived = ?",
        whereArgs: [isArchived],
      );
      print('Data from DB: $data'); // Debug log
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  static Future<void> updateFavoriteStatus(int id, bool isFavorite) async {
    try {
      await db?.update(
        'notes',
        {'isFavorite': isFavorite ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update error: $e');
    }
  }
  static Future<List<Map<String, dynamic>>?> getFavoriteNotes() async {
    try {
      return await db?.query("notes", where: "isFavorite = ?", whereArgs: [1]);
    } catch (e) {
      print('Update favorite error: $e');
    }
    return null;
  }
  static Future<List<Map<String, dynamic>>?> getArchivedNotes() async {
    try {
      return await db?.query(
        'notes',
        where: 'isArchived = ?',
        whereArgs: [1],
      );
    } catch (e) {
      print('Update archive error : $e');
    }
    return null;
  }

  static Future<void> updateArchiveNote(int id,bool isArchived) async {
    // Get your database instance
    try {
      await db?.update(
        'notes',
        {'isArchived': isArchived ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print('Update archive error: $e');
    }
  }


  static Future<void> unarchiveNote(int id) async {
    await db?.update(
      'notes',
      {'isArchived': 0}, // Set isArchived to false (0)
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  static Future<List<Map<String, dynamic>>> searchNotes(String query) async {
    try {
      final data = await db?.query(
        'notes',
        where: 'title LIKE ?', // Search only in the 'title' column
        whereArgs: ['%$query%'], // Use the query parameter with wildcards
      );
      print('Search results: $data');
      return data ?? [];
    } catch (e) {
      print('Search error: $e');
      return [];
    }
  }



}