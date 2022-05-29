// class Note{
//   int? id;
//   String title;
//   String description;
//   String date;
//   int priority;

//   Note({required this.title, required this.description, required this.date, required this.priority});
//   Note.withId({required this.id,required this.title, required this.description, required this.date, required this.priority});

//   // GETTERS
//   int? get getId => id;
//   String get getTitle => title;
//   String get getDescription => description;
//   String get getDate => date;
//   int get getPriority => priority;

//   //SETTERS
//   set setTitle(String newTitle){
//     if(newTitle.length <=255){
//       title=newTitle;
//     }
//   }

//   set setDescription(String newDescription){
//     if(newDescription.length <=255){
//       description=newDescription;
//     }
//   }

//   set setDate(String newDate){
//     date=newDate;
//   }

//   //1 for higher priority, 2 for lower priority
//   set setPriority(int newPriority){
//     if(newPriority>=1 && newPriority<=2) {
//       priority=newPriority;
//     }
//   }



//   //?USED TO SAVE AND RETRIEVE FROM DB

//   Map<String,dynamic> toMap(){
//     Map<String,dynamic>map={};
//     if(id!=null){
//       map['id']=id;
//     }
//     map['title']=title;
//     map['description']=description;
//     map['date']=date;
//     map['priority']=priority;

//     return map;
//   }

//   Note fromMapObject(Map<String,dynamic> map){
//     var obj=Note.withId(id:map['id'],title:map['title'],description: map['dexription'],date:map['date'],priority: map['priority']);
//     return obj;
//   }

// }




final String notesTableName='notes';


//* FIELD NAMES WHICH ARE LATER COLUMN NAMES IN THE TABLE
//* SQL, BY DEFAULT, ID --> _ID, REST AS IT IS
class NoteFields{
  static final String id='_id';
  static final String isImportant='isImportant';
  static final String number='number';
  static final String title='title';
  static final String description='description';
  static final String time='time';
  static final List<String> values=[id,isImportant,number,title,description,time];
}


class Note{
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note({
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime
  });

  Note copy({int? id, bool? isImportant, int? number, String? title, String? description, DateTime? createdTime})
  {
    return Note(
      id: id ?? this.id,
      isImportant: isImportant ?? this.isImportant,
      number: number ?? this.number,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime
    );
  }

  Map<String, Object?> toJson() => {
    NoteFields.id:id,
    NoteFields.isImportant:isImportant ? 1 : 0,
    NoteFields.number:number,
    NoteFields.title:title,
    NoteFields.description:description,
    NoteFields.time:createdTime.toIso8601String()
  };


  static Note fromJson(Map<String, Object?> json) => Note(
    id:json[NoteFields.id] as int?,
    isImportant: json[NoteFields.isImportant] == 1,
    number:json[NoteFields.number] as int,
    title:json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
    createdTime: DateTime.parse(json[NoteFields.time] as String),
  );
}