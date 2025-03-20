import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//This class manages the scheduling across different pages in the app
class EventService{
  static final EventService _instance = EventService._();
  static EventService get instance => _instance;

  //Storing scheduled events, by grouping them date as the key
  Map<String, List<Map<String, dynamic>>> _scheduledEvents ={};

  //Create a stream controller to notify listeners of changes
  final ValueNotifier <Map<String, List<Map<String,dynamic>>>> eventsNotifier =
      ValueNotifier <Map<String,List<Map<String, dynamic>>>>({});

  EventService._(){
    //Initialise the process with sample data
    _initializeSchedule();

    //Update the notifier with initial data
    eventsNotifier.value = _scheduledEvents;
  }

  void _initializeSchedule(){
    final today = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(today);

    _scheduledEvents[todayString] =[
      {
        'time': '10.00',
        'title': 'Session with Supervisor (Mr.Albert)',
        'duration': '10.00 - 12.00',
        'backgroundColor': Color(0xFFC5DCC2).withOpacity(0.8),
      },
      {
        'time': '13.00',
        'title': 'CS-12 Group Meeting',
        'duration': '13.00 - 14.00',
        'backgroundColor': Color(0xFFFBFBFB),
        'type': 'meeting',
      },
      {
        'time': '15.00',
        'title': 'Database CW Submission',
        'duration': '15.00',
        'backgroundColor': Color(0xFFFBFBFB),
        'type': 'submission',
      },
      {
        'time': '17.00',
        'title': 'Feedback Session with Mr. Albert',
        'duration': '17.00 - 17.30',
        'backgroundColor': Color(0xFFC5DCC2).withOpacity(0.8),
      },
    ];
  }

  //Getting all events for a specific date
  List<Map<String, dynamic>> getEventsForDate(DateTime date){
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    return _scheduledEvents[dateString] ?? [];
  }

  //Getting today's events
  List<Map<String, dynamic>> getTodayEvents(){
      final today = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(today);
      return _scheduledEvents[todayString] ?? [];
  }

  //Get first N events for today
  List<Map<String, dynamic>> getFirstNEventsForToday (int count){
    final events = getTodayEvents();
    //Sorting events by time
    events.sort((a,b) =>
        a['time'].toString().compareTo(b['time'].toString()));

    //Return only first count events or fewer
    return events.length > count ? events.sublist(0, count): events;
  }

  //Adding new events
  void addEvent({
    required DateTime date,
    required String title,
    required String timeSlot,
    Map<String, dynamic>? additionalInfo,
  }) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final startTime = timeSlot.split(' - ')[0];

    final newEvent = {
      'time': startTime,
      'title': title,
      'duration': timeSlot,
      'backgroundColor': Color(0xFFC5DCC2).withOpacity(0.5),
      ...?additionalInfo,
    };

    if (!_scheduledEvents.containsKey(dateString)) {
      _scheduledEvents[dateString] = [];
    }

    _scheduledEvents[dateString]!.add(newEvent);

    // Sort events by time
    _scheduledEvents[dateString]!.sort((a, b) =>
        a['time'].toString().compareTo(b['time'].toString()));

    // Notify listeners of the change
    eventsNotifier.value = Map.from(_scheduledEvents);
  }

  // Add session specifically for feedback sessions
  void addFeedbackSession({
    required DateTime date,
    required String mentorName,
    required String timeSlot,
    required String focusText,
    required String groupNumber,
  }) {
    addEvent(
      date: date,
      title: 'Feedback Session with $mentorName',
      timeSlot: timeSlot,
      additionalInfo: {
        'focus': focusText,
        'group': groupNumber,
      },
    );
  }

}