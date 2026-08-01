import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/colors.dart';
import '../components/button.dart';
import '../utils/formatters.dart';
import '../providers/booking_provider.dart';

class ConfirmScreen extends ConsumerWidget {
  const ConfirmScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final latestAppointment = appointments.isNotEmpty ? appointments.first : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success Badge Circle
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: AppColors.softMint,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.success,
                      child: Icon(Icons.check_rounded, color: Colors.white, size: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your appointment has been successfully scheduled.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // Booking Breakdown Summary Card
                if (latestAppointment != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                latestAppointment.serviceImage,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    latestAppointment.serviceName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Provider: ${latestAppointment.providerName}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildRow('Booking ID', latestAppointment.id),
                        const SizedBox(height: 8),
                        _buildRow('Date & Time', '${Formatters.date(latestAppointment.date)} at ${latestAppointment.timeSlot}'),
                        const SizedBox(height: 8),
                        _buildRow('Package Tier', latestAppointment.tier),
                        const SizedBox(height: 8),
                        _buildRow('Customer', latestAppointment.customerName),
                        const Divider(height: 24),
                        _buildRow('Total Paid', Formatters.currency(latestAppointment.price), isPrimary: true),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),

                // Action Buttons
                AppButton(
                  text: 'View My Appointments',
                  variant: ButtonVariant.primary,
                  width: double.infinity,
                  onPressed: () => Navigator.pushReplacementNamed(context, '/appointments'),
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Back to Home',
                  variant: ButtonVariant.outline,
                  width: double.infinity,
                  onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isPrimary ? 16 : 13,
            fontWeight: FontWeight.bold,
            color: isPrimary ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
