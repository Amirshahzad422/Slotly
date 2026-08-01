import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../styles/colors.dart';
import '../components/bottom_nav.dart';
import '../components/header.dart';
import '../screens/home_screen.dart';
import '../screens/appointments_screen.dart';
import '../screens/services_screen.dart';
import '../screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;
  final bool showBottomNav;

  const MainLayout({
    super.key,
    this.selectedIndex = 0,
    required this.child,
    this.showBottomNav = true,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isNavVisible = true;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Single standalone top header for Desktop Web View
          if (isDesktop) const CustomHeader(isStandaloneDesktopHeader: true),

          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1100 : double.infinity,
                ),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is UserScrollNotification) {
                      if (notification.direction == ScrollDirection.reverse) {
                        if (_isNavVisible) {
                          setState(() => _isNavVisible = false);
                        }
                      } else if (notification.direction == ScrollDirection.forward) {
                        if (!_isNavVisible) {
                          setState(() => _isNavVisible = true);
                        }
                      }
                    }
                    return false;
                  },
                  child: Stack(
                    children: [
                      SafeArea(
                        top: !isDesktop,
                        bottom: false,
                        child: widget.child,
                      ),
                      if (!isDesktop && widget.showBottomNav)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 320),
                          curve: Curves.easeInOutCubic,
                          left: 0,
                          right: 0,
                          bottom: _isNavVisible ? 16.0 : -90.0,
                          child: CustomBottomNavBar(
                            selectedIndex: widget.selectedIndex,
                            onItemTapped: (index) => _navigate(context, index),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
