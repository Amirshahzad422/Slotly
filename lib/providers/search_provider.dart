import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/service_model.dart';

enum SortOption {
  popular,
  newest,
  priceLowToHigh,
  priceHighToLow,
  highestRated
}

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');
final selectedProviderFilterProvider = StateProvider<String>((ref) => 'All');
final minRatingFilterProvider = StateProvider<double>((ref) => 0.0);
final priceRangeProvider = StateProvider<double>((ref) => 500.0); // max price ceiling
final sortByProvider = StateProvider<SortOption>((ref) => SortOption.popular);
final isGridViewProvider = StateProvider<bool>((ref) => false); // List view default

final isFilterActiveProvider = Provider<bool>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  final provider = ref.watch(selectedProviderFilterProvider);
  final minRating = ref.watch(minRatingFilterProvider);
  final maxPrice = ref.watch(priceRangeProvider);
  final sort = ref.watch(sortByProvider);
  return category != 'All' ||
      provider != 'All' ||
      minRating > 0.0 ||
      maxPrice < 500.0 ||
      sort != SortOption.popular;
});

final filteredServicesProvider = Provider<List<ServiceModel>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final category = ref.watch(selectedCategoryProvider);
  final providerId = ref.watch(selectedProviderFilterProvider);
  final minRating = ref.watch(minRatingFilterProvider);
  final maxPrice = ref.watch(priceRangeProvider);
  final sort = ref.watch(sortByProvider);

  List<ServiceModel> services = List.from(mockServices);

  // 1. Keyword search
  if (query.isNotEmpty) {
    services = services.where((service) {
      final matchesName = service.name.toLowerCase().contains(query);
      final matchesCategory = service.category.toLowerCase().contains(query);
      final matchesDesc = service.description.toLowerCase().contains(query);
      return matchesName || matchesCategory || matchesDesc;
    }).toList();
  }

  // 2. Category filter
  if (category != 'All') {
    services = services
        .where((service) =>
            service.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // 3. Provider filter
  if (providerId != 'All') {
    services = services
        .where((service) => service.providerId == providerId)
        .toList();
  }

  // 4. Rating filter
  if (minRating > 0) {
    services = services.where((service) => service.rating >= minRating).toList();
  }

  // 5. Price ceiling filter
  services = services.where((service) => service.price <= maxPrice).toList();

  // 6. Sorting
  switch (sort) {
    case SortOption.priceLowToHigh:
      services.sort((a, b) => a.price.compareTo(b.price));
      break;
    case SortOption.priceHighToLow:
      services.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortOption.highestRated:
      services.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case SortOption.newest:
      services.sort((a, b) => b.id.compareTo(a.id));
      break;
    case SortOption.popular:
      services.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
      break;
  }

  return services;
});
