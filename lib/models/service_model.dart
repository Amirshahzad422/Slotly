class ServiceModel {
  String id;
  String name;
  String providerId;
  String description;
  String category ;
  double price;
  int duration;
  List<String> imageUrls;
  List<String> availableSlots ;
  double rating;

  ServiceModel({
    required this.id,
    required this.name,
    required this.providerId,
    required this.price,
    required this.duration,
    required this.imageUrls,
    required this.category,
    required this.rating,
    required this.availableSlots,
    required this.description,
  });
}