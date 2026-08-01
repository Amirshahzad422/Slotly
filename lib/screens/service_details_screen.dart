import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/colors.dart';
import '../models/service_model.dart';
import '../utils/formatters.dart';
import '../providers/booking_provider.dart';
import '../providers/favorites_provider.dart';
import '../data/mock_data.dart';
import '../components/service_card.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  const ServiceDetailsScreen({super.key});

  @override
  ConsumerState<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  int _selectedTierIndex = 0;
  int _selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(draftBookingProvider);
    final service = draft.service ?? mockServices.first;
    final provider = draft.provider ??
        mockProviders.firstWhere(
          (p) => p.id == service.providerId,
          orElse: () => mockProviders.first,
        );

    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(service.id);

    final tiers = service.tiers.isNotEmpty
        ? service.tiers
        : [
            ServiceTier(name: 'Classic', price: service.price, description: 'Standard Service'),
            ServiceTier(name: 'Premium', price: service.price * 1.15, description: 'Premium Service + Addons'),
            ServiceTier(name: 'Platinum', price: service.price * 1.25, description: 'All-Inclusive Luxury Package'),
          ];

    final activePrice = tiers[_selectedTierIndex].price;
    final similarServices = mockServices.where((s) => s.id != service.id && s.category == service.category).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Responsive Hero Header Card Container
                _buildHeroHeader(context, service, ref, isFav),

                // Details Content Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Discount Badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  service.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (service.discountPercentage > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.softMint,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Up to',
                                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                  Text(
                                    '${service.discountPercentage.toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const Text(
                                    'Off',
                                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Price Display
                      Row(
                        children: [
                          Text(
                            Formatters.currency(activePrice),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (service.originalPrice != null) ...[
                            const SizedBox(width: 10),
                            Text(
                              Formatters.currency(service.originalPrice!),
                              style: const TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${service.rating} (${service.reviewsCount} reviews)',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Tier Selection Chips (Classic, Premium, Platinum)
                      const Text(
                        'Select Package Tier',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: tiers.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final tier = entry.value;
                          final isSelected = _selectedTierIndex == idx;

                          Color chipBg;
                          if (idx == 0) {
                            chipBg = AppColors.darkPill;
                          } else if (idx == 1) {
                            chipBg = AppColors.softLavender;
                          } else {
                            chipBg = AppColors.softSkyBlue;
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedTierIndex = idx);
                                ref.read(draftBookingProvider.notifier).updateTier(tier);
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: idx < tiers.length - 1 ? 8 : 0),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? chipBg : Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected ? chipBg : AppColors.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.08),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      tier.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected && idx == 0 ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Formatters.currency(tier.price),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected && idx == 0 ? Colors.white70 : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Provider Info Card
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/provider');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(provider.image),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      provider.role,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Call action button
                              IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling ${provider.contact}...')),
                                  );
                                },
                                icon: const Icon(Icons.phone_outlined, color: AppColors.textPrimary, size: 20),
                                style: IconButton.styleFrom(backgroundColor: AppColors.background),
                              ),
                              // Message action button
                              IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Messaging ${provider.name}...')),
                                  );
                                },
                                icon: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.textPrimary, size: 20),
                                style: IconButton.styleFrom(backgroundColor: AppColors.background),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description Section
                      const Text(
                        'Service Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Included Features Checklist
                      if (service.includedFeatures.isNotEmpty) ...[
                        const Text(
                          'What\'s Included',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...service.includedFeatures.map((feat) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      feat,
                                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 24),
                      ],

                      // Similar Services Section
                      if (similarServices.isNotEmpty) ...[
                        const Text(
                          'Similar Services',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...similarServices.take(2).map((simService) => ServiceCard(
                              service: simService,
                              onTap: () {
                                final p = mockProviders.firstWhere(
                                  (pr) => pr.id == simService.providerId,
                                  orElse: () => mockProviders.first,
                                );
                                ref.read(draftBookingProvider.notifier).initService(simService, p);
                                Navigator.pushReplacementNamed(context, '/service-details');
                              },
                            )),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Price',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        Text(
                          Formatters.currency(activePrice),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 180,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(draftBookingProvider.notifier).updateTier(tiers[_selectedTierIndex]);
                          Navigator.pushNamed(context, '/booking');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context, ServiceModel service, WidgetRef ref, bool isFav) {
    final isDesktop = MediaQuery.of(context).size.width > 768;
    final headerHeight = isDesktop ? 360.0 : 300.0;
    final imageHeight = isDesktop ? 280.0 : 220.0;

    final images = service.imageUrls.isNotEmpty
        ? service.imageUrls
        : ['https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80'];

    final activeImage = images[_selectedImageIndex % images.length];

    return Container(
      width: double.infinity,
      height: headerHeight,
      decoration: const BoxDecoration(
        color: AppColors.softPink,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        children: [
          // Top Navigation Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.textPrimary),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(favoritesProvider.notifier).toggleFavorite(service.id);
                    },
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? Colors.redAccent : AppColors.textPrimary,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Center Image Cutout Frame with responsive full view fitting & image selector
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: imageHeight,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.6),
                      child: Image.network(
                        activeImage,
                        width: double.infinity,
                        height: double.infinity,
                        fit: isDesktop ? BoxFit.contain : BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.white24,
                          child: const Icon(Icons.spa_rounded, size: 60, color: AppColors.primary),
                        ),
                      ),
                    ),
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Row(
                        children: images.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final isSelected = idx == _selectedImageIndex;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedImageIndex = idx),
                            child: Container(
                              margin: const EdgeInsets.only(left: 6),
                              width: isSelected ? 24 : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.darkPill : Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
