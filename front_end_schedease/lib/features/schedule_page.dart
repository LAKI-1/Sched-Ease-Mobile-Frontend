import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //dependency for date formatting
import 'package:front_end_schedease/features/mentor_selection_page.dart';

void main(){
  runApp(MaterialApp(
    home: SchedulePage(), //The app starts with the schedule page
  ));
}

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage>{
  late PageController _weekPageController; //Managing the week view of the calendar
  late DateTime _selectedDate; // Tracks the selected date
  late DateTime _currentMonth; //Tracks the displayed month

  int _currentWeekPage = 1000; //index for infinite scroll

  //Timeline of Scheduled Events
  final List<Map<String, dynamic>> scheduleItems = [
    {
      'time': '10.00',
      'title': 'Session with Supervisor (Mr.Banu)',
      'duration': '10.00 - 12.00',
      'backgroundColor': Color(0xFFC5DCC2).withOpacity(0.5), //Bg color of timeline card

    },
    {
      'time': '13.00',
      'title': 'CS-12 Group Meeting',
      'duration': '13.00 - 14.00',
      'backgroundColor': Color(0xFFC5DCC2).withOpacity(0.5), //Bg color of timeline cards
    },
  ];

  @override
  void initState(){
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _weekPageController = PageController(initialPage: _currentWeekPage);
  }

  @override
  void dispose() {
    _weekPageController.dispose();  //Dispose the PageController to free up resources
    super.dispose();
  }

  // Helper method to get ordinal suffix for day
  String _getOrdinalSuffix(int day) {
    //Helper Method: Get ordinal suffix for day
    if (day >= 11 && day <= 13) {
      return 'th';  // Special case for 11th, 12th, 13th
    }
    switch (day % 10) {  // Check last digit
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 20, //Adds space between top and calendar
              color: Colors.white,
            ),
            _buildCalendarSection(),
            Expanded(
              child: _buildScheduleContent(),
            ),
          ],
        ),
      ),
      //bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // //Build the calendar section
  Widget _buildCalendarSection(){
    //Get all days of current month
    List <DateTime> daysInMonth = _getDaysInMonth(_currentMonth);

    //Get the weekday of the first day (0 --> Monday)
    int firstDayWeekDay = DateTime(_currentMonth.year, _currentMonth.month,1).weekday - 1;
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top:20,left:15, right:15),
      decoration: BoxDecoration(
        color: Color(0xFF3C5A7D),
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: [
          //Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: (){
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month-1);
                    _selectedDate = DateTime(_currentMonth.year, _currentMonth.month,
                        min(_selectedDate.day, _daysInMonth(_currentMonth.year, _currentMonth.month)));
                  });
                },
              ),

              //Current Month and Year
              Text(
                '${DateFormat('MMMM').format(_currentMonth)} ${_currentMonth.year}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),

              //Next month
              IconButton(
                icon: Icon(Icons.chevron_right,color: Colors.white),
                onPressed: (){
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                    _selectedDate = DateTime(_currentMonth.year, _currentMonth.month,
                        min(_selectedDate.day, _daysInMonth(_currentMonth.year, _currentMonth.month)));

                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          //Weekday header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for(String weekday in ['M','T','W','T','F','S','S'])
                Text(
                  weekday,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          
          SizedBox(height: 10),
          
          //Calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
            itemCount: firstDayWeekDay + daysInMonth.length,
            itemBuilder: (context, index){
    //Empty spots before first day of month
    if (index < firstDayWeekDay){
    return Container();
    }

    //Actual days of month
    final dayIndex = index - firstDayWeekDay;
    final day = daysInMonth[dayIndex];

    bool isSelected = day.year == _selectedDate.year &&
    day.month == _selectedDate.month &&
    day.day == _selectedDate.day;

    return GestureDetector(
    onTap: (){
    setState(() {
    _selectedDate = day;
    });
    },
    child: Container(
    decoration: BoxDecoration(
    color: isSelected ? Colors.white : Colors.transparent,
    shape: BoxShape.circle,
    ),
    child: Center(
    child: Text(
    '${day.day}',
    style: TextStyle(
    fontSize: 14,
    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    color: isSelected ? Color(0xFF3C5A7D) : Colors.white,
    ),
    ),
    ),
    ),
    );
    },
          ),
          SizedBox(height: 20),
          _buildBookSessionButton(),
        ],
      ),
    );
  }

  //Method to get all days in a month
  List <DateTime> _getDaysInMonth (DateTime month){
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    return List.generate(
      lastDay.day,
        (index) => DateTime(month.year, month.month, index +1),
    );
  }

  //Method to get no. of days in a month
  int _daysInMonth (int year, int month){
    return DateTime (year, month +1, 0).day;
  }

  //Function for min
  int min(int a, int b){
    return a< b ? a:b;
  }


  Widget _buildBookSessionButton() {
    return GestureDetector(
      onTap: () {
        // Navigate to the MentorSelectionPage with the currently selected date
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MentorSelectionPage(selectedDate: _selectedDate),
          ),
        ).then((result) {
          // Optional: Handle result when returning from mentor selection page
          if (result == true) {
            // Booking was successful, maybe refresh the schedule
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Session booked successfully!',
                style: TextStyle(
                  color: Colors.black
                ),
                ),
                backgroundColor: Color(0xFFC5DCC2),
              ),
            );
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Book a Feedback Session',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  //Build Schedule Timeline Content
  Widget _buildScheduleContent() {
    // Using the ordinal suffix method to format the date properly
    final day = _selectedDate.day;
    final suffix = _getOrdinalSuffix(day);

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${DateFormat('EEEE, d').format(_selectedDate)}$suffix',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          //List of schedule items
          Expanded(
            child: ListView.builder(
              itemCount: scheduleItems.length,
              itemBuilder: (context, index) {
                final item = scheduleItems[index];
                return _buildScheduleItem(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Building a single timeline item
  Widget _buildScheduleItem(Map<String, dynamic> item){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Display the scheduled time
          SizedBox(
            width: 50,
            child: Text(
              item['time'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),

          SizedBox(width: 10),

          //Displaying schedule details
          Expanded(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: item['backgroundColor'],
                borderRadius: BorderRadius.circular(15),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Display Session title
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5),

                  //Display schedule duration
                  Text(
                    item['duration'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
