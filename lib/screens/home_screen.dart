import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/header.dart';
import '../styles/colors.dart';
import '../components/search_bar.dart';
import '../components/filters.dart';
import '../components/category_chip.dart';
import '../components/banner.dart';
import '../components/service_card.dart';
import '../components/testimonials.dart';
import '../providers/search_provider.dart';
import '../providers/booking_provider.dart';
import '../data/mock_data.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isFilterActive = ref.watch(isFilterActiveProvider);

    const categories = ['All', 'Salon', 'Gym', 'Clinic', 'Spa', 'Barber'];
    final featuredServices = mockServices.take(4).toList();

    return Column(
      children: [
        // Pinned Static Header Row
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomHeader(
            showProfilePill: true,
            userName: 'Anna Grace',
          ),
        ),

        // Scrollable Body Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0, bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Heading with Plus Jakarta Sans Font
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Book Appointments,\n',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                      TextSpan(
                        text: 'Top Rated Venues',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textPrimary,
                          height: 1.15,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Search Bar
                CustomSearchBar(
                  initialValue: searchQuery,
                  hintText: 'Search salon, gym, clinic, spa...',
                  onChanged: (val) {
                    ref.read(searchQueryProvider.notifier).state = val;
                    if (val.isNotEmpty) {
                      Navigator.pushNamed(context, '/services');
                    }
                  },
                  hasActiveFilter: isFilterActive,
                  onFilterPressed: () {
                    FilterBottomSheet.show(context);
                  },
                ),
                const SizedBox(height: 18),

                // Horizontal Category Selector Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CategoryPill(
                          label: cat,
                          isSelected: isSelected,
                          onTap: () {
                            ref.read(selectedCategoryProvider.notifier).state = cat;
                            Navigator.pushNamed(context, '/services');
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Promo Banner Hero Card
                CustomBanner(
                  onBookNow: () {
                    final topService = mockServices.first;
                    final provider = mockProviders.firstWhere((p) => p.id == topService.providerId);
                    ref.read(draftBookingProvider.notifier).initService(topService, provider);
                    Navigator.pushNamed(context, '/service-details');
                  },
                ),
                const SizedBox(height: 24),

                // Featured Services Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/services'),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Featured Services List
                ...featuredServices.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final service = entry.value;
                  return ServiceCard(
                    service: service,
                    index: idx,
                    onTap: () {
                      final provider = mockProviders.firstWhere(
                        (p) => p.id == service.providerId,
                        orElse: () => mockProviders.first,
                      );
                      ref.read(draftBookingProvider.notifier).initService(service, provider);
                      Navigator.pushNamed(context, '/service-details');
                    },
                  );
                }),
                const SizedBox(height: 24),

                // Why Choose Us Block
                const _WhyChooseUsSection(),
                const SizedBox(height: 28),

                // Testimonials Carousel Section
                const TestimonialsWidget(),
                const SizedBox(height: 28),

                // CTA Banner Card
                _buildCtaCard(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCtaCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkPill,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skip the Queue at Top Venues',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Book verified salon, clinic, and spa appointments in 30 seconds.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/services'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text('Explore All Services', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _WhyChooseUsSection extends StatelessWidget {
  const _WhyChooseUsSection();

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 600;

    final cards = [
      _FeatureData(
        icon: Icons.verified_user_outlined,
        title: 'Verified Venues',
        desc: 'Certified & licensed top professionals',
        bgColor: AppColors.softMint,
      ),
      _FeatureData(
        icon: Icons.event_available_outlined,
        title: 'Instant Slots',
        desc: 'Zero waiting time or double booking',
        bgColor: AppColors.softPeach,
      ),
      _FeatureData(
        icon: Icons.star_border_rounded,
        title: 'Top Rated',
        desc: '4.9+ average venue rating score',
        bgColor: AppColors.softLavender,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Why Choose Slotly?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 14),
        if (isMobile)
          Column(
            children: cards.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: idx < cards.length - 1 ? 12.0 : 0.0),
                child: _buildMobileCard(item),
              );
            }).toList(),
          )
        else
          IntrinsicHeight(
            child: Row(
              children: cards.asMap().entries.map((entry) {
                final idx = entry.key;
                final item = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: idx < cards.length - 1 ? 12.0 : 0.0),
                    child: _buildDesktopCard(item),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileCard(_FeatureData item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: AppColors.textPrimary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCard(_FeatureData item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: item.bgColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: AppColors.textPrimary, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.desc,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String desc;
  final Color bgColor;

  const _FeatureData({
    required this.icon,
    required this.title,
    required this.desc,
    required this.bgColor,
  });
}