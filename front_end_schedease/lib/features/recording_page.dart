import 'package:flutter/material.dart';
import 'dart:async'; // For the Timer class

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool _isRecording = false;
  int _recordingDuration = 0;
  Timer? _timer;

  // Text controllers for save dialog - Holds user input when dialogue appears
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel(); //Cancels active timers
    _titleController.dispose(); //Cleans up the controller inputs
    _studentNameController.dispose(); //Cleans up the controller inputs
    super.dispose();
  }

  // Showing permission dialog before starting recording
  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, //Cannot tap outside 'Yes' and 'No'
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('Have you requested permission from your audience before recording?'),
        backgroundColor: Colors.white,
        actions: [
          // No button: returns False
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
                'No',
                style: TextStyle(
                    color: Color(0xFF3C5A7D),
                ),
            ),
          ),
          // Yes button: returns True
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes',
                style: TextStyle(
                  color: Color(0xFF3C5A7D),
                ),
            ),
          ),
        ],
      ),
    ).then((hasPermission) {
      if (hasPermission == true) { //If user is granted permission then recording started
        _permissionGiven = true; //Updates the flag
        setState(() {
          _isRecording = true;
          _startRecordingTimer();
        });
      }
    });
  }

  bool _permissionGiven = false; //Flag: Tracks if permission was given by user
  bool _recordingPaused = false; //Flag: tracks if recording was paused

  void _toggleRecording() {

    if (!_isRecording) { //If it isn't recording, permission dialogue is displayed first
      if(!_permissionGiven) {
        _showPermissionDialog();
      } else {
      //Permission granted, start recording directly
      setState(() {
        _isRecording = true;
        _startRecordingTimer();
      });
    }
  } else{
      //If recording, stop the recording
      setState(() {
        _isRecording = false ;
        _recordingPaused = true;
        _timer?.cancel();
      });
    }
  }

  void _startRecordingTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final int mins = (seconds / 60).floor();
    final int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showSaveDialog() { //Dialogue displayed when user saves recording, saving meta data
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Save Recording'),
        backgroundColor: Colors.white,
        content: SingleChildScrollView( //Scrollable when needed
          child: Column(
            mainAxisSize: MainAxisSize.min, //Taking min required space
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Recording Title',
                  hintText: 'Enter a title for this recording',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _studentNameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  hintText: 'Enter your name',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
              style: TextStyle(
                color: Color(0xFF3C5A7D),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isNotEmpty && _studentNameController.text.isNotEmpty) {
                Navigator.pop(context, true); //Returns true, when fields are filled (save recording)
              } else {
                // Show error message if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Color(0xFFC5DCC2), //Mint green
                  ),
                );
              }
            },
            child: Text('Save',
              style: TextStyle(
                color: Color(0xFF3C5A7D),
              ),
            ),
          ),
        ],
      ),
    ).then((shouldSave) {
      if (shouldSave == true) { //Saves recording only when 'Save' is clicked
        _saveRecording();
      }
    });
  }

  void _saveRecording() {
    // Get current date
    final now = DateTime.now();
    final month = _getMonthName(now.month);
    final day = now.day;
    final year = now.year;
    final formattedDate = '$day $month, $year';

    // Create new recording entry
    final newRecording = {
      'time': formattedDate,
      'title': _titleController.text,
      'student': _studentNameController.text,
      'month': month,
      'year': year.toString(),
      'recordingLength': _formatDuration(_recordingDuration),
      'transcript': [], // Empty transcript for now
    };

    // Returns to previous screen with the new recording data
    Navigator.pop(context, newRecording);
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
  
  bool _isPaused = false; //Tracks if recording is paused
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Recording'),
        backgroundColor: Color(0xFF3C5A7D),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            // When close button is clicked while recording, a confirmation dialogue is shown
            if (_isRecording) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Discard Recording?'),
                  content: Text('Your recording will be lost if you go back now.'),
                  backgroundColor: Colors.white,
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style: TextStyle(color: Color(0xFF3C5A7D))),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to previous page
                      },
                      child: Text('Discard',
                          style: TextStyle(color: Color(0xFF3C5A7D))),
                    ),
                  ],
                ),
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Recording status icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _isRecording
                    ? Color(0xFFC5DCC2).withOpacity(0.2)
                    : Color(0xFF3C5A7D).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  size: 50,
                  color: _isRecording
                      ? Color(0xFFC5DCC2)
                      : Color(0xFF3C5A7D),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Recording time
            Text(
              _formatDuration(_recordingDuration),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w300,
                color: Color(0xFF3C5A7D),
              ),
            ),
            SizedBox(height: 40),

            // Recording status text
            Text(
              _isRecording
                  ? 'Recording in progress...'
                  : (_isPaused
                    ? 'Recording paused'
                    : (_recordingFinished
                      ? 'Recording complete'
                      : 'Ready to record')),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 60),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isRecording && !_isPaused)
                  //If not recording and not paused, then start the recording
                  _buildCircleButton(
                    onTap: _startRecordingWithPermission,
                    icon: Icons.mic,
                    color: Color(0xFF3C5A7D),
                  ),

                if(_isRecording)
                  //If recording, show pause and stop buttons
                  Row(
                    children: [
                      //Pause button
                      _buildCircleButton(
                        onTap: _pauseRecording,
                        icon: Icons.pause,
                        color: Color(0xFF3C5A7D),
                      ),
                      SizedBox(width: 20),
                      //Stop button
                      _buildCircleButton(
                        onTap: _stopRecording,
                        icon: Icons.stop,
                        color: Color(0xFF3C5A7D),
                      ),
                    ],
                  ),

                if (! _isRecording && _isPaused)
                  //If not recording, and paused , show resume and stop buttons
                  Row(
                    children: [
                      _buildCircleButton(
                        onTap: _resumeRecording,
                        icon: Icons.play_arrow,
                        color: Color(0xFF3C5A7D),
                      ),
                      SizedBox(width: 20),
                      _buildCircleButton(
                        onTap: _stopRecording,
                        icon: Icons.stop,
                        color: Color(0xFF3C5A7D),
                      ),


                    ],
                  )

              ],
            )

          ],
        ),
      ),
      bottomNavigationBar: null
          );
  }

  // Helper method to create consistent circle buttons
  Widget _buildCircleButton({
    required VoidCallback onTap,
    required IconData icon,
    required Color color,
    double size = 70,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

// Split the recording control methods
  void _startRecordingWithPermission() {
    if (!_permissionGiven) {
      _showPermissionDialog();
    } else {
      _resumeRecording();
    }
  }

  void _pauseRecording() {
    setState(() {
      _isRecording = false;
      _isPaused = true;
      _timer?.cancel();
    });
  }

  void _resumeRecording() {
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _startRecordingTimer();
    });
  }
  bool _recordingFinished = false;
  void _stopRecording() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Stop Recording'),
        content: Text('Are you sure you want to stop recording?'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF3C5A7D)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Stop',
              style: TextStyle(color: Color(0xFF3C5A7D)),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        // If user confirms, actually stop the recording
        setState(() {
          _isRecording = false;
          _isPaused = false;
          _recordingFinished = true; // New flag to track that recording is finished
          _timer?.cancel();
        });

        // Automatically show the save dialog after stopping
        _showSaveDialog();
      }
    });

  }


}

