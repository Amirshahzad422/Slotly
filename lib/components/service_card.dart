import 'package:flutter/material.dart';
import '../models/service_model.dart';
import '../styles/colors.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback? onTap;
  final Color? cardColor;
  final int? index;

  static const List<Color> palette = [
    Color(0xFFFFD6F2), // Soft Pink
    Color(0xFFFFE3CC), // Soft Peach/Orange
    Color(0xFFE2DCFF), // Soft Lavender/Purple
    Color(0xFFCCEBFB), // Soft Sky Blue
    Color(0xFFF3FAD3), // Soft Lime/Yellow
  ];

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
    this.cardColor,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final colorIndex = index ?? service.id.hashCode.abs();
    final bgColor = cardColor ?? palette[colorIndex % palette.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            // Left Image - rounded squircle shape
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                service.imageUrls.isNotEmpty
                    ? service.imageUrls.first
                    : 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=500&q=80',
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 75,
                  height: 75,
                  color: Colors.white24,
                  child: const Icon(Icons.design_services, color: AppColors.textPrimary),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Middle Column: Title & 1-line Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Right Action Button (Circular Forward Button >)
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.04),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF1E1E1E),
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
