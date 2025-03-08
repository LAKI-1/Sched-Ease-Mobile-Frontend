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

  Map <String, List<Map<String, dynamic>>> _scheduledEvents = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _weekPageController = PageController(initialPage: _currentWeekPage);

    _initializeSchedule();
  }
    _initializeSchedule(){ //initialising with sample data
      final today = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(today);

      _scheduledEvents [todayString] = [
        {
          'time': '10.00',
          'title': 'Session with Supervisor (Mr.Albert)',
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
    }


  void _addSessionToSchedule({
    required DateTime date,
    required String mentorName,
    required String timeSlot,
    required String focusText,
    required String groupNumber,
  }) {

    //Convert date to string format for map key
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    //Parse time from timeSlot
    final startTime = timeSlot.split(' - ')[0];

    //Creating a new Session
    final newSession = {
      'time': startTime,
      'title': 'Feedback Session with $mentorName',
      'duration': timeSlot,
      'focus': focusText,
      'group': groupNumber,
      'backgroundColor': Color(0xFFC5DCC2).withOpacity(0.5),
    };
    
    setState(() {
      //If date doesn't exist in map, create a new list
      if (!_scheduledEvents.containsKey(dateString)){
        _scheduledEvents[dateString] =[];
      }
      
      //Add new session to the list to this date
      _scheduledEvents[dateString] !.add(newSession);
      
      //Sorting events by time
      _scheduledEvents[dateString]!.sort((a,b) =>
          a['time'].toString().compareTo(b['time'].toString()));
    });
  }
  
  //Get scheduled events for selected date
  List <Map<String,dynamic>> _getScheduleForSelectedDate(){
    final dateString = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return _scheduledEvents[dateString] ?? [];
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
            itemBuilder: (context, index) {
              //Empty spots before first day of month
              if (index < firstDayWeekDay) {
                return Container();
              }

              //Actual days of month
              final dayIndex = index - firstDayWeekDay;
              final day = daysInMonth[dayIndex];

              bool isSelected = day.year == _selectedDate.year &&
                  day.month == _selectedDate.month &&
                  day.day == _selectedDate.day;

              //Convert date to string format for map key
              final dateString = DateFormat('yyyy-MM-dd').format(day);
              final hasEvents = _scheduledEvents.containsKey(dateString) &&
                  _scheduledEvents[dateString]!.isNotEmpty;


              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = day;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      //Day number
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight
                              .normal,
                          color: isSelected ? Color(0xFF3C5A7D) : Colors.white,
                        ),
                      ),

                      if(hasEvents)
                        Positioned(
                          bottom: 2,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFF3C5A7D) : Color(
                                  0xFFC5DCC2),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
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
          // Checking if session details are back
          if (result is Map<String,dynamic>) {
            // Add the booked session to the schedule
            _addSessionToSchedule(
              date: result['date'],
              mentorName: result['mentorName'],
              timeSlot: result['timeSlot'],
              focusText: result['focus'],
              groupNumber: result['groupNumber'],
            );
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
    //Getting the schedule for selected date
    final scheduleItems = _getScheduleForSelectedDate();

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

          SizedBox(height: 10),

          //List of schedule items
          Expanded(
            child: scheduleItems.isEmpty
              ? _buildEmptySchedule()
              : ListView.builder(
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
  Widget _buildEmptySchedule(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 50,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: 10),
          Text(
            'No sessions scheduled for this day',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Tap "Book a Feedback Session" to schedule',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
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

                  //Show additionally booked sessions
                if (item.containsKey('focus'))
                   Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      SizedBox(height: 8),
                      Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                      SizedBox(height: 8),
                      Text(
                      'Focus: ${item['focus']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        ),
                      ),

                  if (item.containsKey('group'))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Group: ${item['group']}',
                       style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                      ),
                    ),
                  ),
                      ],
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
