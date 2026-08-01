import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../utils/formatters.dart';

class SlotPicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final String? selectedSlot;
  final ValueChanged<String> onSlotSelected;
  final List<String> availableSlots;
  final List<String> bookedSlots;

  const SlotPicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.selectedSlot,
    required this.onSlotSelected,
    required this.availableSlots,
    this.bookedSlots = const ['08:00 AM', '01:00 PM'], // mock booked slots
  });

  @override
  Widget build(BuildContext context) {
    // Generate next 14 days
    final dates = List.generate(14, (index) => DateTime.now().add(Duration(days: index + 1)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Selector Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              Formatters.date(selectedDate),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal Date Strip
        SizedBox(
          height: 75,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected =
                  date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Formatters.dayName(date),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white70 : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Formatters.dayNumber(date),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Slot Legend
        const Row(
          children: [
            _SlotLegendItem(color: AppColors.primary, label: 'Selected'),
            SizedBox(width: 16),
            _SlotLegendItem(color: Colors.white, borderColor: AppColors.border, label: 'Available'),
            SizedBox(width: 16),
            _SlotLegendItem(color: Color(0xFFF3F4F6), label: 'Booked'),
          ],
        ),
        const SizedBox(height: 16),

        // Time Slot Grid Header
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),

        // Time Slot Wrap Grid
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableSlots.map((slot) {
            final isSelected = selectedSlot == slot;
            final isBooked = bookedSlots.contains(slot);

            return GestureDetector(
              onTap: isBooked ? null : () => onSlotSelected(slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : isBooked
                          ? const Color(0xFFF3F4F6)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : isBooked
                            ? Colors.transparent
                            : AppColors.border,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : isBooked
                            ? AppColors.textLight
                            : AppColors.textPrimary,
                    decoration: isBooked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SlotLegendItem extends StatelessWidget {
  final Color color;
  final Color? borderColor;
  final String label;

  const _SlotLegendItem({
    required this.color,
    this.borderColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: borderColor != null ? Border.all(color: borderColor!) : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
