import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/colors.dart';
import '../components/header.dart';
import '../components/search_bar.dart';
import '../components/filters.dart';
import '../components/service_card.dart';
import '../components/loader.dart';
import '../providers/search_provider.dart';
import '../providers/booking_provider.dart';
import '../data/mock_data.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 6;
  bool _isLoading = false;

  void _triggerLoading() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(filteredServicesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isFilterActive = ref.watch(isFilterActiveProvider);
    final isGrid = ref.watch(isGridViewProvider);

    final isDesktop = MediaQuery.of(context).size.width > 768;
    final totalPages = (services.length / _itemsPerPage).ceil().clamp(1, 99);
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final paginatedServices = services.skip(startIndex).take(_itemsPerPage).toList();

    // Web Desktop View uses Pagination (6 per page)
    // Mobile View uses Lazy Continuous Scrolling (renders all matching services as you scroll)
    final displayServices = isDesktop ? paginatedServices : services;

    final crossAxisCount = isDesktop ? 3 : 2;
    final childAspectRatio = isDesktop ? 0.92 : 0.72;

    return Column(
      children: [
        // Pinned Header with Back Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomHeader(
            showBackButton: true,
            centerTitle: selectedCategory == 'All' ? 'All Services' : selectedCategory,
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Hero Banner
                _buildCategoryHeroBanner(context, selectedCategory),
                const SizedBox(height: 18),

                // Search Bar & Filter Modal Trigger
                CustomSearchBar(
                  initialValue: searchQuery,
                  hintText: 'Search in $selectedCategory...',
                  onChanged: (val) {
                    ref.read(searchQueryProvider.notifier).state = val;
                    _triggerLoading();
                  },
                  hasActiveFilter: isFilterActive,
                  onFilterPressed: () {
                    FilterBottomSheet.show(context);
                  },
                ),
                const SizedBox(height: 16),

                // Layout Switcher & Active Filter Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${services.length} Services Available',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.format_list_bulleted_rounded,
                            color: !isGrid ? AppColors.primary : AppColors.textLight,
                          ),
                          onPressed: () {
                            ref.read(isGridViewProvider.notifier).state = false;
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.grid_view_rounded,
                            color: isGrid ? AppColors.primary : AppColors.textLight,
                          ),
                          onPressed: () {
                            ref.read(isGridViewProvider.notifier).state = true;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Services Grid / List View with Lazy Viewport Loading & Shimmer Support
                if (_isLoading)
                  isGrid
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) => const ServiceGridSkeleton(),
                        )
                      : Column(
                          children: List.generate(4, (_) => const ServiceCardSkeleton()),
                        )
                else if (displayServices.isEmpty)
                  _buildEmptyState(context, ref)
                else if (isGrid)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: displayServices.length,
                    itemBuilder: (context, index) {
                      final service = displayServices[index];
                      return ServiceCard(
                        service: service,
                        isGrid: true,
                        index: index,
                        onTap: () => _openDetails(context, ref, service),
                      );
                    },
                  )
                else
                  Column(
                    children: displayServices.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final service = entry.value;
                      return ServiceCard(
                        service: service,
                        isGrid: false,
                        index: idx,
                        onTap: () => _openDetails(context, ref, service),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),

                // Pagination Controls ONLY rendered on Desktop Web view when multiple pages exist
                if (isDesktop && totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() => _currentPage--);
                                _triggerLoading();
                              }
                            : null,
                        icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Page $_currentPage of $totalPages',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _currentPage < totalPages
                            ? () {
                                setState(() => _currentPage++);
                                _triggerLoading();
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHeroBanner(BuildContext context, String category) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.softMint,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category == 'All' ? 'In-Person Appointments' : '$category Packages',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Get 20% Off Venue Bookings Today',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Discount auto-applied at slot confirmation!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPill,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              elevation: 0,
            ),
            child: const Text('Claim 20%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.softLavender,
            child: Icon(Icons.search_off_rounded, size: 36, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Services Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'We couldn\'t find any services matching your search or filters.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ref.read(searchQueryProvider.notifier).state = '';
              ref.read(selectedCategoryProvider.notifier).state = 'All';
              ref.read(selectedProviderFilterProvider.notifier).state = 'All';
              ref.read(minRatingFilterProvider.notifier).state = 0.0;
              ref.read(priceRangeProvider.notifier).state = 500.0;
              ref.read(sortByProvider.notifier).state = SortOption.popular;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkPill,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Reset All Filters'),
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, WidgetRef ref, service) {
    final provider = mockProviders.firstWhere(
      (p) => p.id == service.providerId,
      orElse: () => mockProviders.first,
    );
    ref.read(draftBookingProvider.notifier).initService(service, provider);
    Navigator.pushNamed(context, '/service-details');
  }
}
