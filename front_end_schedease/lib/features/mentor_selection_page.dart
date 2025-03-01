import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:front_end_schedease/features/session_booking_form.dart';

class MentorSelectionPage extends StatefulWidget{
  final DateTime selectedDate; //The date selected previously passed to this screen

  //Constructor
  const MentorSelectionPage ({Key ? key, required this.selectedDate}) : super(key:key);

  @override
  //Creating state for the widget
  _MentorSelectionPageState createState() => _MentorSelectionPageState();
}

class _MentorSelectionPageState extends State<MentorSelectionPage> {
  late PageController _weekPageController; //Week view slider
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  int _currentWeekPage = 1000; //Starting page number for infinite scrolling
  int? _selectedMentorIndex; //Index of mentor selected

  //List of mentors
  final List<Map<String, dynamic>> mentors = [
    {
      'name' : 'Mr. Albert',
      'avatar' : 'assets/banu_avatar.jpg',
      'expertise' : 'Product Branding',
    },
    {
      'name' : 'Mr. Leo',
      'avatar' : 'assets/suresh_avatar.jpg',
      'expertise' : 'Back End Development'
    },
    {
      'name' : 'Ms. Anne',
      'avatar' : 'assets/anne_avatar.jpg',
      'expertise' : 'UI/UX Design'
    },
    {
      'name' : 'Ms. Priya',
      'avatar' : 'assets/priya_avatar.jpg',
      'expertise' : 'Project Management'
    },
  ];

  @override
  void initState(){
    //Called when widget is added to the tree
    super.initState();
    _selectedDate = widget.selectedDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    _weekPageController = PageController(initialPage: _currentWeekPage);
  }

  @override
  void dispose() {
    //Called when widget is removed from the tree
    _weekPageController.dispose();
    super.dispose();
  }

  DateTime _getFirstDayOfWeek(DateTime date) {
    //Helper Method: Gets first day as Monday
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List <DateTime> _getDaysInWeek(DateTime date){
    //Helper Method: Gets first five days in the week
    DateTime firstDayOfWeek = _getFirstDayOfWeek(date); //Gets Monday
    return List.generate(5, (index) => firstDayOfWeek.add(Duration(days: index))); //Creates 5 days in a week
  }

  void _handleMonthChange (bool next){
    //Method: Changes the < > buttons to change months
    setState(() {
      if (next){
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1); //Next month
      } else {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1); //Previous month
      }

      _selectedDate = _currentMonth; //Updating the date to new month

      DateTime firstDayOfMonth = _getFirstDayOfWeek(_currentMonth); //First weekday of month
      int pageDiff = next ? 4 : -4; //No. of weeks
      _currentWeekPage += pageDiff; //Updates index of current page
      _weekPageController.jumpToPage(_currentWeekPage); //Jumps to new page

    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar( //Top app bar
        backgroundColor: Color(0xFF3C5A7D), //Dark blue
        elevation: 0, //no shadow
        title: Text(
          'Select a Mentor',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton( //Go back button
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(), //Action
        ),
      ),

      body: SafeArea(
          child: Column(
            children: [
              _buildCalendarSection(), //Calendar on top
              Expanded(
                  child: _buildMentorList(), //List of mentors
              ),
              _buildNextButton(), //Confirm button
            ],
          ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    // Method: Calendar on top
    return Container(
      //Entire box layout
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      decoration: BoxDecoration(
        color: Color(0xFF3C5A7D), //Dark blue
        borderRadius: BorderRadius.all(Radius.circular(60)),
      ),
      child: Column(
        //Month Nav Layout
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton( //Previous month
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => _handleMonthChange(false), //Action
              ),

              Text(
                DateFormat('MMMM').format(_currentMonth),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),

              IconButton( //Next month
                icon: Icon(Icons.chevron_right, color: Colors.white),
                onPressed:() => _handleMonthChange(true),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox( //Week View
            height: 100,
            child: PageView.builder( //Slidable view for weeks
              controller: _weekPageController,
              onPageChanged: (page){
                setState(() {
                  int weekDiff = page - _currentWeekPage; //Calculate week difference
                  _currentWeekPage = page; //Update current page

                  //Update selected date based on week diff
                  DateTime newDate = _selectedDate.add(Duration(days: weekDiff * 7));
                  _selectedDate = newDate;

                  //Update month when needed
                  _currentMonth = DateTime(newDate.year, newDate.month);
                });
              },
              itemBuilder: (context, page){ //Build each page
                //Find start of week for page
                int weekDiff = page - _currentWeekPage;
                DateTime weekStart = _selectedDate.add(Duration(days: weekDiff * 7));

                List<DateTime> days = _getDaysInWeek(weekStart); //Gets a week of 5 days

                //Row of day items (Mon-Fri)
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map((date) => _buildDayItem(date)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem (DateTime date) {
    //Method: builds single day in calendar

    //Checking if this date is the selected Date
    bool isSelected = date.year == _selectedDate.year &&
      date.month == _selectedDate.month &&
      date.day == _selectedDate.day;

    //Checking if this day is in current month
    bool isCurrentMonth = date.month == _currentMonth.month;

    return GestureDetector( //Making it tappable
      onTap: (){
        setState(() {
          _selectedDate = date;
          _currentMonth = DateTime(date.year, date.month);
        });
      },
      child: Container( //Container for selected day
        width: 65,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            //Name of day
            Text(
              DateFormat('E').format(date).substring(0,3), //Formatted for a day with 3 letters
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : isCurrentMonth
                      ? Colors.white
                      : Colors.white.withOpacity(0.5), //Faded white when not in current month
                fontSize: 16,
              ),
            ),

            SizedBox(height: 8),

            //Number of the day
            Text(
              date.day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : isCurrentMonth
                      ? Colors.white
                      : Colors.white.withOpacity(0.5), //Faded white when not in current month
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorList() {
    //Method: Builds list of Mentors
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Displaying date with ordinal suffix
          Text(
            '${DateFormat('EEEE,d').format(_selectedDate)}${_getOrdinalSuffix(_selectedDate.day)}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          //Instruction
          Text(
            'Select a mentor for your session:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 10),

          //Scrollable list of mentors
          Expanded(
            child: ListView.builder(
              itemCount: mentors.length, //No. of mentors
              itemBuilder: (context, index){  //Each mentor items
                final mentor = mentors[index];
                return _buildMentorItem(mentor, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  //Method: Builds each mentor in the list seperately
  Widget _buildMentorItem (Map<String, dynamic> mentor, int index) {
    final isSelected = _selectedMentorIndex == index; //Checking if the mentor is selected

    return GestureDetector(
      onTap:() {
        setState(() {
          _selectedMentorIndex = index;
        });
      },

      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all( //Border style when selected
            color: isSelected ? Color(0xFF3C5A7D) : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 0,
              offset: Offset(0,5),
            ),
          ],
        ),

        child: Row(
          children: [

            CircleAvatar( //Avatar
              radius: 25,
              backgroundColor: Color(0xFFC5DCC2), //Mint green
              child: Text(
                mentor['name'].toString().substring(3,4),//Takes first letter of name
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(width: 15),

            Expanded( //Mentor info
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //Aligns to left
                children: [
                  Text(
                    mentor['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    mentor['expertise'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            //Selection indicator (radio button style)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFF3C5A7D) : Colors.grey.withOpacity(0.5), //Dark blue when selected
                  width: 2,
                ),
              ),
              child: isSelected
                    ? Center( //If selected shows inner circle
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF3C5A7D), //Dark blue
                        ),
                      ),
                    )
                    :null,
            ),
          ],
        ),
      ),
    );
  }
  
  //Next button that navigates to the booking form
  Widget _buildNextButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: ElevatedButton(
          onPressed: _selectedMentorIndex != null
              ? () {
                //Only when a mentor is selected
                _navigateToBookingForm();
                } 
              :null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3C5A7D), //Dark blue
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
          child: Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
    );
  }

  _navigateToBookingForm(){
    //Method: Navigates to booking form
    if (_selectedMentorIndex == null) return; //safety check

    final selectedMentor = mentors[_selectedMentorIndex!]; //Gets selected mentor data

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => SessionBookingForm(
            mentorName : selectedMentor['name'],
            mentorExpertise: selectedMentor['expertise'],
            selectedDate: _selectedDate,
          ),
      ),
    );
  }

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
}
