import 'package:flutter/material.dart';
import 'package:front_end_schedease/service/event_service.dart';

class StatsPage extends StatefulWidget {
  StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  // Dependencies
  final EventService _eventService = EventService.instance;

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Data maps to track progress and counts
  Map<String, double> progressData = {
    'Feedback Sessions': 0.0,
    'Supervisor Sessions': 0.0,
    'Lectures': 0.0,
    'Coursework Progress': 0.0,
  };

  // Target progress values (what we animate to)
  Map<String, double> targetProgressData = {
    'Feedback Sessions': 0.0,
    'Supervisor Sessions': 0.0,
    'Lectures': 0.0,
    'Coursework Progress': 0.0,
  };

  // Formatted count strings
  Map<String, String> countData = {
    'Feedback Sessions': '0/0',
    'Supervisor Sessions': '0/0',
    'Lectures': '0/0',
    'Coursework Progress': '0%',
  };

  // Sample feedback session data (replace with real data from your service)
  final List<Map<String, dynamic>> feedbackSessions = [
    {
      'mentor': 'Mr. Albert Anderson',
      'date': '2024-01-15',
      'time': '14:00 - 15:00',
      'mode': 'Physical',
      'location': '4LC, IIT Spencer'
    },
    {
      'mentor': 'Dr. Leo Johns',
      'date': '2024-02-02',
      'time': '10:30 - 11:30',
      'mode': 'Online',
      'location': 'Zoom Meeting'
    },
    {
      'mentor': 'Dr. Adriene Fernandez',
      'date': '2024-02-20',
      'time': '13:15 - 14:15',
      'mode': 'Physical',
      'location': '5LD, IIT Spencer'
    },
    {
      'mentor': 'Prof. Michael Chen',
      'date': '2024-03-05',
      'time': '11:00 - 12:00',
      'mode': 'Online',
      'location': 'Microsoft Teams'
    },
    {
      'mentor': 'Mr. Albert Anderson',
      'date': '2024-03-15',
      'time': '14:00 - 15:00',
      'mode': 'Physical',
      'location': '4LC, IIT Spencer'
    },
    {
      'mentor': 'Dr. Adriene Fernandez',
      'date': '2024-03-20',
      'time': '13:15 - 14:15',
      'mode': 'Physical',
      'location': '5LD, IIT Spencer'
    },
    {
      'mentor': 'Prof. Michael Chen',
      'date': '2024-04-05',
      'time': '11:00 - 12:00',
      'mode': 'Online',
      'location': 'Microsoft Teams'
    },
    {
      'mentor': 'Dr. Adriene Fernandez',
      'date': '2024-04-20',
      'time': '13:15 - 14:15',
      'mode': 'Physical',
      'location': '5LD, IIT Spencer'
    },
    {
      'mentor': 'Dr. Sarah Johnson',
      'date': '2024-04-31',
      'time': '13:45 - 14:45',
      'mode': 'Online',
      'location': 'Microsoft Teams'
    },
  ];

  // Sample coursework data (to be replaced)
  final Map<String, dynamic> courseworkData = {
    'CW1': {
      'title': 'SDGP CW I',
      'deadline': '2024-02-20',
      'maxMarks': 50,
      'obtained': 42,
      'feedback': 'Excellent analysis of idea and implementation plan seems t be feasible'
    },
    'CW2': {
      'title': 'SDGP CW II',
      'deadline': '2024-05-15',
      'maxMarks': 50,
      'obtained': 33,
      'feedback': 'Good analysis of the problem statement and great implementation!'
    },
    'totalProgress': 100, // Overall progress percentage including non-graded components
  };

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    // Load initial stats (set target values)
    _loadStats();

    // Start animation after a small delay to make it visible to user
    Future.delayed(Duration(milliseconds: 300), () {
      _animationController.forward();
    });

    // Update progress values on animation
    _animation.addListener(() {
      setState(() {
        // Update progress data based on animation value
        for (var key in targetProgressData.keys) {
          progressData[key] = targetProgressData[key]! * _animation.value;
        }
      });
    });

    // Listen for changes in events that might affect stats
    _eventService.eventsNotifier.addListener(_loadStats);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _eventService.eventsNotifier.removeListener(_loadStats);
    super.dispose();
  }

  // Load statistics from the event service
  void _loadStats() {
    //Sample data for stats
    setState(() {
      // Set target progress data (values we'll animate to)
      targetProgressData = {
        'Feedback Sessions': 22 / 24,
        'Supervisor Sessions': 6 / 10,
        'Lectures': 4 / 24,
        'Coursework Progress': courseworkData['totalProgress'] / 100,
      };

      // Update count strings immediately (these don't animate)
      countData = {
        'Feedback Sessions': '9/10',
        'Supervisor Sessions': '6/10',
        'Lectures': '4/12',
        'Coursework Progress': '${courseworkData['totalProgress']}%',
      };

      // If animation is already running, restart it
      if (_animationController.isAnimating || _animationController.status == AnimationStatus.completed) {
        // Reset progress data to zero
        for (var key in progressData.keys) {
          progressData[key] = 0.0;
        }
        // Restart animation
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Your Progress',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C5A7D),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Track your academic activities',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 24),

              // Progress bars
              Expanded(
                child: ListView(
                  children: [
                    _buildProgressSection(
                      context: context,
                      title: 'Attendance',
                      items: [
                        'Feedback Sessions',
                        'Supervisor Sessions',
                        'Lectures',
                      ],
                    ),
                    SizedBox(height: 24),
                    _buildProgressSection(
                      context: context,
                      title: 'Academic Progress',
                      items: [
                        'Coursework Progress',
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection({
    required BuildContext context,
    required String title,
    required List<String> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0.5,
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C5A7D),
            ),
          ),
          SizedBox(height: 16),
          ...items.map((item) => _buildProgressBar(context, item)).toList(),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, String title) {
    final progress = progressData[title] ?? 0.0;
    final targetProgress = targetProgressData[title] ?? 0.0;
    final count = countData[title] ?? '';

    // Calculate available width based on the actual context
    final availableWidth = MediaQuery.of(context).size.width - 40 - 40;

    // Determine color based on target progress (for a consistent color during animation)
    Color progressColor;
    if (targetProgress < 0.4) {
      progressColor = Colors.redAccent.shade100;
    } else if (targetProgress < 0.7) {
      progressColor = Colors.orangeAccent.shade100;
    } else {
      progressColor = Color(0xFFC5DCC2);
    }

    return InkWell(
      onTap: () {
        // Show different dialogs based on which item was tapped
        if (title == 'Feedback Sessions') {
          _showFeedbackSessionsDialog(context);
        } else if (title == 'Coursework Progress') {
          _showCourseworkDetailsDialog(context);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C5A7D),
                      ),
                    ),
                    // Add info icon for tappable items
                    if (title == 'Feedback Sessions' || title == 'Coursework Progress')
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Color(0xFF3C5A7D),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Stack(
              children: [
                // Background bar
                Container(
                  width: availableWidth,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // Animated progress bar
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      height: 12,
                      width: progress * availableWidth,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: progressColor.withOpacity(0.4),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show feedback sessions details dialog
  void _showFeedbackSessionsDialog(BuildContext context) {
    final dialogWidth = MediaQuery.of(context).size.width * 0.85;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        child: Container(
          width: dialogWidth,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(28), // Match the Dialog's corner radius
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feedback Sessions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C5A7D),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Record of Feedback Sessions attended',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),

              // List of feedback sessions is potentially long, so wrap in a scrollable container
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: feedbackSessions.map((session) {
                      // Color indicator based on session mode
                      Color indicatorColor = session['mode'] == 'Physical'
                          ? Color(0xFFC5DCC2) // Green for physical
                          : Color(0xFF3C5A7D); // Blue for online

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Mode indicator
                            Container(
                              width: 8,
                              height: 60,
                              decoration: BoxDecoration(
                                color: indicatorColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(width: 12),

                            // Session details - using Expanded to prevent overflow
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session['mentor'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF3C5A7D),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          session['date'] + ' • ' + session['time'],
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        session['mode'] == 'Physical'
                                            ? Icons.location_on
                                            : Icons.videocam,
                                        size: 12,
                                        color: Colors.grey[600],
                                      ),
                                      SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          '${session['mode']} • ${session['location']}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xFF3C5A7D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show coursework details dialog
  void _showCourseworkDetailsDialog(BuildContext context) {
    // Calculate CW1 percentage
    final cw1Percent = (courseworkData['CW1']['obtained'] / courseworkData['CW1']['maxMarks'] * 100).toInt();

    // Calculate CW2 percentage
    final cw2Percent = (courseworkData['CW2']['obtained'] / courseworkData['CW2']['maxMarks'] * 100).toInt();

    // Calculate overall percentage (just the average of CW1 and CW2 for simplicity)
    final overallPercent = courseworkData['totalProgress'];

    // Control dialog width
    final dialogWidth = MediaQuery.of(context).size.width * 0.85;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21),
        ),
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21), // Match the Dialog's border radius
            child: Container(
              width: dialogWidth,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coursework Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C5A7D),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Detailed marks breakdown',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),

                // CW1 Card
                _buildCourseworkCard(
                  title: 'Coursework 1',
                  subtitle: courseworkData['CW1']['title'],
                  deadline: courseworkData['CW1']['deadline'],
                  marks: '${courseworkData['CW1']['obtained']}/${courseworkData['CW1']['maxMarks']}',
                  percentage: cw1Percent,
                  feedback: courseworkData['CW1']['feedback'],
                ),

                SizedBox(height: 16),

                // CW2 Card
                _buildCourseworkCard(
                  title: 'Coursework 2',
                  subtitle: courseworkData['CW2']['title'],
                  deadline: courseworkData['CW2']['deadline'],
                  marks: '${courseworkData['CW2']['obtained']}/${courseworkData['CW2']['maxMarks']}',
                  percentage: cw2Percent,
                  feedback: courseworkData['CW2']['feedback'],
                ),

                SizedBox(height: 20),

                // Overall progress bar with animation (using LayoutBuilder to get constraints)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final availableWidth = constraints.maxWidth;
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Progress',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF3C5A7D),
                            ),
                          ),
                          SizedBox(height: 8),
                          Stack(
                            children: [
                              // Background bar
                              Container(
                                width: double.infinity,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // Progress bar with animation
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: overallPercent / 100),
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.easeOutCubic,
                                builder: (context, value, child) {
                                  return Container(
                                    height: 12,
                                    width: value * (availableWidth - 32),
                                    decoration: BoxDecoration(
                                      color: _getColorForPercentage(overallPercent),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Includes both courseworks and components',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '$overallPercent%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF3C5A7D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Color(0xFF3C5A7D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  // Helper to build coursework card
  Widget _buildCourseworkCard({
    required String title,
    required String subtitle,
    required String deadline,
    required String marks,
    required int percentage,
    required String feedback,
  }) {
    Color progressColor = _getColorForPercentage(percentage);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF3C5A7D),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: progressColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Deadline: $deadline',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                'Marks: $marks',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C5A7D),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Feedback:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            feedback,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  // Helper to get color based on percentage
  Color _getColorForPercentage(int percentage) {
    if (percentage < 40) {
      return Colors.redAccent.shade100;
    } else if (percentage < 70) {
      return Colors.orangeAccent.shade100;
    } else {
      return Color(0xFFC5DCC2);
    }
  }
}