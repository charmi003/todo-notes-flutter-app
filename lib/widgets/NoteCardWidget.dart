import 'package:flutter/material.dart';
import '../Note.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart';
import 'dart:math' as math;
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

 /// To return different height for different widgets
double getMinHeight(int index) {
  switch (index % 4) {
    case 0:
      return 100;
    case 1:
      return 150;
    case 2:
      return 150;
    case 3:
      return 100;
    default:
      return 100;
  }
}

class NoteCardWidget extends StatelessWidget {
  final Note note;
  final int index;

  const NoteCardWidget({ Key? key, required this.note, required this.index }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final color=_lightColors[index%_lightColors.length];
    final time=DateFormat.yMMMd().format(note.createdTime);  //formatting the datetime the way we want
    final minHeight=getMinHeight(index); 

    return Card(
      color:color,
      child:Container(
        foregroundDecoration:!note.isImportant ? null : const RotatedCornerDecoration(
          color: Colors.redAccent,
          geometry: const BadgeGeometry(width: 48, height: 48),
          textSpan:  TextSpan(
            text: 'IMP',
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              shadows: [BoxShadow(color: Colors.yellowAccent, blurRadius: 4)],
            ),
          ),
          labelInsets: const LabelInsets(baselineShift: 4),
        ),
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child:Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            SizedBox(height: 4),
            Text(
              note.title,
              style:const  TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
      )
    );
  }
}