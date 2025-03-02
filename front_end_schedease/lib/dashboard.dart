import 'package:flutter/material.dart';
import 'package:front_end_schedease/widgets/schedule_card.dart';
import 'package:front_end_schedease/features/schedule_page.dart';
import 'package:front_end_schedease/widgets/navbar.dart';
import 'package:front_end_schedease/features/log_page.dart'; // Add this import

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0; //Tracking currently selected index

  //List of pages displayed based on the index selected
  final List<Widget> _pages = [
    DashBoardContent(),
    SchedulePage(),
    // Chat is index 2, add it here
    LogPage(),
    // If there are other pages, add them here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 10, right: 10),
        child: BottomNavBar(
          initiallySelectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index; //Update selected index
            });
          },
        ),
      ),
      body: _pages[_currentIndex], //Display the selected Page
    );
  }
}
class DashBoardContent extends StatelessWidget{
  @override
  Widget build(BuildContext context){
      return SafeArea( // UI avoids device notches and status bars
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Adding horizontal padding to the whole screen
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left side
          children: [
          SizedBox(height: 20), // Adds spacing at the top
          _buildGreetingSection(), // Calls function to build the greeting section
          SizedBox(height: 20), // Adds spacing
          _buildTimeAndQuoteCard(), // Calls function to build time & quotes UI
          Spacer(), // Pushes this section to the bottom
          _buildScheduleSection(context), // Calls function to build the schedule section UI
          SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
  //Greeting Section ("Good Morning, Student!")
  Widget _buildGreetingSection(){
    return Row(   //Creating a horizontal row
      mainAxisAlignment: MainAxisAlignment.spaceBetween,  //Distributes the items to both ends
      children: [
        //DP
        CircleAvatar( //Displays a circular profile picture of the student
          radius: 40, //Size
          backgroundImage:AssetImage('assets/avatar.jpg'), //Place holder image
        ),
        //Greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.end, //Align text to the right
          children: [
            Text(
              "Good Morning,",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600), //Smaller grey text for greeting
            ),
            Text(
              "Sienna Riverly!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  //Time & Quote Card
  Widget _buildTimeAndQuoteCard(){
    return Container(
        padding: EdgeInsets.all(20), //Adds padding inside the card
        width: double.infinity,
        height:150,
        decoration: BoxDecoration(
          color: Color(0xFF3C5A7D), //Dark blue background
          borderRadius: BorderRadius.circular(20), //Rounded corner
        ),
        child:Stack(
            children:[
              //Time: Top left
              Positioned(
                left: 10, //left
                top: 10,  //top
                child: Text(
                  "08:00 AM",
                  style:TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Quote: Bottom Right
              Positioned(
                  right:5,
                  bottom:2,
                  child:Text(
                    "DREAM.PLAN.DO.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight:FontWeight.bold,
                    ),
                  )
              )
            ]
        )
    );
  }

  //Today's Schedule
  Widget _buildScheduleSection(BuildContext context) {
    return Container(
      width: double.infinity, // Container spans full width
      padding: EdgeInsets.symmetric(horizontal: 20), //Adding horizontal padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, //Aligns the children to left side
        children: [
          //Title
          Text(
            "Today's Schedule",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15), //Adds space

          //First Row:
          Row(
            children: [
              Expanded(
                child: ScheduleCard(
                  title: "Feedback Session with Ms.Anne",
                  time: "09:00 - 09:30",
                  color: Color(0xFFC5DCC2),
                ),
              ),

              SizedBox(width: 10), //Adds space

              //SDGP CW Card
              Expanded(
                child: ScheduleCard(
                  title: "SDGP CW I Submission",
                  time: "13:30",
                  color: Color(0xFFFBFBFB),
                  imagePath: 'assets/cw.png',
                ),
              ),

            ],
          ),
          SizedBox(height: 10), //Adds space

          //Second Row:
          Row(
            children: [
              //Database Lecture Card
              Expanded(
                child: ScheduleCard(
                  title: "Database Submission",
                  time: "15:00 ",
                  color: Color(0xFFFBFBFB),
                  imagePath: 'assets/lec.png',
                ),
              ),

              SizedBox(width: 10), //Adds space between cards

              Expanded(
                child: ScheduleCard(
                  title: "Feedback Session\nwith Mr. Albert",
                  time: "17:00 - 17:30",
                  color: Color(0xFFC5DCC2),
                ),
              ),
            ],
          ),
          SizedBox(height: 20), //Adds space

          //View More Button
          Center(
            child: GestureDetector(
              onTap: (){
                //Navigate to the SchedulePage
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchedulePage()),
                );
              },
              child: Container(
                height: 40, //Sets a fixed height
                width: 120, //Button spans to full width
                alignment: Alignment.center, //Centers text in button
                decoration: BoxDecoration(
                  color: Color(0xFF1A365D), //BG color of the button
                  borderRadius: BorderRadius.circular(40), //Rounded corners
                ),
                child: Text(
                  "View Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //View More Button
  Widget _buildViewMoreButton() {
    return Center(
      child: Container(
        height: 60, //Sets a fixed height
        width: double.infinity, //Buttons spans to full width
        alignment: Alignment.center, //Centers text in button
        decoration: BoxDecoration(
          color: Color(0xFF3C5A7D), //BG color of the button
          borderRadius: BorderRadius.circular(15), //Rounded corners
        ),
        child: Text(
          "View Schedule",
          style: TextStyle(color: Colors.white,fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"), // Home icon.
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Schedule"), // Calendar icon.
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chat"), // Chat icon.
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"), // Profile icon.
      ],
      selectedItemColor: Colors.blue, // Selected item color.
      unselectedItemColor: Colors.grey, // Unselected item color.
    );
  }

}




