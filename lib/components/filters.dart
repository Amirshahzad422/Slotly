import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_provider.dart';
import '../styles/colors.dart';
import '../data/mock_data.dart';
import 'button.dart';

class FilterBottomSheet extends ConsumerWidget {
  const FilterBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedProvider = ref.watch(selectedProviderFilterProvider);
    final minRating = ref.watch(minRatingFilterProvider);
    final maxPrice = ref.watch(priceRangeProvider);
    final selectedSort = ref.watch(sortByProvider);

    const categories = ['All', 'Salon', 'Gym', 'Clinic', 'Spa', 'Barber'];
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: isDesktop ? 600 : double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 12,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag indicator
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters & Sorting',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Filter
                    const Text(
                      'Category',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.map((cat) {
                        final isSelected = selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          selectedColor: AppColors.darkPill,
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          side: BorderSide(
                            color: isSelected ? AppColors.darkPill : AppColors.border,
                          ),
                          onSelected: (val) {
                            ref.read(selectedCategoryProvider.notifier).state = cat;
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Provider Selector
                    const Text(
                      'Service Provider',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedProvider,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: [
                            const DropdownMenuItem(value: 'All', child: Text('All Providers')),
                            ...mockProviders.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(selectedProviderFilterProvider.notifier).state = val;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Maximum Price Range Slider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Max Price',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          '\$${maxPrice.toInt()}',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                    Slider(
                      value: maxPrice,
                      min: 20,
                      max: 500,
                      divisions: 24,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.border,
                      onChanged: (val) {
                        ref.read(priceRangeProvider.notifier).state = val;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Minimum Rating Filter (Scrollable to prevent overflow)
                    const Text(
                      'Minimum Rating',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [0.0, 4.0, 4.5, 4.8].map((rating) {
                          final isSelected = minRating == rating;
                          final label = rating == 0.0 ? 'Any Rating' : '$rating★ & up';
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(label),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                              ),
                              onSelected: (val) {
                                ref.read(minRatingFilterProvider.notifier).state = rating;
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sort Options
                    const Text(
                      'Sort By',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    _buildSortRadio(ref, 'Popularity & Reviews', SortOption.popular, selectedSort),
                    _buildSortRadio(ref, 'Price: Low to High', SortOption.priceLowToHigh, selectedSort),
                    _buildSortRadio(ref, 'Price: High to Low', SortOption.priceHighToLow, selectedSort),
                    _buildSortRadio(ref, 'Highest Rated First', SortOption.highestRated, selectedSort),
                    _buildSortRadio(ref, 'Newest Arrivals', SortOption.newest, selectedSort),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Reset',
                    variant: ButtonVariant.outline,
                    onPressed: () {
                      ref.read(selectedCategoryProvider.notifier).state = 'All';
                      ref.read(selectedProviderFilterProvider.notifier).state = 'All';
                      ref.read(minRatingFilterProvider.notifier).state = 0.0;
                      ref.read(priceRangeProvider.notifier).state = 500.0;
                      ref.read(sortByProvider.notifier).state = SortOption.popular;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Apply Filters',
                    variant: ButtonVariant.dark,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortRadio(WidgetRef ref, String title, SortOption option, SortOption current) {
    final isSelected = option == current;
    return InkWell(
      onTap: () {
        ref.read(sortByProvider.notifier).state = option;
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
