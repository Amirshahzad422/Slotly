import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/search_bar.dart';
import '../components/service_card.dart';
import '../components/filters.dart';
import '../components/category_chip.dart';
import '../providers/search_provider.dart';
import '../styles/colors.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isFilterActive = ref.watch(isFilterActiveProvider);
    final filteredServices = ref.watch(filteredServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('All Services'),
        elevation: 0,
        backgroundColor: AppColors.primaryBackground,
        foregroundColor: AppColors.textPrimary,
        actions: [
          if (isFilterActive || searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: 'Reset Filters',
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
                ref.read(selectedCategoryProvider.notifier).state = 'All';
                ref.read(sortByProvider.notifier).state = SortOption.defaultSort;
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
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
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['All', 'Salon', 'Gym', 'Clinic'].map((cat) {
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
          ),
          Expanded(
            child: filteredServices.isEmpty
                ? const Center(
                    child: Text(
                      'No services found',
                      style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return ServiceCard(service: service, index: index);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
