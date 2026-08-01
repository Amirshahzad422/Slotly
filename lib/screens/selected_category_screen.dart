import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/search_bar.dart';
import '../components/service_card.dart';
import '../components/filters.dart';
import '../components/category_chip.dart';
import '../providers/search_provider.dart';
import '../providers/booking_provider.dart';
import '../styles/colors.dart';
import '../data/mock_data.dart';

class SelectedCategoryScreen extends ConsumerWidget {
  const SelectedCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isFilterActive = ref.watch(isFilterActiveProvider);
    final filteredServices = ref.watch(filteredServicesProvider);

    const categories = ['All', 'Salon', 'Gym', 'Clinic', 'Spa', 'Barber'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(selectedCategory == 'All' ? 'All Services' : '$selectedCategory Services'),
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isFilterActive || searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Reset Filters',
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
                ref.read(selectedCategoryProvider.notifier).state = 'All';
                ref.read(selectedProviderFilterProvider.notifier).state = 'All';
                ref.read(minRatingFilterProvider.notifier).state = 0.0;
                ref.read(priceRangeProvider.notifier).state = 500.0;
                ref.read(sortByProvider.notifier).state = SortOption.popular;
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
            child: CustomSearchBar(
              initialValue: searchQuery,
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).state = val;
              },
              hasActiveFilter: isFilterActive,
              onFilterPressed: () {
                FilterBottomSheet.show(context);
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Results (${filteredServices.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (isFilterActive || searchQuery.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      ref.read(searchQueryProvider.notifier).state = '';
                      ref.read(selectedCategoryProvider.notifier).state = 'All';
                      ref.read(selectedProviderFilterProvider.notifier).state = 'All';
                      ref.read(minRatingFilterProvider.notifier).state = 0.0;
                      ref.read(priceRangeProvider.notifier).state = 500.0;
                      ref.read(sortByProvider.notifier).state = SortOption.popular;
                    },
                    child: const Text('Reset All'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filteredServices.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: AppColors.textLight),
                        SizedBox(height: 12),
                        Text(
                          'No services found for this filter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return ServiceCard(
                        service: service,
                        index: index,
                        onTap: () {
                          final provider = mockProviders.firstWhere(
                            (p) => p.id == service.providerId,
                            orElse: () => mockProviders.first,
                          );
                          ref.read(draftBookingProvider.notifier).initService(service, provider);
                          Navigator.pushNamed(context, '/service-details');
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
