import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({'s1', 's9'}); // Pre-saved initial favorites for demo

  void toggleFavorite(String serviceId) {
    if (state.contains(serviceId)) {
      state = {...state}..remove(serviceId);
    } else {
      state = {...state, serviceId};
    }
  }

  bool isFavorite(String serviceId) {
    return state.contains(serviceId);
  }
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
