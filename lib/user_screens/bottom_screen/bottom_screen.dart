import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:internship_task/resources/appcolors/app_colors.dart';
import 'package:internship_task/user_screens/profile_screen/profile_screen.dart';
import 'package:internship_task/user_screens/user_home_screen/user_home_screen.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({Key? key}) : super(key: key);

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    UserHomeScreen(),
    ProfileScreen(),
  ];

  final List<TabItem> _navBarsItems = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: Icons.person,
      title: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, bottom: 5.0, top: 0.0),
        child: BottomBarFloating(
          animated: true,
          borderRadius: BorderRadius.circular(30.0),
          items: _navBarsItems,
          backgroundColor: AppColors.primaryColor,
          color: Colors.white,
          colorSelected: Colors.amber,
          indexSelected: _currentIndex,
          onTap: (int index) => setState(() {
            _currentIndex = index;
          }),
        ),
      ),
    );
  }
}
