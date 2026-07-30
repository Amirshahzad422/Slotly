import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/header.dart';
import '../styles/colors.dart';
import '../components/search_bar.dart';
import '../components/filters.dart';
import '../components/category_chip.dart';
import '../components/banner.dart';
import '../providers/search_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isFilterActive = ref.watch(isFilterActiveProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.4, 1.0],
          colors: [
            AppColors.primaryBackground,
            AppColors.white,
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 90.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(
                showProfilePill: true,
                userName: 'Anna Grace',
                rightIcons: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.iconPrimary,
                      size: 22.0,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderLight, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.iconPrimary,
                      size: 22.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Smart Home,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                'Smooth Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              CustomSearchBar(
                initialValue: searchQuery,
                onChanged: (val) {
                  ref.read(searchQueryProvider.notifier).state = val;
                },
                hasActiveFilter: isFilterActive,
                onFilterPressed: () {
                  FilterBottomSheet.show(context);
                },
              ),
              const SizedBox(height: 16),

              // Category Filter Chips bar - Redirect to SelectedCategoryScreen on tap
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                            Navigator.pushNamed(context, '/category-services');
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Custom Banner
              CustomBanner(
                onBookNow: () {
                  Navigator.pushNamed(context, '/services');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}