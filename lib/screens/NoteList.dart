import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../Note.dart';
import './NoteDetails.dart';
import './AddOrEditPage.dart';
import '../widgets/NoteCardWidget.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NoteList extends StatefulWidget {
  const NoteList({ Key? key }) : super(key: key);

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  final db=NotesDatabase.instance;
  late List<Note> notes;
  bool isLoading=false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async{
    setState(() {
      isLoading=true;
    });
    var tempNotes=await db.readAllNotes();
    setState(() {
      notes=tempNotes;
      isLoading=false;
    });
  }

  void navigateToDetailsPage(int noteId) async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>NoteDetails(noteId:noteId))
    );
    refreshNotes();
  }

  void navigateToAddOrEditPage(Note? note) async{
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=>AddOrEditPage(note:note))
    );
    refreshNotes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('ToDo Notes'),
      ),
      body:isLoading ? Center(child: CircularProgressIndicator()) : StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8.0),
        itemCount: notes.length,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        staggeredTileBuilder:(index) => StaggeredTile.fit(2),
        itemBuilder: (BuildContext context,int index)=>GestureDetector(
          child:NoteCardWidget(note:notes[index],index:index),
          onTap: (){navigateToDetailsPage(notes[index].id!);},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child:Icon(Icons.add),
        tooltip: 'Add Note',
        onPressed: (){
          navigateToAddOrEditPage(null);
        },
      ),

      
    );
  }
}