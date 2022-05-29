import 'Note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesDatabase{
  static NotesDatabase instance=NotesDatabase._init();  
  static Database? _database;  

  //private constructor
  NotesDatabase._init();

  //?open a connection
  Future<Database> get database async{
    if(_database!=null)
      return _database!;

    //initialize our DB
    _database=await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async{
    Directory directory=await getApplicationDocumentsDirectory();
    String path=directory.path + filePath;

    return await openDatabase(path,version: 1,onCreate: _createDB);
  }

  //?DEFINING THE SCHEMA
  Future _createDB(Database db,int version) async {
    //*TYPES
    final idType='INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType='BOOLEAN NOT NULL';
    final integerType='INTEGER NOT NULL';
    final textType='TEXT NOT NULL';

    await db.execute(''' 
    CREATE TABLE $notesTableName (
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType
    )
    ''');
  }

  //? _createDB is only executed incase the file notes.db in "_database=await _initDB('notes.db');" is not existing in the file system...so executed only once...schema created only once

  //? if we want to update our schema,  openDatabase(path,version: 1,onCreate: _createDB); pass onUpgrade, everytime the version number is incremented, that onUpgrade is executed

  //? we can create as many tables as we want CREATE TABLE(); CREATE TABLE();  ..So on


  //?CLOSING THE DB
  Future close() async{
    final db=await instance.database;
    db.close();
  }



  //*CRUD OPERATIONS


  Future<Note> createNote (Note note) async{
    //? getting a reference to the DB
    final db=await instance.database;

    //?inserting into the table.... insert(tbname,json)... we'll be getting the id of the object inserted
    final id=await db.insert(notesTableName,note.toJson());

    //?storing the new id
    return note.copy(id:id);
  }



  Future<Note> readNote (int id) async{
    //? getting a reference to the DB
    final db=await instance.database;

    //? db.query.... (tablename,columns to be retrieved,where)
    //? type of maps varibale --> list of maps, List<Map<String,Object?>>
    final maps=await db.query(
      notesTableName,
      columns:NoteFields.values,
      // where:'${NoteFields.id} = $id'
      where:'${NoteFields.id} = ?',
      whereArgs:[id]
    );

    if(maps.isNotEmpty){
      return Note.fromJson(maps.first);
    }
    else{
      throw Exception('ID $id NOT FOUND!');
      //OR ALTERNATIVELY RETURN null AND CHANGE THE RETURN TYPE TO Future<Note?>
    }
  }



  
  Future<List<Note>> readAllNotes() async{
    //? getting a reference to the DB
    final db=await instance.database;

    //query to get all the records
    // final result=await db.query(notesTableName);

    final orderBy='${NoteFields.time} ASC';
    final result=await db.query(notesTableName,orderBy:orderBy);

    //? raw query as in SQL
    // final result= await db.rawQuery('SELECT * FROM $notesTableName ORDER BY $orderBy');

    return result.map((json) => Note.fromJson(json) ).toList();
  }



  Future<int> updateNote(Note note) async{ 
    //? getting a reference to the DB
    final db=await instance.database;

    return db.update(
      notesTableName,
      note.toJson(),
      where:'${NoteFields.id} = ?',
      whereArgs: [note.id]
    );

    //? for SQL statement, rawUpdate(....)
  }



  Future<int> deleteNote(int id) async{
    //? getting a reference to the DB
    final db=await instance.database;

    return await db.delete(
      notesTableName,
      where:'${NoteFields.id} = ?',
      whereArgs: [id]
    );
  }

}