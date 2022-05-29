import 'package:flutter/material.dart';
import '../Note.dart';
import '../database_helper.dart';

class AddOrEditPage extends StatefulWidget {
  Note? note;
  AddOrEditPage({ Key? key, this.note }) : super(key: key);

  @override
  State<AddOrEditPage> createState() => _AddOrEditPageState(note:note);
}

class _AddOrEditPageState extends State<AddOrEditPage> {

  Note? note;
  _AddOrEditPageState({this.note});

  final db=NotesDatabase.instance;

  final _formKey=GlobalKey<FormState>();

  late bool isImportant;
  late int number;
  late String title;
  late String description;

  onChangedImportant(input) => setState(()=>isImportant=input);
  onChangedNumber(input) => setState(()=>number=input);
  onChangedTitle(input) => setState(()=>title=input);
  onChangedDescription(input) => setState(()=>description=input); 

  @override
  void initState() {
    super.initState();
    isImportant=note?.isImportant ?? false;
    number=note?.number ?? 0;
    title=note?.title ?? '';
    description=note?.description ?? '';
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
        actions:[buildButton()]
      ),
      body:Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children:[
                    Switch(
                      value: isImportant,
                      onChanged: onChangedImportant
                    ),
                    Expanded(
                      child: Slider(
                        value:number.toDouble(),
                        min:0,
                        max:5,
                        divisions: 5,
                        onChanged: (input)=>onChangedNumber(input.toInt()),
                      ),
                    )
                  ]
                ),
                TextFormField(
                  maxLines:1,
                  initialValue: title,
                  style:const TextStyle(
                    color:Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                  decoration: const InputDecoration(
                    border:InputBorder.none,
                    hintText: 'Title',
                    hintStyle:TextStyle(color: Colors.white70)
                  ),
                  validator: (input){
                    if(input!=null && input.isEmpty) {
                      return 'The Title cannot be empty';
                    }
                  },
                  onChanged: onChangedTitle
                ),
                SizedBox(height:8),
                TextFormField(
                  maxLines:null,
                  initialValue: description,
                  style:const TextStyle(
                    color:Colors.white60,
                    fontSize: 18
                  ),
                  decoration: const InputDecoration(
                    border:InputBorder.none,
                    hintText: 'Type Something...',
                    hintStyle:TextStyle(color: Colors.white60)
                  ),
                  validator: (input){
                    if(input!=null && input.isEmpty) {
                      return 'The Description cannot be empty';
                    }
                  },
                  onChanged: onChangedDescription
                ),
                SizedBox(height: 16)
              ],
            ),
          ),
      
        ),
      )
    );
  }


  Widget buildButton (){
    final isFormValid= title.isNotEmpty && description.isNotEmpty;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      child: ElevatedButton(
        child:Text('SAVE'),
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700
        ),
        onPressed: (){addOrUpdateNote();},
      ),
    );
  }

  void addOrUpdateNote() async{

    final isValid=_formKey.currentState!.validate();

    if(isValid){
      
      final isUpdate=note!=null;
      if(isUpdate) {
        await updateNote();
      } else {
        await addNote();
      } 
    }
  }


  Future updateNote() async{
    final updatedNote=note!.copy(
      isImportant: isImportant,
      number: number,
      title:title,
      description: description
    );
    final result=await db.updateNote(updatedNote);
    Navigator.of(context).pop();
    if(result!=0) {
      await showAlertDialog('Status','Note Updated Successfully!');
    } else {
      await showAlertDialog('Status', 'Problem Updating The Note!','error');
    }
  }

  Future addNote() async{
    final noteToBeAdded=Note(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now()
    );

    final result=await db.createNote(noteToBeAdded);
    Navigator.of(context).pop();
    if(result.id!=null) {
      await showAlertDialog('Status','Note Saved Successfully!');
    } else {
      await showAlertDialog('Status', 'Problem Saving The Note!','error');
    }
  }

}