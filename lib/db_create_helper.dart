import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDB {
 static  Database? db;
  Future<Database?> getDB() async {
    if (db == null) {
      await intialDb();
    }
    return db;
  }

  Future<void> intialDb() async {
    /*
     * Get the database path
     * 1- get the database path using getDatabasesPath() method from sqflite -> that make path by default in the app directory
     * 2- join that method take the database path and the database name
     */
    //--1--
    String databasePath = await getDatabasesPath();
    //---2--
    String path = join(databasePath, 'notes.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            '''
      CREATE TABLE "notes"(
      "id" INTEGER PRIMARY KEY NOT NULL AUTOINCREMENT,
      "title" TEXT NOT NULL,
      "note" TEXT NOT NULL,
      "isFavorite" INTEGER Default 0,
      "isArchived" INTEGER DEFAULT 0
      ) 
      '''
        );
        print(
            '--------------------------------Database and table created successfully-----------------------------------------------');
      },
    );
  }
/*
     * Open the database
     *
     * openDatabase() method from sqflite
     * 1- that take 3 parameters
     * 2- take the database path 'path'
     * 3- version: database version
     * 4- onCreate: function that called when the database is created for the first time or when the database version is changed
     * this function take 2 parameters
     * db: database object
     * version: database version
     * in method onCreate: take the object from db and execute the table creation query
     * first call object db.execute() to execute the query
     * inside execute() take the query
     * first line take CREATE TABLE query WITH NAME OF TABLE "notes"
     * SECOND LINE take the name of  parameters of table columns,
     * each column have name and type in the same line, in the end separated by comma
     *
     */
//create method to insert the database object
  static Future<void> insertDB(String title, String note) async {
    try {
      await SqlDB.db!.insert('notes', {'title': title, 'note': note});
    } catch (e) {
      print('Insert error: $e');
    }
  }

//create method to select the database object
  static Future<List<Map<String, dynamic>>?> getDataFromDB() async {
    try {
      final data = await db?.query("notes");// we here select the table from the database
      print('Data from DB: $data'); // Debug log
      return data;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
//create method to update the database object
  static Future<void> updateDB(int id, String title, String note) async {
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

//create method to delete the database object
  static Future<void> deleteDB(int id) async {
    try {
      String path = "${await getDatabasesPath()}/notes.db";
      await deleteDatabase(path);
    } catch (e) {
      print('Delete error: $e');
    }
  }

}
