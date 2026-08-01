import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/appointment_model.dart';
import '../models/service_model.dart';
import '../models/provider_model.dart';

class DraftBookingState {
  final ServiceModel? service;
  final ProviderModel? provider;
  final DateTime date;
  final String? timeSlot;
  final ServiceTier? selectedTier;
  final String customerName;
  final String customerPhone;
  final String notes;

  DraftBookingState({
    this.service,
    this.provider,
    DateTime? date,
    this.timeSlot,
    this.selectedTier,
    this.customerName = 'Anna Grace',
    this.customerPhone = '+1 (555) 019-2834',
    this.notes = '',
  }) : date = date ?? DateTime.now().add(const Duration(days: 1));

  DraftBookingState copyWith({
    ServiceModel? service,
    ProviderModel? provider,
    DateTime? date,
    String? timeSlot,
    ServiceTier? selectedTier,
    String? customerName,
    String? customerPhone,
    String? notes,
  }) {
    return DraftBookingState(
      service: service ?? this.service,
      provider: provider ?? this.provider,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      selectedTier: selectedTier ?? this.selectedTier,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice {
    if (selectedTier != null) return selectedTier!.price;
    return service?.price ?? 0.0;
  }
}

class DraftBookingNotifier extends StateNotifier<DraftBookingState> {
  DraftBookingNotifier() : super(DraftBookingState());

  void initService(ServiceModel service, ProviderModel? provider) {
    state = DraftBookingState(
      service: service,
      provider: provider,
      date: DateTime.now().add(const Duration(days: 1)),
      timeSlot: service.availableSlots.isNotEmpty ? service.availableSlots.first : '10:00 AM',
      selectedTier: service.tiers.isNotEmpty ? service.tiers.first : null,
    );
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void updateSlot(String slot) {
    state = state.copyWith(timeSlot: slot);
  }

  void updateTier(ServiceTier tier) {
    state = state.copyWith(selectedTier: tier);
  }

  void updateContactInfo(String name, String phone, String notes) {
    state = state.copyWith(customerName: name, customerPhone: phone, notes: notes);
  }
}

final draftBookingProvider =
    StateNotifierProvider<DraftBookingNotifier, DraftBookingState>((ref) {
  return DraftBookingNotifier();
});

class AppointmentsNotifier extends StateNotifier<List<AppointmentModel>> {
  AppointmentsNotifier() : super(List.from(mockAppointments));

  void confirmBooking(DraftBookingState draft) {
    if (draft.service == null) return;

    final newAppointment = AppointmentModel(
      id: 'apt-${DateTime.now().millisecondsSinceEpoch}',
      serviceId: draft.service!.id,
      serviceName: draft.service!.name,
      serviceImage: draft.service!.imageUrls.isNotEmpty ? draft.service!.imageUrls.first : '',
      providerId: draft.provider?.id ?? draft.service!.providerId,
      providerName: draft.provider?.name ?? 'Slotly Partner',
      providerImage: draft.provider?.image ?? '',
      category: draft.service!.category,
      date: draft.date,
      timeSlot: draft.timeSlot ?? '10:00 AM',
      price: draft.totalPrice,
      tier: draft.selectedTier?.name ?? 'Classic',
      status: 'upcoming',
      customerName: draft.customerName,
      customerPhone: draft.customerPhone,
      notes: draft.notes,
    );

    state = [newAppointment, ...state];
  }

  void cancelAppointment(String appointmentId) {
    state = state.map((apt) {
      if (apt.id == appointmentId) {
        return apt.copyWith(status: 'cancelled');
      }
      return apt;
    }).toList();
  }

  void rescheduleAppointment(String appointmentId, DateTime newDate, String newSlot) {
    state = state.map((apt) {
      if (apt.id == appointmentId) {
        return apt.copyWith(date: newDate, timeSlot: newSlot, status: 'upcoming');
      }
      return apt;
    }).toList();
  }
}

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, List<AppointmentModel>>((ref) {
  return AppointmentsNotifier();
});
