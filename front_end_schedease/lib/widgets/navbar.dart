import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int initiallySelectedIndex;
  final Function(int) onItemSelected;

  BottomNavBar({
    Key? key,
    this.initiallySelectedIndex = 0,
    required this.onItemSelected,
  }) : super (key:key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  late int selectedIndex;
  late AnimationController _animationController;

  // Dark blue color for selected items
  final Color colorAroundNavItem = Color(0xFF3C5A7D);

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initiallySelectedIndex;

    // Initialize animation controller for subtle hover effects
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(BottomNavBar oldWidget){
    super.didUpdateWidget(oldWidget);
    if (widget.initiallySelectedIndex != oldWidget.initiallySelectedIndex){
      setState(() {
        selectedIndex = widget.initiallySelectedIndex;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            index: 0,
          ),
          _buildNavItem(
            icon: Icons.calendar_month_rounded,
            label: 'Book',
            index: 1,
          ),
          _buildNavItem(
            icon: Icons.folder_copy_rounded,
            label: 'Log',
            index: 2,
          ),
          _buildNavItem(
            icon: Icons.chat_rounded,
            label: 'Chat',
            index: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    bool isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          _animationController.reset();
          _animationController.forward();
          widget.onItemSelected(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated container for the icon
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.all(isSelected ? 12 : 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? colorAroundNavItem : Colors.grey.withOpacity(0.1),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: colorAroundNavItem.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    )
                  ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  size: 22,
                ),
              ),

              SizedBox(height: 6),

              // Label with animation
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colorAroundNavItem : Colors.grey.shade600,
                ),
                child: Text(label),
              ),

              // Animated indicator dot
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 4,
                width: isSelected ? 20 : 0,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: isSelected ? colorAroundNavItem : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}