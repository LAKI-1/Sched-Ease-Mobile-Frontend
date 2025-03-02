import 'package:flutter/material.dart';
import 'package:front_end_schedease/widgets/navbar.dart';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  //Controller: Manages horizontal swiping between Feedback and LogBook
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0; //Tracks what page is visible at the moment

  //Variables for filters
  String _selectedMonth = 'All';
  String _selectedYear = '2025';

  //Tracking what item is currently selected
  int? _selectedItemIndex; //Nullable for no selected

  //Tracks which feedback or recording is expanded for a detailed view
  int? _expandedFeedbackIndex;
  int? _expandedRecordingIndex;

  //Audio Player State
  bool _isPlaying=false;
  double _playbackPosition = 0.0;
  double _recordingDuration = 240.0; //in seconds

  //List of feedback items
  final List<Map<String,dynamic>> feedbackItems = [
    {
      'time': '21 March, 2025',
      'title': 'Brainstorming about ideas',
      'mentor':'Mr.Albert',
      'isRead': false,
      'month':'March',
      'year':'2025',
      'detailedFeedback':'The brainstorming session was productive. You generated several viable project ideas and demonstrated good creative thinking. I particularly liked your approach to problem identification before jumping into solutions. Consider expanding your research on user needs for the selected idea. Your enthusiasm and participation were excellent. For next steps, I recommend narrowing down to 2-3 ideas and conducting a preliminary feasibility analysis for each.',

    },
    {
      'time': '13 April, 2025',
      'title': 'Clear idea on project management',
      'mentor':'Ms.Anne',
      'isRead': false,
      'month':'April',
      'year':'2025',
      'detailedFeedback': 'You\'ve shown significant improvement in your project management approach. The timeline and resource allocation were well thought out. I appreciate your use of Gantt charts to visualize the project schedule. To further improve, consider adding risk management strategies and contingency plans. Also, think about how you might handle scope creep as the project progresses. Your communication skills during the presentation were clear and professional.',
    },
    {
      'time': '30 May, 2025',
      'title': 'Implementation discussion',
      'mentor':'Mr.Leo',
      'isRead': false,
      'month':'March',
      'year':'2025',
      'detailedFeedback': 'Your implementation strategy demonstrates good technical understanding. The architecture design is logical and scalable. I like how you\'ve modularized the components for better maintenance. Areas for improvement include: (1) Consider adding more automated tests to ensure code quality, (2) Documentation could be more detailed for complex functions, (3) Think about optimization for performance-critical sections. Overall, you\'re on the right track and showing good progress in translating design into working code.',
    },
    {
      'time': '13 June, 2025',
      'title': 'Assisted for the debugging of code',
      'mentor':'Mr.Albert',
      'isRead': false,
      'month':'June',
      'year':'2025',
      'detailedFeedback': 'Today\'s debugging session was productive. You\'ve shown improvement in your debugging approach by using systematic techniques rather than random changes. Good use of breakpoints and logging to isolate the issues. For more complex bugs, I recommend adding unit tests that reproduce the issues before fixing them. This will help prevent regression. Also, consider using profiling tools to identify performance bottlenecks in your application. Your persistence in tracking down the root causes was commendable.',
    },
  ];

  //List of logBook items
  final List<Map<String,dynamic>> logBookItems = [
    {
      'time': '21 March, 2025',
      'title': 'Feedback Session with Mr.Albert Recording',
      'student':'George Patrick',
      'month':'March',
      'year':'2025',
      'recordingLength':'3:45',
      'transcript': [
        {'time': '00:00', 'speaker': 'Mr.Albert', 'text': 'Good morning, George. Today we\'ll be discussing your project ideas.'},
        {'time': '00:15', 'speaker': 'George', 'text': 'Yes, I\'ve prepared several concepts I\'d like to share.'},
        {'time': '00:30', 'speaker': 'Mr.Albert', 'text': 'Great. Let\'s start with your primary concept.'},
        {'time': '00:45', 'speaker': 'George', 'text': 'My main idea focuses on creating a scheduling application for mentorship programs.'},
        {'time': '01:15', 'speaker': 'Mr.Albert', 'text': 'Interesting approach. What problem are you trying to solve specifically?'},
        {'time': '01:30', 'speaker': 'George', 'text': 'I noticed that coordinating meeting times between mentors and students is often inefficient.'},
        {'time': '02:00', 'speaker': 'Mr.Albert', 'text': 'Have you conducted any initial research on user needs?'},
        {'time': '02:15', 'speaker': 'George', 'text': 'Yes, I interviewed 5 mentor-student pairs and found scheduling conflicts were common.'},
        {'time': '02:45', 'speaker': 'Mr.Albert', 'text': 'Excellent start. For next steps, I recommend narrowing your focus and developing a prototype.'},
        {'time': '03:15', 'speaker': 'George', 'text': 'Thank you for the feedback. I\'ll refine the concept further.'},
      ],
    },
    {
      'time': '22 March, 2025',
      'title': 'Team Meeting Recording',
      'student':'Sienna Riverly',
      'month':'March',
      'year':'2025',
      'recordingLength':'2:00',
      'transcript': [
        {'time': '00:00', 'speaker': 'Team Lead', 'text': 'Welcome everyone to our weekly team meeting. Let\'s start with project updates.'},
        {'time': '00:20', 'speaker': 'Emma', 'text': 'I\'ve completed the user interface wireframes for the dashboard section.'},
        {'time': '00:45', 'speaker': 'James', 'text': 'The API integration is about 70% complete. We\'re still waiting on documentation for the payment endpoints.'},
        {'time': '01:10', 'speaker': 'Sarah', 'text': 'I\'ve identified some performance issues in the data loading process that we should address.'},
        {'time': '01:30', 'speaker': 'Team Lead', 'text': 'Can you elaborate on the performance issues, Sarah?'},
        {'time': '01:45', 'speaker': 'Sarah', 'text': 'The initial data load takes over 3 seconds on slower connections. I think we should implement progressive loading.'},
        {'time': '02:15', 'speaker': 'Michael', 'text': 'I can help with optimizing those queries if needed.'},
        {'time': '02:35', 'speaker': 'Team Lead', 'text': 'That would be great. Let\'s set up a separate meeting to discuss the technical approach.'},
        {'time': '02:55', 'speaker': 'Emma', 'text': 'Should we also consider caching frequently accessed data?'},
        {'time': '03:10', 'speaker': 'Team Lead', 'text': 'Yes, good point. Michael and Sarah, please include caching strategies in your proposal.'},
        {'time': '03:30', 'speaker': 'James', 'text': 'I\'ll send everyone the updated project timeline by the end of the day.'},
        {'time': '03:45', 'speaker': 'Team Lead', 'text': 'Perfect. Any other concerns or questions before we wrap up?'},
        {'time': '04:05', 'speaker': 'Sarah', 'text': 'Just a reminder that the client demo is scheduled for next Tuesday.'},
        {'time': '04:20', 'speaker': 'Team Lead', 'text': 'Thanks for the reminder. Let\'s aim to have all critical features ready by Monday afternoon.'},
      ],

    },
    {
      'time': '13 April, 2025',
      'title': 'Feedback Session with Ms.Anne Recording',
      'student':'Brendon Feenix',
      'month':'April',
      'year':'2025',
      'transcript': [
        {'time': '00:00', 'speaker': 'Ms.Anne', 'text': 'Good afternoon, Brendon. Let\'s discuss your project management approach today.'},
        {'time': '00:18', 'speaker': 'Brendon', 'text': 'Thank you for meeting with me. I\'ve prepared a summary of our project timeline.'},
        {'time': '00:30', 'speaker': 'Ms.Anne', 'text': 'I see you\'ve created a Gantt chart to visualize the schedule. That\'s very helpful.'},
        {'time': '00:50', 'speaker': 'Brendon', 'text': 'Yes, I thought it would make it easier to track dependencies between tasks.'},
        {'time': '01:10', 'speaker': 'Ms.Anne', 'text': 'It does. Your resource allocation also looks well thought out. Have you considered risk management?'},
        {'time': '01:35', 'speaker': 'Brendon', 'text': 'Not in detail yet. That\'s something I need to develop further.'},
        {'time': '01:48', 'speaker': 'Ms.Anne', 'text': 'I recommend adding contingency plans for potential delays, especially for the critical path items.'},
        {'time': '02:15', 'speaker': 'Brendon', 'text': 'That makes sense. Would you suggest building buffer time into the schedule as well?'},
        {'time': '02:35', 'speaker': 'Ms.Anne', 'text': 'Absolutely. A good rule of thumb is adding 20% buffer to tasks with external dependencies.'},
        {'time': '02:55', 'speaker': 'Brendon', 'text': 'I\'ll make those adjustments to our timeline. What about our communication plan?'},
        {'time': '03:15', 'speaker': 'Ms.Anne', 'text': 'Your communication strategy is clear and professional. I particularly like the weekly status report template.'},
        {'time': '03:40', 'speaker': 'Brendon', 'text': 'Thank you. I tried to keep it concise while including all essential information.'},
        {'time': '03:55', 'speaker': 'Ms.Anne', 'text': 'One more thing to consider is scope creep. Have you established a change request process?'},
        {'time': '04:20', 'speaker': 'Brendon', 'text': 'Not yet, but I\'ll incorporate that into our project management plan.'},
        {'time': '04:40', 'speaker': 'Ms.Anne', 'text': 'Great. Overall, you\'re on the right track. I look forward to seeing your revised plan next week.'},
      ],
    },
    // {
    //   'time': '30 May, 2025',
    //   'title': 'Feedback Session with Mr.Leo Recording',
    //   'student':'Bella Anderson',
    //   'month':'March',
    //   'year':'2025',
    // },
    // {
    //   'time': '13 June, 2025',
    //   'title': 'Feedback Session with Ms.Priya Recording',
    //   'student':'Micheala Judith',
    //   'month':'June',
    //   'year':'2025',
    // },
  ];

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  void _changePage (int index) {
    //Method: switches between Feedback and LogBook
    setState(() {
      _currentPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  //Toggle play/pause button for recording
  void _togglePlayback(){
    setState(() {
      _isPlaying = !_isPlaying;
    });

    //Controls actual playback
    if(_isPlaying){
      //Start a timer to update playback position
      _startPlayback();
    }
  }

  void _startPlayback() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_isPlaying) {
        setState(() {
          _playbackPosition += 0.1;
          if (_playbackPosition >= _recordingDuration) {
            _playbackPosition = 0;
            _isPlaying = false;
          }
        });
        _startPlayback();
      }
    });
  }

  //Format time to mm:ss
  String _formatTime (double seconds){
    final int mins = (seconds / 60).floor();
    final int secs = (seconds % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  double _parseTimeToSeconds(String timeStr){
    //Helper method: Parse String time to seconds ("1:30" --> 90)
    final parts = timeStr.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return minutes * 60 + seconds.toDouble();
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 20,
                color: Colors.white,
              ),
              Center(child: _buildPageSwitcher()), //Switches tabs on the top
              Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index){
                      setState(() {
                        _currentPageIndex = index;
                        //Reset selection when changing pages
                        _selectedItemIndex = null;
                        _expandedFeedbackIndex = null;
                        _expandedRecordingIndex = null;

                        //Stops Playback when switching pages
                        _isPlaying = false;
                      });
                    },
                    children: [
                      _buildFeedbackPage(),
                      _buildLogBookPage(),
                    ],
                  ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildPageSwitcher(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        color: Color(0xFF3C5A7D), //Dark Blue
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Row(
        children: [
          Expanded( //Feedback tab button
              child: GestureDetector(
                onTap: () => _changePage(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _currentPageIndex == 0 ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),

                  child: Center(
                    child:Text(
                      'Feedback',
                      style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _currentPageIndex == 0 ? Color(0xFF3C5A7D) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ),
          SizedBox(width: 5),

          Expanded( //LogBook tab button
            child: GestureDetector(
              onTap: () => _changePage(1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12) ,
                decoration: BoxDecoration(
                  color: _currentPageIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: Text(
                    'Log Book',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _currentPageIndex == 1 ? Color(0xFF3C5A7D) : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String value,
    required List <String> items,
    required Function (String?) onChanged,
    double width = 120,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFC5DCC2)), //Mint green border
        boxShadow: [
          BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 3,
          offset: Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            icon: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Color(0xFFC5DCC2).withOpacity(0.2), //Light mint bg
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: Color(0xFF3C5A7D), //Dark blue
              ),
            ),
            isExpanded: true,
            isDense: true,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(15),
            elevation: 3,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF3C5A7D),
              fontWeight: FontWeight.w500,
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value){
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
    ),
    ),
    );
  }

  Widget _buildFeedbackPage(){
    //Filter feedback based on the selected year and month
    List<Map<String,dynamic>> filteredFeedbackItems = feedbackItems.where((item){
      bool yearMatch = _selectedYear == 'All' || item['year'] == _selectedYear;
      bool monthMatch = _selectedMonth == 'All' || item['month'] == _selectedMonth;
      return yearMatch && monthMatch;
    }).toList();

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Page Title
          Text(
            'Mentor Feedback',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),

          //Dropdowns for filtering
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFC5DCC2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 18, color: Colors.grey[600]),
                    SizedBox(width: 5),
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ],
                ),
              ),
              Spacer(), //Pushes the dropdown to right

              //Month dropdown
              _buildCustomDropdown(
                value: _selectedMonth,
                //List of months for dropdown
                items: <String>['All','January','February','March','April','May','June','July','August','September','October','November','December'],
                onChanged: (String? newValue){
                  if (newValue != null){
                    setState(() {
                      _selectedMonth = newValue;
                    });
                  }
                },
                width: 130,
              ),
              SizedBox(width: 10),

              _buildCustomDropdown(
                value : _selectedYear,
                items: <String>['All','2024','2025','2026'],
                onChanged: (String? newValue){
                  if (newValue != null){
                    setState(() {
                      _selectedYear = newValue;
                    });
                  }
                },
                width: 80,
              ),
            ],
          ),
        SizedBox(height: 20),
        Expanded(
            child: ListView.builder(
              itemCount: filteredFeedbackItems.length,
              itemBuilder: (context, index){
                final item = filteredFeedbackItems[index];
                final isExpanded = _expandedFeedbackIndex == index;
                return _buildFeedbackItem(item, index, isExpanded);
              },
            ),
        ),
        ],
      ),
    );
  }

  Widget _buildLogBookPage(){
    //Filter recorded logs based on the selected year and month
    List<Map<String,dynamic>> filteredLogBookItems = logBookItems.where((item){
      bool yearMatch = _selectedYear == 'All' || item['year'] == _selectedYear;
      bool monthMatch = _selectedMonth == 'All' || item['month'] == _selectedMonth;
      return yearMatch && monthMatch; //item matches month and year
    }).toList();

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Page Title
          Text(
            'Recorded Sessions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          //Dropdowns for filtering
          Row(
              children: [
                Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFC5DCC2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.filter_list, size: 16, color: Color(0xFF3C5A7D)),
                    SizedBox(width: 5),
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF3C5A7D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                ),
                Spacer(), //Pushes the dropdown to right

                //Month dropdown
                _buildCustomDropdown(
                  value: _selectedMonth,
                  //List of months for dropdown
                  items: <String>['All','January','February','March','April','May','June','July','August','September','October','November','December'],
                  onChanged: (String? newValue){
                    if (newValue != null){
                      setState(() {
                        _selectedMonth = newValue;
                      });
                    }
                  },
                  width: 130,
                ),
                SizedBox(width: 10),

                _buildCustomDropdown(
                  value : _selectedYear,
                  items: <String>['All','2024','2025','2026'],
                  onChanged: (String? newValue){
                    if (newValue != null){
                      setState(() {
                        _selectedYear = newValue;
                      });
                    }
                  },
                  width: 80,
                ),
              ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLogBookItems.length,
              itemBuilder: (context, index){
                final item = filteredLogBookItems[index];
                final isExpanded = _expandedRecordingIndex == index;
                return _buildLogBookItem(item, index, isExpanded);
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildFeedbackItem(Map<String, dynamic> item, int index, bool isExpanded) {
    //Checks if item is selected
    bool isSelected = _selectedItemIndex == index;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        //Mint green bg when selected, else white
        color: isSelected ? Color(0xFFC5DCC2).withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              //Toggle item selection
              setState(() {
                if (_selectedItemIndex == index) {
                  _selectedItemIndex = null; //If selected, then deselect
                } else {
                  _selectedItemIndex = index; //Else, select this item deselecting others
                }
              });
            },
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),

                  Row(
                    //User and date info row
                    children: [
                      //Mentor icon and name
                      Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
                      SizedBox(width: 5),
                      Text(
                        item['mentor'] ?? 'Unknown Mentor',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(width: 15),
                      //Date icon and value
                      Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[500]),
                      SizedBox(width: 5),
                      Text(
                        item['time'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                      Spacer(),
                      //Shows green check if item is read (Clicked 'View More')
                      if (item['isRead'] ?? false)
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                    ],
                  ),

                  SizedBox(height: 12),

                  //View More button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //Mark read when clicked
                          setState(() {
                            item['isRead'] = true;
                            //Toggles expanded view
                            if (_expandedFeedbackIndex == index) {
                              _expandedFeedbackIndex = null;
                            } else {
                              _expandedFeedbackIndex = index;
                            }
                          });
                        },
                        child: Text(
                          isExpanded ? 'Close Details' : 'View More',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3C5A7D), //Dark blue
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded detailed feedback view - left incomplete as requested
          if (isExpanded)
            _buildDetailedFeedbackView(item),
        ],
      ),
    );
  }

  Widget _buildDetailedFeedbackView(Map<String, dynamic> item){
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFC5DCC2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.comment_outlined,
                size: 18,
                color: Color(0xFF3C5A7D),
              ),
              SizedBox(width: 8),
              Text(
                'Detailed Feedback',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C5A7D),
                ),
              ),
            ],
          ),
          SizedBox(height:10),
          Text(
            item['detailedFeedback'] ?? 'No detailed feedback available.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          SizedBox(height:15),

        ],
      ),
    );
  }

  Widget _buildLogBookItem(Map<String, dynamic> item, int index, bool isExpanded) {
    //Checks if item is selected
    bool isSelected = _selectedItemIndex == index;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFFC5DCC2).withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child:Column(
        children: [
          GestureDetector(
              onTap: (){
            //Toggle item selection
            setState(() {
              if (_selectedItemIndex == index){
                _selectedItemIndex = null; //If selected, then deselect
              }else{
                _selectedItemIndex = index; //Else, select this item deselecting others
              }
        });
    },
    child: Container(
    padding: EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
      ),
      SizedBox(height: 10),

    Row( //User and date info row
    children: [
      //Mentor icon and name
      Icon(Icons.person_outline, size: 16, color: Colors.grey[500]),
      SizedBox(width: 5),
      Text(
        item['student'] ?? 'Unknown Student',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[500],
        ),
        ),
      SizedBox(width: 15),
      //Date icon and value
      Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey[500]),
      SizedBox(width: 5),
      Text(
        item['time'],
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[500],
        ),
      ),
      Spacer(),

      //Recording length
      Icon(Icons.timer_outlined, size: 16, color: Colors.grey[500]),
      SizedBox(width: 3),
      Text(
        item['recordingLength'] ?? '0:00',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[500],
        ),
       )
      ],
    ),
    SizedBox(height: 12),

    //View More button
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
    GestureDetector(
      onTap: () {
      setState(() {
        //Reset playback
        _playbackPosition = 0;
        _isPlaying = false;

        //Toggles expanded view
        if(_expandedRecordingIndex == index){
          _expandedRecordingIndex = null;
        } else {
          _expandedRecordingIndex = index;
        }
      });
      },
      child: Text(
        isExpanded ? 'Close Recording' : 'View More',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3C5A7D), //Dark blue
          ),
        ),
      ),
      ],
      ),
      ],
      ),
    ),
    ),

    if (isExpanded) _buildRecordingPlayerView(item),
      ],
    ),
    );
  }

  Widget _buildRecordingPlayerView(Map<String, dynamic> item) {
    // Get transcript from the item
    List<Map<String, dynamic>> transcript = List<Map<String, dynamic>>.from(item['transcript'] ?? []);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFC5DCC2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      // Title for the recording section
      Row(
      children: [
      Icon(
      Icons.mic_none_outlined,
        size: 18,
        color: Color(0xFF3C5A7D),
      ),
      SizedBox(width: 8),
      Text(
        'Recording Player',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3C5A7D),
        ),
      ),
      ],
    ),
    SizedBox(height: 10),

    // Recording player section
    Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
      color: Color(0xFF3C5A7D).withOpacity(0.05),
      borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
        // Audio controls
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayback,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
              color: Color(0xFF3C5A7D),
              shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              ),
          ),
        ],
      ),
      SizedBox(height: 15),

      // Progress bar
      Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: Color(0xFF3C5A7D),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Color(0xFF3C5A7D),
            overlayColor: Color(0xFF3C5A7D).withOpacity(0.2),
          ),
        child: Slider(
          value: _playbackPosition,
          min: 0,
          max: _recordingDuration,
          onChanged: (value) {
            setState(() {
             _playbackPosition = value;
            });
        },
        ),
        ),

      // Time indicators
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(
            _formatTime(_playbackPosition),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          Text(
            _formatTime(_recordingDuration),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          ],
        ),
        ),
      ],
      ),
      ],
    ),
    ),
          SizedBox(height: 20),

          // Transcript section
          Row(
            children: [
              Icon(
                Icons.text_snippet_outlined,
                size: 18,
                color: Color(0xFF3C5A7D),
              ),
              SizedBox(width: 8),
              Text(
                'Transcript',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C5A7D),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          // Transcript content
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!),
            ),
            height: 200, // Fixed height with scrolling
            child: transcript.isEmpty
                ? Center(child: Text('No transcript available for this recording.'))
                : ListView.builder(
              itemCount: transcript.length,
              itemBuilder: (context, idx) {
                final entry = transcript[idx];
                // Calculate if this transcript entry is active based on current playback time
                // This is a simple implementation - in a real app, you'd use actual timestamps
                final timeStr = entry['time'] as String;
                final mins = int.parse(timeStr.split(':')[0]);
                final secs = int.parse(timeStr.split(':')[1]);
                final entryTimeInSeconds = mins * 60 + secs;

                final bool isActiveEntry = _isPlaying &&
                    entryTimeInSeconds <= _playbackPosition &&
                    (idx == transcript.length - 1 ||
                        _playbackPosition < (idx + 1 < transcript.length
                            ? _parseTimeToSeconds(transcript[idx + 1]['time'] as String)
                            : _recordingDuration));

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActiveEntry ? Color(0xFFC5DCC2).withOpacity(0.3) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isActiveEntry
                        ? Border.all(color: Color(0xFFC5DCC2))
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time and speaker info
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Color(0xFF3C5A7D).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              entry['time'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3C5A7D),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            entry['speaker'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isActiveEntry ? Color(0xFF3C5A7D) : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      // Transcript text
                      Text(
                        entry['text'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                          fontWeight: isActiveEntry ? FontWeight.w500 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





