import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_strategy/url_strategy.dart';

import 'styles/colors.dart';
import 'layouts/main_layout.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/service_details_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/confirm_screen.dart';
import 'screens/appointments_screen.dart';
import 'screens/provider_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/blog_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/selected_category_screen.dart';

void main() {
  setPathUrlStrategy();
  runApp(const ProviderScope(child: SlotlyApp()));
}

class NoScrollbarBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class SlotlyApp extends StatelessWidget {
  const SlotlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = ThemeData.light().textTheme;
    // Ultra-stylish, luxury Outfit font typography
    final outfitTextTheme = GoogleFonts.outfitTextTheme(baseTextTheme);

    return MaterialApp(
      title: 'Slotly — Premium Booking Platform',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoScrollbarBehavior(),
      theme: ThemeData(
        useMaterial3: true,
        textTheme: outfitTextTheme,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        final Map<String, WidgetBuilder> appRoutes = {
          '/splash': (context) => const SplashScreen(),
          '/': (context) => const MainLayout(selectedIndex: 0, child: HomeScreen()),
          '/appointments': (context) => const MainLayout(selectedIndex: 1, child: AppointmentsScreen()),
          '/services': (context) => const MainLayout(selectedIndex: 2, child: ServicesScreen()),
          '/profile': (context) => const MainLayout(selectedIndex: 3, child: ProfileScreen()),
          '/service-details': (context) => const MainLayout(showBottomNav: false, child: ServiceDetailsScreen()),
          '/booking': (context) => const MainLayout(showBottomNav: false, child: BookingScreen()),
          '/confirm': (context) => const MainLayout(showBottomNav: false, child: ConfirmScreen()),
          '/provider': (context) => const MainLayout(showBottomNav: false, child: ProviderScreen()),
          '/category-services': (context) => const SelectedCategoryScreen(),
          '/about': (context) => const MainLayout(showBottomNav: false, child: AboutScreen()),
          '/contact': (context) => const MainLayout(showBottomNav: false, child: ContactScreen()),
          '/faq': (context) => const MainLayout(showBottomNav: false, child: FaqScreen()),
          '/blog': (context) => const MainLayout(showBottomNav: false, child: BlogScreen()),
        };

        final builder = appRoutes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder, settings: settings);
        }

        // Unknown route (e.g. /hdd, /404, or invalid URLs) -> NotFoundScreen
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
          settings: settings,
        );
      },
    );
  }
}
