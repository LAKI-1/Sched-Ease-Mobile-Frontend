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

  //List of feedback items
  final List<Map<String,dynamic>> feedbackItems = [
    {
      'time': '21 March, 2025',
      'title': 'Brainstorming about ideas',
      'mentor':'Mr.Albert',
      'isRead': false,
      'month':'March',
      'year':'2025',
    },
    {
      'time': '13 April, 2025',
      'title': 'Clear idea on project management',
      'mentor':'Ms.Anne',
      'isRead': false,
      'month':'April',
      'year':'2025',
    },
    {
      'time': '30 May, 2025',
      'title': 'Implementation discussion',
      'mentor':'Mr.Leo',
      'isRead': false,
      'month':'March',
      'year':'2025',
    },
    {
      'time': '13 June, 2025',
      'title': 'Assisted for the debugging of code',
      'mentor':'Mr.Albert',
      'isRead': false,
      'month':'June',
      'year':'2025',
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
    },
    {
      'time': '22 March, 2025',
      'title': 'Team Meeting Recording',
      'student':'Sienna Riverly',
      'month':'March',
      'year':'2025',
    },
    {
      'time': '13 April, 2025',
      'title': 'Feedback Session with Ms.Anne Recording',
      'student':'Brendon Feenix',
      'month':'April',
      'year':'2025',
    },
    {
      'time': '30 May, 2025',
      'title': 'Feedback Session with Mr.Leo Recording',
      'student':'Bella Anderson',
      'month':'March',
      'year':'2025',
    },
    {
      'time': '13 June, 2025',
      'title': 'Feedback Session with Ms.Priya Recording',
      'student':'Micheala Judith',
      'month':'June',
      'year':'2025',
    },
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
                return _buildFeedbackItem(item, index);
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
                return _buildLogBookItem(item, index + 100);
              },
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildFeedbackItem(Map<String, dynamic> item, int index) {
    //Checks if item is selected
    bool isSelected = _selectedItemIndex == index;

    return GestureDetector(
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
        margin: EdgeInsets.only(bottom:15),
        padding: EdgeInsets.all(15),
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
                    });
                    //Detailed view can be added here
                  },
                  child: Text(
                    'View More',
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
    );
  }

  Widget _buildLogBookItem(Map<String, dynamic> item, int index) {
    //Checks if item is selected
    bool isSelected = _selectedItemIndex == index;

    return GestureDetector(
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
        margin: EdgeInsets.only(bottom:15),
        padding: EdgeInsets.all(15),
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
              ],
            ),
            SizedBox(height: 12),

            //View More button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    //Detailed view can be added here
                  },
                  child: Text(
                    'View More',
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
    );
  }
}













