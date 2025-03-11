import 'package:flutter/material.dart';
import 'package:front_end_schedease/widgets/schedule_card.dart';
import 'package:front_end_schedease/features/schedule_page.dart';
import 'package:front_end_schedease/widgets/navbar.dart';
import 'package:front_end_schedease/features/log_page.dart'; // Add this import
import 'package:front_end_schedease/service/event_service.dart'; //Import the event service
import 'package:intl/intl.dart'; //time formatting

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _currentIndex = 0; //Tracking currently selected index

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final EventService _eventService = EventService.instance; //Use of shared service


  //List of pages displayed based on the index selected
  final List<Widget> _pages = [
    DashBoardContent(),
    SchedulePage(),
    LogPage(),
    // Chat is index 4, add it here
  ];

  void changePage(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 10, right: 10),
        child: BottomNavBar(
          initiallySelectedIndex: _currentIndex,
          onItemSelected: (index) {
            changePage(index);
          },//Update selected index
        ),
      ),
      body: _pages[_currentIndex],
    );
    }
  }
class DashBoardContent extends StatefulWidget{
  @override
  _DashBoardContentState createState() => _DashBoardContentState();
}

class _DashBoardContentState extends State <DashBoardContent>{
  final EventService _eventService = EventService.instance;
  List <Map<String, dynamic>> _todayEvents = [];

  late final String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadEvents(); //Get today's events

    _eventService.eventsNotifier.addListener(_onEventsChanged);
  }

  @override
  void dispose() {
    _eventService.eventsNotifier.removeListener(_onEventsChanged);
    super.dispose();
  }

  //Loading events from the service
  void _loadEvents(){
    setState(() {
      _todayEvents = _eventService.getFirstNEventsForToday(4);
    });
  }

  //Called when events change in the service
  void _onEventsChanged(){
    _loadEvents();
  }

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

    String greeting = _getGreeting(); //Get the greeting based on the time of the day
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
  //Getting appropriate greeting
  String _getGreeting() {
    final hour = DateTime
        .now()
        .hour;
    if (hour < 12) {
      return "Good Morning,";
    } else if (hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  //Time & Quote Card
  Widget _buildTimeAndQuoteCard(){
    return Container(
        padding: EdgeInsets.all(20), //Adds padding inside the card
        width: double.infinity,
        height:160,
        decoration: BoxDecoration(
          color: Color(0xFF3C5A7D), //Dark blue background
          borderRadius: BorderRadius.circular(25), //Rounded corner
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child:Stack(
            children:[
              //Time: Top left
              Positioned(
                left: 10, //left
                top: 10,  //top
                child: Text(
                  formattedTime,
                  style:TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
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
                      letterSpacing: 1.5,
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
      //
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //Aligns the children to left side
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 20, bottom:15), //Adding horizontal padding)
              child:  Text( //Title
                "Today's Schedule",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                ),
              ),
          ),

          //Build schedule cards based on events from EventService
          _buildDynamicScheduleCards(),
          SizedBox(height: 25), //More spacing

          //View More Button
          Center(
            child: GestureDetector(
              onTap: () {
                final _DashBoardState? state= context.findAncestorStateOfType<_DashBoardState>(); //nearest scaffold state to access _DashBoardState
                if ( state != null){
                    state.changePage(1);
                  }
                },
                child: Container(
                  height: 45, //Taller button
                  width: 150, //Wider button
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF1A365D),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ) ,
                    ] ,
                   ),
                child: Text(
                    "View Schedule",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
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

    // Build schedule cards dynamically based on events
    Widget _buildDynamicScheduleCards() {
      // If no events, show a placeholder message
      if (_todayEvents.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Center(
            child: Text(
              "No events scheduled for today",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        );
      }

      // Split events into rows of 2
      List<Widget> rows = [];
      for (int i = 0; i < _todayEvents.length; i += 2) {
        // Create a row for each pair of events
        List<Widget> rowItems = [];

        // Add first event in row
        rowItems.add(
          Expanded(
            child: _buildScheduleCardFromEvent(_todayEvents[i]),
          ),
        );

        // Add spacing
        rowItems.add(SizedBox(width: 10));

        // Add second event if available
        if (i + 1 < _todayEvents.length) {
          rowItems.add(
            Expanded(
              child: _buildScheduleCardFromEvent(_todayEvents[i + 1]),
            ),
          );
        } else {
          // Empty space as placeholder if odd number of events
          rowItems.add(Expanded(child: Container()));
        }

        // Add completed row to list
        rows.add(Row(children: rowItems));

        // Add spacing between rows
        if (i + 2 < _todayEvents.length) {
          rows.add(SizedBox(height: 10));
        }
      }

      return Column(children: rows);
    }

// Convert an event to a ScheduleCard widget
Widget _buildScheduleCardFromEvent(Map<String, dynamic> event) {
  // Determine if this is a feedback session
  bool isFeedback = event['title'].toString().toLowerCase().contains('feedback');

  // Customize image based on event type
  String? imagePath;
  Color cardColor = Color(0xFFC5DCC2); // Default to light green for feedback

  if (!isFeedback) {
    // For non-feedback events, use appropriate image and white background
    if (event['title'].toString().toLowerCase().contains('submission')) {
      imagePath = 'assets/cw.png';
    } else if (event['title'].toString().toLowerCase().contains('lecture')) {
      imagePath = 'assets/lec.png';
    } else if (event['title'].toString().toLowerCase().contains('meeting')) {
      // Skip the meeting.png asset since it's missing
      cardColor = Color(0xFFFBFBFB); // Just use white background instead
    }

    if (imagePath != null) {
      cardColor = Color(0xFFFBFBFB); // White background for cards with images
    }
  }

  // Get the time from event
  String timeDisplay = event['duration'] ?? event['time'];

  return ScheduleCard(
    title: event['title'],
    time: timeDisplay,
    color: cardColor,
    imagePath: imagePath,
  );
}
}
