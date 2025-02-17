import 'package:flutter/material.dart';

class SchedulePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Schedule'),
      ),
      body: Center(
        child: Text('This is the page where student can view their full schedule for that day'),
      )
    );
  }

}