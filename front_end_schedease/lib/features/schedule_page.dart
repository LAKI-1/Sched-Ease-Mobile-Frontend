
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //dependency for date formatting

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
              _buildCalendarSection(),

              Expanded(
                  child: _buildScheduleContent(),
              ),
            ],
          ),
      ),
    );
  }

  //Build the calendar section
  Widget _buildCalendarSection(){
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF3C5A7D), //Bg color of the calendar
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
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
            height: 80,
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
        width: 60,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
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
            SizedBox(height: 5),

            //Displaying date
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : isCurrentMonth
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Build Schedule Timeline Content
  Widget _buildScheduleContent() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Book Session Button
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
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
          SizedBox(height: 30),

          //Display the selected date large
          Text(
            DateFormat('EEEE, d\'th\'').format(_selectedDate),
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





















// class SchedulePage extends StatefulWidget {
//   @override
//   _SchedulePageState createState() => _SchedulePageState();
// }
//
// class _SchedulePageState extends State<SchedulePage> {
//   // Initialize controllers and date variables
//   late PageController _weekPageController;
//   late DateTime _selectedDate;
//   late DateTime _currentMonth;
//   int _currentWeekPage = 1000; // Start from middle for infinite scroll
//
//   // Sample schedule data
//   final List<Map<String, dynamic>> scheduleItems = [
//     {
//       'time': '10.00',
//       'title': 'Session With Supervisor(Mr. John)',
//       'duration': '10.00 - 12.00',
//       'backgroundColor': Colors.blue.withOpacity(0.1),
//     },
//     {
//       'time': '13.00',
//       'title': 'CS-12 Group Meeting',
//       'duration': '13.00 - 14.00',
//       'backgroundColor': Colors.red.withOpacity(0.1),
//     },
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedDate = DateTime.now();
//     _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
//     _weekPageController = PageController(initialPage: _currentWeekPage);
//   }
//
//   @override
//   void dispose() {
//     _weekPageController.dispose();
//     super.dispose();
//   }
//
//   // Get the first date of the week
//   DateTime _getFirstDayOfWeek(DateTime date) {
//     return date.subtract(Duration(days: date.weekday - 1));
//   }
//
//   // Get the week days
//   List<DateTime> _getDaysInWeek(DateTime date) {
//     DateTime firstDayOfWeek = _getFirstDayOfWeek(date);
//     return List.generate(5, (index) => firstDayOfWeek.add(Duration(days: index)));
//   }
//
//   // Handle month changes
//   void _handleMonthChange(bool next) {
//     setState(() {
//       if (next) {
//         _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
//       } else {
//         _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
//       }
//       _selectedDate = _currentMonth;
//
//       // Update the page view to show the first week of the new month
//       DateTime firstDayOfMonth = _getFirstDayOfWeek(_currentMonth);
//       int pageDiff = next ? 4 : -4; // Approximate weeks in a month
//       _currentWeekPage += pageDiff;
//       _weekPageController.jumpToPage(_currentWeekPage);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildCalendarSection(),
//             Expanded(
//               child: _buildScheduleContent(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCalendarSection() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Color(0xFF6B8E9B),
//         borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           // Month navigation row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.chevron_left, color: Colors.white),
//                 onPressed: () => _handleMonthChange(false),
//               ),
//               Text(
//                 DateFormat('MMMM yyyy').format(_currentMonth),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.chevron_right, color: Colors.white),
//                 onPressed: () => _handleMonthChange(true),
//               ),
//             ],
//           ),
//           SizedBox(height: 20),
//           // Week view
//           SizedBox(
//             height: 80,
//             child: PageView.builder(
//               controller: _weekPageController,
//               onPageChanged: (page) {
//                 setState(() {
//                   int weekDiff = page - _currentWeekPage;
//                   _currentWeekPage = page;
//                   DateTime newDate = _selectedDate.add(Duration(days: weekDiff * 7));
//                   _selectedDate = newDate;
//                   _currentMonth = DateTime(newDate.year, newDate.month);
//                 });
//               },
//               itemBuilder: (context, page) {
//                 int weekDiff = page - _currentWeekPage;
//                 DateTime weekStart = _selectedDate.add(Duration(days: weekDiff * 7));
//                 List<DateTime> days = _getDaysInWeek(weekStart);
//
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: days.map((date) => _buildDayItem(date)).toList(),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDayItem(DateTime date) {
//     bool isSelected = date.year == _selectedDate.year &&
//         date.month == _selectedDate.month &&
//         date.day == _selectedDate.day;
//     bool isCurrentMonth = date.month == _currentMonth.month;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedDate = date;
//           _currentMonth = DateTime(date.year, date.month);
//         });
//       },
//       child: Container(
//         width: 60,
//         padding: EdgeInsets.symmetric(vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.transparent,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Column(
//           children: [
//             Text(
//               DateFormat('E').format(date).substring(0, 3),
//               style: TextStyle(
//                 color: isSelected
//                     ? Colors.black
//                     : isCurrentMonth
//                     ? Colors.white
//                     : Colors.white.withOpacity(0.5),
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               date.day.toString(),
//               style: TextStyle(
//                 color: isSelected
//                     ? Colors.black
//                     : isCurrentMonth
//                     ? Colors.white
//                     : Colors.white.withOpacity(0.5),
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildScheduleContent() {
//     return Container(
//       padding: EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Feedback session button
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 5,
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Text(
//                 'Book a Feedback Session',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           // Selected date display
//           Text(
//             DateFormat('EEEE, d\'th\'').format(_selectedDate),
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 20),
//           // Schedule items list
//           Expanded(
//             child: ListView.builder(
//               itemCount: scheduleItems.length,
//               itemBuilder: (context, index) {
//                 final item = scheduleItems[index];
//                 return _buildScheduleItem(item);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildScheduleItem(Map<String, dynamic> item) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 50,
//             child: Text(
//               item['time'],
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ),
//           SizedBox(width: 10),
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.all(15),
//               decoration: BoxDecoration(
//                 color: item['backgroundColor'],
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item['title'],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     item['duration'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }