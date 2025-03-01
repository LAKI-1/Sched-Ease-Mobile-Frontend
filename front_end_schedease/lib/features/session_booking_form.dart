import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SessionBookingForm extends StatefulWidget{
  final String mentorName;
  final String mentorExpertise;
  final DateTime selectedDate;

  //Constructor
  const SessionBookingForm({
    Key? key,
    required this.mentorName,
    required this.mentorExpertise,
    required this.selectedDate,
  }) : super (key: key);

  @override
  _SessionBookingFormState createState() => _SessionBookingFormState();
}

class _SessionBookingFormState extends State<SessionBookingForm> {
  //Key to identify and validate the form
  final _formKey = GlobalKey<FormState>();

  //Variable : Tracks which time slot is selected
  String? _selectedTimeSlot;

  // Controllers for the text input fields


  final TextEditingController _focusController = TextEditingController(); //Session focus
  final TextEditingController _notesController = TextEditingController(); //Additional notes
  final TextEditingController _groupNumberController = TextEditingController(); //For group number

  //List of available time slots
  final List<String> _timeSlots = [
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
  ];

  @override
  void dispose() {
    //Clean up text controllers when widget is removed from widget tree
    _focusController.dispose();
    _notesController.dispose();
    _groupNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF3C5A7D), //Dark Blue
        elevation: 0,
        title: Text(
          'Book Session',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton( //Back button
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), //Action
        ),
      ),

      body: SafeArea(
        child: Form( //Form widget for validation
          key: _formKey, //Assigning key for validation
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //Align children to left
                children: [
                  _buildSessionHeader(), //Mentor info and date header
                  SizedBox(height: 25),
                  _buildTimeSlotSection(), //Time slot section
                  SizedBox(height: 25),
                  _buildGroupNumberSection(), //Group number
                  SizedBox(height: 25),
                  _buildFocusSection(), //Session focus
                  SizedBox(height: 25),
                  _buildNotesSection(), //Additional notes
                  SizedBox(height: 30),
                  _buildConfirmButton(), //Book Session button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionHeader() {
    //Builds the header with mentor avatar and name
    String dayWithSuffix = '${widget.selectedDate.day}${_getOrdinalSuffix(
        widget.selectedDate.day)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Row displaying mentor avatar and name
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //Push items to edges
          children: [
            CircleAvatar( //Avatar
              radius: 30,
              backgroundColor: Color(0xFFC5DCC2), //Mint green
              child: Text(
                widget.mentorName.substring(0, 1), //Takes first letter of name
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end, //Align text to right
              children: [
                Text(
                  widget.mentorName, //Mentor name from passed property
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  widget.mentorExpertise,
                  //Mentor Expertise from passed property
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600], //Grey text
                  ),
                ),
              ],
            )
          ],
        ),
        SizedBox(height: 25),

        Text(
          '${DateFormat('EEEE').format(widget.selectedDate)},$dayWithSuffix',
          //Formatting the day
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Slot',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        Wrap( //Flowing grid for timeslots
          spacing: 10, //Horizontal spacing
          runSpacing: 10, //Vertical spacing
          children: _timeSlots.map((timeSlot) {
            bool isSelected = _selectedTimeSlot == timeSlot;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTimeSlot =
                      timeSlot; //Set this as the selected time slot
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF3C5A7D) : Colors.white,
                  //Blue when selected, else white
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Color(0xFF3C5A7D) : Colors.grey
                        .withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  timeSlot,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight
                        .normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGroupNumberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Number', //Title
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        TextFormField( //TextField for entering group number
          controller: _groupNumberController,
          //Assigning controller to save/retrieve text
          keyboardType: TextInputType.text,
          //Show regular keyboard
          decoration: InputDecoration(
            hintText: 'Enter your group number (eg: CS-66)', //Placeholder
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.3)), //Border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Color(0xFF3C5A7D)), //Blue border when being filled
            ),
            contentPadding: EdgeInsets.all(15), //Padding inside text field
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your group number'; //Error message
            }
            return null; //No error
          },
        ),
      ],
    );
  }

  Widget _buildFocusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Focus', //Section title
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        TextFormField( //TextField for entering session focus
          controller: _focusController,
          //Assigning controller to save/retrieve text
          decoration: InputDecoration(
            hintText: 'What would you like to focus on? (eg: Code Review)',
            //Placeholder
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.3)), //Border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Color(0xFF3C5A7D)), //Blue border when being filled
            ),
            contentPadding: EdgeInsets.all(15), //Padding inside text field
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a session focus'; //Error message
            }
            return null; //No error
          },
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes (Optional)', //Section title
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),

        TextFormField( //Multi Line TextField for entering additional notes
          controller: _notesController,
          //Assigning controller to save/retrieve text
          maxLines: 4,
          //Allows multiple lines of text
          decoration: InputDecoration(
            hintText: 'Add any specific topics or problems to be discussed.',
            //Placeholder
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Colors.grey.withOpacity(0.3)), //Border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                  color: Color(0xFF3C5A7D)), //Blue border when being filled
            ),
            contentPadding: EdgeInsets.all(15), //Padding inside text field
          ),
          //No validator since optional
        ),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity, //full width button
      child: ElevatedButton(
        onPressed: _validateAndConfirm,
        //Method called for Validation when pressed
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3C5A7D),
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          'Book Session',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _validateAndConfirm() {
    //Validating form before submission
    //Checks if form is valid
    if (!_formKey.currentState!.validate()) {
      return; //Stopping if validation fails
    }

    //Checks if time slot is selected
    if (_selectedTimeSlot == null) {
      _showErrorDialog('Please select a time slot');
      return;
    }

    //If everything is valid, success dialog shown
    _showSuccessDialog();
  }

  void _showErrorDialog(String message) {
    //Method to show error message for empty fields
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Missing Information'), //Dialog title
            content: Text(message), //Error message
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                //Close dialog when pressed
                child: Text('OK'),
              ),
            ],

          ),
    );
  }
    void _showSuccessDialog() {
      showDialog(
        context: context,
        builder: (context) =>
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, //Wraps content tightly
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Color(0xFFE8F5E9),
                        size: 50,
                      ),
                    ),
                    SizedBox(height: 20),

                    //Divider line
                    Divider(thickness: 1),
                    SizedBox(height: 15),

                    //Date info
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFF3C5A7D),
                            size: 20), //Calendar icon
                        SizedBox(width: 10),
                        Text(
                          DateFormat('EEEE, MMMM d').format(
                              widget.selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    //Time infp
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Color(0xFF3C5A7D),
                            size: 20), //Clock icon
                        SizedBox(width: 10),
                        Text(
                          _selectedTimeSlot!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    //Mentor info
                    Row(
                      children: [
                        Icon(Icons.person, color: Color(0xFF3C5A7D), size: 20),
                        //Person icon
                        SizedBox(width: 10),
                        Text(
                          widget.mentorName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    //Done button
                    ElevatedButton(
                      onPressed: () {
                        //Close dialogue and return to page
                        Navigator.of(context).pop(); //Close dialog
                        Navigator.of(context).pop(); //Close booking form
                        Navigator.of(context).pop(
                            true); //Return schedule with success flag
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3C5A7D),
                        minimumSize: Size(double.infinity, 45),
                        //full width and fixed height
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),

                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    }

    String _getOrdinalSuffix(int day) {
      //Helper Method: Get ordinal suffix for day
      if (day >= 11 && day <= 13) {
        return 'th'; // Special case for 11th, 12th, 13th
      }
      switch (day % 10) { // Check last digit
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





