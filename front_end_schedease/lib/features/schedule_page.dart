import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //dependency for date formatting
import 'package:front_end_schedease/widgets/navbar.dart';
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

  //Helper Method: To get Monday as the 1st day of week
  DateTime _getFirstDayOfWeek(DateTime date){
    return date.subtract(Duration(days: date.weekday - 1));
  }

  //Helper Method: Get 5 days of the week
  List<DateTime> _getDaysInWeek(DateTime date){
    DateTime firstDayOfWeek = _getFirstDayOfWeek(date);
    return List.generate(5, (index) => firstDayOfWeek.add(Duration(days: index )));
  }

  //Method to change month when navigating < >
  void _handleMonthChange (bool next){
    setState(() {
      if (next){
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1); //Moves to next month
      } else{
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);//Moves to previous month
      }

      _selectedDate = _currentMonth; //Update selected date to the first day of new month

      //Adjusting the page view showing the first week of new month
      DateTime firstDayOfMonth = _getFirstDayOfWeek(_currentMonth);
      int pageDiff = next ? 4 : -4; //Approximate weeks in a month
      _currentWeekPage += pageDiff;
      _weekPageController.jumpToPage(_currentWeekPage);
    });
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

  //Build the calendar section
  Widget _buildCalendarSection(){
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20, left: 15,right: 15),
      decoration: BoxDecoration(
        color: Color(0xFF3C5A7D), //Bg color of the calendar
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        children: [
          //Month nav row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Previous month
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => _handleMonthChange(false),
              ),

              //Current Month and Year
              Text(
                DateFormat('MMMM').format(_currentMonth),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),

              //Next Month
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => _handleMonthChange(true),
              ),
            ],
          ),
          SizedBox(height: 20),

          //Displaying Week with PageView
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _weekPageController,
              onPageChanged: (page) {
                setState(() {
                  //Difference in weeks from current page
                  int weekDiff = page - _currentWeekPage;
                  _currentWeekPage = page;

                  //Update the selected date
                  DateTime newDate = _selectedDate.add(Duration(days: weekDiff * 7));
                  _selectedDate = newDate;

                  //Update the month when required
                  _currentMonth = DateTime(newDate.year, newDate.month);
                });
              },
              itemBuilder: (context, page){
                //Start of the week for current page
                int weekDiff = page - _currentWeekPage;
                DateTime weekStart = _selectedDate.add(Duration(days: weekDiff * 7));

                List<DateTime> days = _getDaysInWeek(weekStart);

                //Building the row of days
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map( (date) => _buildDayItem(date) ).toList(),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          _buildBookSessionButton(),
        ],
      ),
    );
  }

  //Building a single day in the week
  Widget _buildDayItem(DateTime date){
    //Checking if user has selected the date
    bool isSelected = date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;

    //Checking if date is in current month
    bool isCurrentMonth = date.month == _currentMonth.month;

    return GestureDetector(
      onTap: () {
        setState(() {
          //Update selected date & current month
          _selectedDate = date;
          _currentMonth = DateTime(date.year, date.month);
        });
      },
      child: Container(
        width: 65,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            //Displaying the days of the week(Mon-Fri)
            Text(
              DateFormat('E').format(date).substring(0,3),
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : isCurrentMonth
                    ? Colors.white
                    :Colors.white.withOpacity(0.5),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),

            //Displaying date
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : isCurrentMonth
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
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
