class ProviderModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String contact;
  final String bio;
  final String role;
  final String location;
  final int completedBookings;

  ProviderModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.contact,
    required this.bio,
    this.role = 'Service Professional',
    this.location = 'Downtown Branch',
    this.completedBookings = 250,
  });
}
