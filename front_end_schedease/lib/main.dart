import 'package:flutter/material.dart';
import 'dashboard.dart';
void main(){
  runApp(SchedEaseApp());
}
//Main Application Widget
class SchedEaseApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SchedEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: DashBoard(),
    );
  }
}

