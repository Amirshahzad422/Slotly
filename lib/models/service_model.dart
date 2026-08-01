class ServiceTier {
  final String name; // e.g. Classic, Premium, Platinum
  final double price;
  final String description;

  const ServiceTier({
    required this.name,
    required this.price,
    required this.description,
  });
}

class ServiceModel {
  final String id;
  final String name;
  final String providerId;
  final String description;
  final String category;
  final double price;
  final double? originalPrice;
  final int duration; // in minutes
  final List<String> imageUrls;
  final List<String> availableSlots;
  final double rating;
  final int reviewsCount;
  final double discountPercentage;
  final List<String> includedFeatures;
  final List<ServiceTier> tiers;
  final String location;

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerId,
    required this.price,
    this.originalPrice,
    required this.duration,
    required this.imageUrls,
    required this.category,
    required this.rating,
    this.reviewsCount = 124,
    required this.availableSlots,
    required this.description,
    this.discountPercentage = 0,
    this.includedFeatures = const [],
    this.tiers = const [],
    this.location = 'Downtown Center',
  });
}