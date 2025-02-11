import 'package:flutter/material.dart';
class ScheduleCard extends StatelessWidget{
  final String title;
  final String time;
  final Color color;
  final String? imagePath;
  //Constructors
  ScheduleCard(
      {
        required this.title,
        required this.time,
        required this.color,
        this.imagePath,
      });
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 155, //Height of cards
        padding: EdgeInsets.all(10), //Adds padding to the card
        decoration: BoxDecoration(
          color: color, //Background color passed through dashboard
          borderRadius: BorderRadius.circular(20), //Round corners
        ),
        child:Stack(
          children:[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start, //Align text to the left
              children: [
                Text( //Title text
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10), //Adds space
                Text( //Time text
                  time,
                  style: TextStyle(fontSize: 16, color:Colors.grey.shade700),
                ),
              ],
            ),
            if (imagePath != null) //Adding images based on a condition
              Positioned(
                right:0,
                bottom:0,
                child: Image.asset(
                  imagePath!,
                  width:110,   //Width of the image
                  height: 110, //Height of the image
                  fit: BoxFit.cover,
                ),
              ),
          ],
        )
    );
  }
}
