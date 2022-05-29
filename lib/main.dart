import 'package:flutter/material.dart';
import '../screens/NoteList.dart';

void main ()=> runApp(MyApp());


class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'MY TODO APP',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme:ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.blueGrey.shade900,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0
        )
      ),
      home:NoteList()
    );
  }
}