import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/service_model.dart';

enum SortOption { defaultSort, priceLowToHigh, priceHighToLow, highestRated }

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final sortByProvider = StateProvider<SortOption>((ref) => SortOption.defaultSort);

final isFilterActiveProvider = Provider<bool>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final sort = ref.watch(sortByProvider);
  return category != 'All' || sort != SortOption.defaultSort;
});

final filteredServicesProvider = Provider<List<ServiceModel>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final sortOption = ref.watch(sortByProvider);

  List<ServiceModel> services = List.from(mockServices);

  // 1. Filter by Search Query
  if (query.isNotEmpty) {
    services = services.where((service) {
      final matchesName = service.name.toLowerCase().contains(query);
      final matchesCategory = service.category.toLowerCase().contains(query);
      final matchesDescription = service.description.toLowerCase().contains(query);
      return matchesName || matchesCategory || matchesDescription;
    }).toList();
  }

  // 2. Filter by Category
  if (selectedCategory != 'All') {
    services = services.where((service) =>
        service.category.toLowerCase() == selectedCategory.toLowerCase()).toList();
  }

  // 3. Apply Sorting
  switch (sortOption) {
    case SortOption.priceLowToHigh:
      services.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceHighToLow:
      services.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.highestRated:
      services.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.defaultSort:
      break;
  }

  return services;
});
