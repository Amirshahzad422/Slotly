import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/appointments_screen.dart';
import '../screens/services_screen.dart';
import '../screens/profile_screen.dart';
import '../components/bottom_nav.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const MainLayout({
    super.key,
    this.selectedIndex = 0,
    required this.child,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      body: Stack(
        children: [
          SafeArea(
            child: widget.child,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              selectedIndex: widget.selectedIndex,
              onItemTapped: (index) => _navigate(context, index),
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    if (index == widget.selectedIndex) return;
    Widget childScreen;
    switch (index) {
      case 0:
        childScreen = const HomeScreen();
        break;
      case 1:
        childScreen = const AppointmentsScreen();
        break;
      case 2:
        childScreen = const ServicesScreen();
        break;
      case 3:
        childScreen = const ProfileScreen();
        break;
      default:
        childScreen = const HomeScreen();
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MainLayout(
          selectedIndex: index,
          child: childScreen,
        ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
