import 'package:flutter/material.dart';
class ScheduleCard extends StatelessWidget{
  final String title;
  final String time;
  final Color color;
  final String? imagePath;
  //Constructors
  const ScheduleCard({
        required this.title,
        required this.time,
        required this.color,
        this.imagePath,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 125, //Height of cards
        padding: EdgeInsets.all(16), //Adds padding to the card
        decoration: BoxDecoration(
          color: color, //Background color passed through dashboard
          borderRadius: BorderRadius.circular(20), //Round corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2)
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: Text( //Title text
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                        height: 1.2,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                ),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Flexible(
                    child: Text( //Time text
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color:Colors.grey.shade700
                      ),
                      overflow: TextOverflow.ellipsis,
                      ),
                  ),

                if (imagePath != null) //Adding images based on a condition
                  Positioned(
                    right:0,
                    bottom:0,
                    child: Image.asset(
                      imagePath!,
                      width:70,   //Width of the image
                      height: 70, //Height of the image
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
        ),
    ],
    ),

    );
  }
}
