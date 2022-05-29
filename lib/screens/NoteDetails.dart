import 'package:flutter/material.dart';
import '../Note.dart';
import './AddOrEditPage.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';


class NoteDetails extends StatefulWidget {
  final int noteId;
  const NoteDetails({ Key? key, required this.noteId }) : super(key: key);

  @override
  State<NoteDetails> createState() => _NoteDetailsState(noteId: noteId);
}

class _NoteDetailsState extends State<NoteDetails> {
  final int noteId;
  late Note note;
  bool isLoading=false;
  final db=NotesDatabase.instance;

  _NoteDetailsState({required this.noteId});

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async{
    setState(() {
      isLoading=true;
    });
    var tempNote=await db.readNote(noteId);
    setState(() {
      note=tempNote;
      isLoading=false;
    });
  }

   Future showAlertDialog(String title,String message,[String? error]){
    return showDialog(context: context, builder: (BuildContext context){
      Future.delayed(Duration(milliseconds:800),()=>Navigator.of(context).pop());
      return AlertDialog(
        title: Text(title),
        content: Text(message,style:TextStyle(color:error!=null ? Colors.red : Colors.green.shade700)),
        shape: RoundedRectangleBorder(),
        backgroundColor: Colors.blueGrey.shade200,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:[editButton(),deleteButton()]
      ),
      body: isLoading ? Center(child:CircularProgressIndicator()) : 
      Padding(
        padding: EdgeInsets.all(12),
        child:ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          children: [
            Text(
              note.title, 
              style:TextStyle(color:Colors.white,fontSize:22,fontWeight: FontWeight.bold)
            ),
            SizedBox(height:8),
            Text(
              DateFormat.yMMMd().format(note.createdTime),
              style:TextStyle(color:Colors.white38),
            ),
            SizedBox(height:16),
            Text(
              note.description,
              style: TextStyle(color:Colors.white70,fontSize: 18)
            )
          ],
        )
      ),     
    );
  }


  Widget editButton() => IconButton(
    icon:Icon(Icons.edit_rounded),
    onPressed: () async{
      if(isLoading) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=>AddOrEditPage(note:note))
      );
      refreshNote();
    },
  );


  Widget deleteButton() => IconButton(
    icon: Icon(Icons.delete_rounded),
    onPressed: () async{
      final result=await db.deleteNote(noteId);
      Navigator.of(context).pop();
      if(result!=0)
        await showAlertDialog('Status','Note Deleted Successfully!');
      else
        await showAlertDialog('Status', 'Problem Deleting The Note!','error');
    }
  );

}
