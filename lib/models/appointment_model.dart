class AppointmentModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String serviceImage;
  final String providerId;
  final String providerName;
  final String providerImage;
  final String category;
  final DateTime date;
  final String timeSlot;
  final double price;
  final String tier;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final String customerName;
  final String customerPhone;
  final String notes;

  AppointmentModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.providerId,
    required this.providerName,
    required this.providerImage,
    required this.category,
    required this.date,
    required this.timeSlot,
    required this.price,
    this.tier = 'Classic',
    required this.status,
    this.customerName = 'Anna Grace',
    this.customerPhone = '+1 (555) 019-2834',
    this.notes = '',
  });

  AppointmentModel copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? serviceImage,
    String? providerId,
    String? providerName,
    String? providerImage,
    String? category,
    DateTime? date,
    String? timeSlot,
    double? price,
    String? tier,
    String? status,
    String? customerName,
    String? customerPhone,
    String? notes,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceImage: serviceImage ?? this.serviceImage,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerImage: providerImage ?? this.providerImage,
      category: category ?? this.category,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      price: price ?? this.price,
      tier: tier ?? this.tier,
      status: status ?? this.status,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
    );
  }
}
