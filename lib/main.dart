import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/home_screen.dart';
import '../screens/appointments_screen.dart';
import '../screens/services_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/selected_category_screen.dart';
import '../layouts/main_layout.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(const ProviderScope(child: SlotlyApp()));
}

class SlotlyApp extends StatelessWidget {
  const SlotlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slotly',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(selectedIndex: 0, child: HomeScreen()),
        '/appointments': (context) => const MainLayout(selectedIndex: 1, child: AppointmentsScreen()),
        '/services': (context) => const MainLayout(selectedIndex: 2, child: ServicesScreen()),
        '/profile': (context) => const MainLayout(selectedIndex: 3, child: ProfileScreen()),
        '/category-services': (context) => const SelectedCategoryScreen(),
      },
    );
  }
}
