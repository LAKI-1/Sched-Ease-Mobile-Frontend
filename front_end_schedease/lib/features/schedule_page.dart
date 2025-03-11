import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; //dependency for date formatting
import 'package:front_end_schedease/features/mentor_selection_page.dart';
import 'dart:async';
import 'package:front_end_schedease/service/event_service.dart';


class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class ReminderService{
  static final ReminderService _instance = ReminderService._();
  static ReminderService get instance => _instance;

  //Storing scheduled reminders, group by date as the key
  Map<String, List <Map<String,dynamic>>> _scheduledReminders = {};
  Timer? _reminderTimer; //Checks for reminders that are yet to be notified
  Function (String title, String body) ? onReminderDue; //Calls this function when a reminder is due

  ReminderService._(); //Constructor

  void init (Function(String title, String body) callback) {
    onReminderDue = callback; //Stores callback function

    _reminderTimer = Timer.periodic(Duration(minutes: 1), (timer){
      _checkForUpcomingReminders();
    });
  }

  void dispose(){
    _reminderTimer?.cancel(); //Cancels the timer when the app is disposed
  }

  void scheduleReminder({
    required String sessionId, //Unique identifier for the session
    required DateTime sessionTime, //Session start time
    required String title, //Notification title
    required String body, //Notification body
}){
    final dateKey = DateFormat('yyyy-MM-dd').format(sessionTime);

    final reminderData = {
      'id':sessionId,
      'sessionTime': sessionTime,
      'reminderTime': sessionTime.subtract(Duration(minutes: 60)), //Defaults to one hour
      'title': title,
      'body': body,
      'triggered':false, //Flag checks if reminder is shown or not
    };

    if (!_scheduledReminders.containsKey(dateKey)){
      _scheduledReminders[dateKey] =[]; //Initialise empty list for this date if needed
    }

    _scheduledReminders[dateKey]!.add(reminderData);
    print('Reminder scheduled for $sessionTime');
  }

  //Check if any reminders should be shown be shown now
  void _checkForUpcomingReminders(){
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    if(_scheduledReminders.containsKey(today)){
      final reminders = _scheduledReminders[today]!;

      for (var reminder in reminders){
        if(!reminder ['triggered'] &&
            reminder['reminderTime'].isBefore(now) &&
            reminder['reminderTime'].isAfter(now.subtract(Duration(minutes: 2)))){

          //Mark triggered to prevent duplicates
          reminder['triggered']=true;

          //Calling function to show notification
          if(onReminderDue != null){
            onReminderDue !(reminder['title'], reminder['body']);
          }
        }
      }
    }
  }

  List <Map<String, dynamic>> getRemindersForDate(DateTime date){
    final dateKey = DateFormat('yyyy-MM-dd').format(date);
    return _scheduledReminders[dateKey] ?? [];
  }
}

class _SchedulePageState extends State<SchedulePage>{
  late PageController _weekPageController; //Managing the week view of the calendar
  late DateTime _selectedDate; // Tracks the selected date by user
  late DateTime _currentMonth; //Tracks the displayed month

  int _currentWeekPage = 1000; //index for infinite scrolling

 final  EventService _eventService =EventService.instance;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _weekPageController = PageController(initialPage: _currentWeekPage);


    //Initialize the reminder service with callback
    ReminderService.instance.init(_showReminderNotification);

    //Schedule reminders for al existing sessions
    _scheduleRemindersForAllSessions();

  }
    Timer? _reminderCheckTimer; //Timer checks reminders periodically
    bool _notificationsEnabled = true; //User preference: To keep notifications enabled
    int _reminderTimeMinutes = 60;  //User preference: How many minutes earlier to remind session


  void _addSessionToSchedule({
    required DateTime date,
    required String mentorName,
    required String timeSlot,
    required String focusText,
    required String groupNumber,
  }) {
    // Use EventService to add the session
    _eventService.addFeedbackSession(
      date: date,
      mentorName: mentorName,
      timeSlot: timeSlot,
      focusText: focusText,
      groupNumber: groupNumber,
    );
    // Schedule a reminder for this new session
    _scheduleReminderForSession(
        date,
        timeSlot.split(' - ')[0],
        {
          'title': 'Feedback Session with $mentorName',
          'time': timeSlot.split(' - ')[0],
          'duration': timeSlot,
        }
    );
    //Force a UI update
    setState(() {});
  }
  // Get scheduled events for selected date
  List<Map<String, dynamic>> _getScheduleForSelectedDate() {
  return _eventService.getEventsForDate(_selectedDate);
  }

  @override
  void dispose() {
    _weekPageController.dispose();  //Dispose the PageController to free up resources
    ReminderService.instance.dispose(); //Cleans up reminder service
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
  //Use this commented code snippet to test alerts and notification
//   @override
//   Widget build(BuildContext context){
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             Container(
//               height: 20, //Adds space between top and calendar
//               color: Colors.white,
//             ),
//             _buildCalendarSection(),
//             Expanded(
//               child: _buildScheduleContent(),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildTestButton(), // Add this line
//     );
//   }
//
// // New method to create the test button for notifications
//   Widget _buildTestButton() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
//       color: Colors.grey[200],
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color(0xFF3C5A7D),
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             ),
//             onPressed: _scheduleTestReminder,
//             child: Text('Test Feedback Session Reminder (10s)'),
//           ),
//         ],
//       ),
//     );
//   }

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

              Row(
                children: [
                  //Bell icon for reminders
                  IconButton(
                    icon: Icon(
                      _notificationsEnabled ? Icons.notifications_active : Icons.notifications_none,
                      color: Colors.white,
                    ),
                    tooltip: 'Reminder Settings',
                    onPressed: () => _showNotificationSettingsDialog(),
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
              final events = _eventService.getEventsForDate(day);
              final hasEvents = events.isNotEmpty;


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

  // Show a popup dialog when a reminder is due
  void _showReminderNotification(String title, String body) {
    // This function is called by the ReminderService when a reminder is due
    // It shows a dialog in the center of the screen with the reminder information

    // Using Future.delayed to allow the context to be ready
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false, // User must tap a button to dismiss
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C5A7D),
              ),
            ),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Text('DISMISS',
                  style: TextStyle(color: Color(0xFF3C5A7D)),
                ),

              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3C5A7D),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  // Navigate to the schedule page if not already there
                  // This is optional - it will take users to the schedule view
                },
                child: Text('VIEW SCHEDULE',
                style: TextStyle(color: Colors.white),
              ),
              ),
            ],
          );
        },
      );
    });
  }

  // Show dialog for configuring notification settings
  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Using StatefulBuilder to allow state changes inside the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Reminder Settings'),
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Enable/disable notifications toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enable Reminders',
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: _notificationsEnabled,
                        activeColor: Color(0xFF3C5A7D),  // Blue when active
                        onChanged: (bool value) {
                          // Update local dialog state
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Reminder time selection section
                  Text(
                    'Remind me before:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),

                  // Time options as selectable chips
                  Row(
                    spacing: 8,
                    children: [
                      // 15 minutes option
                      _buildTimeOption(15, _reminderTimeMinutes, (value) {
                        setState(() {
                          _reminderTimeMinutes = value;
                        });
                      }),
                      // 30 minutes option
                      _buildTimeOption(30, _reminderTimeMinutes, (value) {
                        setState(() {
                          _reminderTimeMinutes = value;
                        });
                      }),
                      // 1 hour option
                      _buildTimeOption(60, _reminderTimeMinutes, (value) {
                        setState(() {
                          _reminderTimeMinutes = value;
                        });
                      }),
                    ],
                  ),
                ],
              ),
              actions: [
                // Cancel button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel',
                  style: TextStyle(color:Color(0xFF3C5A7D),
                  ),
                  ),
                ),
                // Save button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3C5A7D),
                  ),
                  onPressed: () {
                    // Save settings to the main state
                    this.setState(() {
                      // The settings are already saved to the class variables
                      // No additional action needed
                    });

                    // Close dialog
                    Navigator.of(context).pop();

                    // Show a confirmation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Reminder settings updated',
                          style: TextStyle(color: Colors.black),
                        ),
                        backgroundColor: Color(0xFFC5DCC2),  // Light green
                      ),
                    );
                  },
                  child: Text('Save',
                  style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper method to build selectable time option chips
  Widget _buildTimeOption(int minutes, int selectedValue, Function(int) onSelected) {
    // Check if this option is the currently selected one
    final bool isSelected = minutes == selectedValue;

    // Format the label based on the time
    String label;
    if (minutes < 60) {
      label = '$minutes min';  // For minutes (e.g., "15 min")
    } else {
      // For hours (e.g., "1 hour" or "2 hours")
      label = '${minutes ~/ 60} hour${minutes == 60 ? '' : 's'}';
    }

    // Create a selectable chip for this time option
    return GestureDetector(
      onTap: () => onSelected(minutes),  // Call the callback with this value when tapped
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Blue background if selected, light gray if not
          color: isSelected ? Color(0xFF3C5A7D) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            // White text if selected, black if not
            color: isSelected ? Colors.white : Colors.black,
            // Bold if selected
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }


  // Schedule a reminder for a specific session
  void _scheduleReminderForSession(DateTime date, String timeString, Map<String, dynamic> session) {
    // Only schedule if notifications are enabled
    if (!_notificationsEnabled) return;

    // Parse the time string into hours and minutes components
    // Handle both formats: "10.00" and "10:00"
    final timeParts = timeString.replaceAll('.', ':').split(':');
    if (timeParts.length < 2) return;  // Skip if invalid format

    // Convert string time parts to integers
    final hours = int.tryParse(timeParts[0]) ?? 0;
    final minutes = int.tryParse(timeParts[1]) ?? 0;

    // Create a DateTime object for the exact session start time
    final sessionDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hours,
      minutes,
    );

    // Create a unique ID for this session based on date and time
    // This allows us to identify and manage the reminder later
    final sessionId = '${date.day}${date.month}${date.year}${hours}${minutes}'.replaceAll(' ', '');

    // Determine the reminder time based on user preference
    final reminderTime = sessionDateTime.subtract(Duration(minutes: _reminderTimeMinutes));

    // Create appropriate message based on session type
    String messageBody;
    if (session['title'].toLowerCase().contains('lecture')) {
      messageBody = 'You have a lecture: ${session['title']} starting at ${session['time']}';
    } else if (session['title'].toLowerCase().contains('feedback')) {
      messageBody = 'You have a feedback session: ${session['title']} starting at ${session['time']}';
    } else {
      messageBody = 'You have "${session['title']}" scheduled at ${session['time']}';
    }

    // Schedule the reminder using our ReminderService
    ReminderService.instance.scheduleReminder(
      sessionId: sessionId,
      sessionTime: sessionDateTime,
      title: 'Upcoming Session Reminder',
      body: messageBody,
    );
  }

  // Schedule reminders for all existing sessions in the schedule
  void _scheduleRemindersForAllSessions() {

      final today = DateTime.now();
      final events = _eventService.getTodayEvents();

      // Loop through all sessions for this date
      events.forEach((session) {
        // Set up a reminder for each session
        _scheduleReminderForSession(today, session['time'], session);
      });
  }

  // Use this code snippet to test out notifications
  // void _scheduleTestReminder() {
  //   // Get current time
  //   final now = DateTime.now();
  //
  //   // Schedule reminder for 10 seconds from now
  //   final reminderTime = now.add(Duration(seconds: 10));
  //
  //   // Create a unique session ID
  //   final sessionId = 'test-${now.millisecondsSinceEpoch}';
  //
  //   // Instead of relying on the standard reminder mechanism,
  //   // we'll create a direct timer to trigger the notification
  //   Timer(Duration(seconds: 10), () {
  //     _showReminderNotification(
  //         'Upcoming Feedback Session',
  //         'This is a test reminder for a feedback session with Dr. Smith at ${DateFormat('HH:mm').format(now.add(Duration(hours: 1)))}'
  //     );
  //   });
  //
  //   // Show confirmation
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Test reminder will appear in 10 seconds'),
  //       duration: Duration(seconds: 2),
  //       backgroundColor: Color(0xFFC5DCC2),
  //     ),
  //   );
  // }

}
