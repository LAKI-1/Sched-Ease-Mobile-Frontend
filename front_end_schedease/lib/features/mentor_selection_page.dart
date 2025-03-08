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

  late DateTime _selectedDate;
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
              Expanded(
                  child: _buildMentorList(), //List of mentors
              ),
              _buildNextButton(), //Confirm button
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
              color: Colors.white,
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
    ).then((result){
      if(result != null){
        Navigator.of(context).pop(result);
      }
    });
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

