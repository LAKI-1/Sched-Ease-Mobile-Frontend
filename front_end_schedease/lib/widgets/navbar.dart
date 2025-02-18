import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget{ //Stateful widget allows to track which item is currently selected
  final int initiallySelectedIndex; //The index selected when the widget
  final Function(int) onItemSelected; //A function that gets called when a new item is selected

  //Constructor that needs a callback function and initial index default to 0
  BottomNavBar({
    this.initiallySelectedIndex = 0,
    required this.onItemSelected,
  });
  @override
  _BottomNavBarState createState() => _BottomNavBarState();

}

//The state class for the BottomNavBar
class _BottomNavBarState extends State<BottomNavBar>{
  late int selectedIndex; // Stores the currently selected index

  @override
  void initState(){
    super.initState();
    //Initialise the index selected with the value provided in the widget constructor
    selectedIndex = widget.initiallySelectedIndex;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      //Outer container: Holds entire nav bar
      decoration: BoxDecoration(
        color: Colors.white,    //Bg color of the navbar
        borderRadius: BorderRadius.circular(40), //Rounded corners
        boxShadow:[
          //Adding a shadow
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 2), // Coordinates of where the shadow appear (below navbar)
          )
        ]
      ),

      //Margins that create space between navbar and the schedule cards
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, //Distributing the space around the row evenly
        children:[
          //Home item
          _buildNavItem(
            iconPath: 'assets/home.png', //Home icon being outlined
            label: 'Home', //Text
            index: 0, //Indexed position
          ),

          //Plan item
          _buildNavItem(
            iconPath: 'assets/schedule.png', //Home icon being outlined
            label: 'Plan', //Text
            index: 1, //Indexed position
          ),

          //Chat item
          _buildNavItem(
            iconPath: 'assets/chat.png', //Home icon being outlined
            label:'Chat' , //Text
            index: 2, //Indexed position
          ),

          //Feedback item
          _buildNavItem(
            iconPath: 'assets/feedback.png', //Home icon being outlined
            label: 'Help', //Text
            index: 3, //Indexed position
          ),
        ]
      ),
    );
  }

  //Method to build individual navigation items
  Widget _buildNavItem({
    required String iconPath, //Path of the icon image
    required String label,    //Text below the icon
    required int index,       //Position of the icon


  }) {
    //Check if this item is the currently selected one
    bool isSelected = selectedIndex == index;

    //Making the icons tappable
    return GestureDetector(
      onTap: (){      //Has what happens when you tap the icon
        setState(() { //Updates to the newly selected index
          selectedIndex = index;
        });


        widget.onItemSelected(index);
      },
      child: Container( //Container for customising each item
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),

        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFEBEEFF) : Colors.transparent, //Bg color of selected icon
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min, //Column height
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 24,
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600, //deciding the icon color based on selection stae
            ),

            SizedBox(height:2), //Space between the icon and text

            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
                fontSize : 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      )
    );
  }
}
