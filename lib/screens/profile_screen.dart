import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/colors.dart';
import '../components/header.dart';
import '../providers/favorites_provider.dart';
import '../providers/booking_provider.dart';
import '../data/mock_data.dart';
import '../components/service_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final appointments = ref.watch(appointmentsProvider);
    final upcomingCount = appointments.where((a) => a.status == 'upcoming').length;

    final favoriteServices = mockServices.where((s) => favorites.contains(s.id)).toList();

    return Column(
      children: [
        // Pinned Header with Back Button
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: CustomHeader(
            showBackButton: true,
            centerTitle: 'My Profile',
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Avatar Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Anna Grace',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'anna.grace@example.com',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.softMint,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'VIP Member',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Row
                Row(
                  children: [
                    _buildStatCard('Upcoming', upcomingCount.toString(), AppColors.softLavender),
                    const SizedBox(width: 12),
                    _buildStatCard('Favorites', favorites.length.toString(), AppColors.softPink),
                    const SizedBox(width: 12),
                    _buildStatCard('Bookings', appointments.length.toString(), AppColors.softSkyBlue),
                  ],
                ),
                const SizedBox(height: 24),

                // Saved Favorite Services
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Favorites (${favoriteServices.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (favorites.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          for (final id in favorites.toList()) {
                            ref.read(favoritesProvider.notifier).toggleFavorite(id);
                          }
                        },
                        child: const Text('Clear All'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                if (favoriteServices.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.favorite_border_rounded, size: 36, color: AppColors.textLight),
                        SizedBox(height: 8),
                        Text(
                          'No Favorite Services Saved',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tap the heart icon on any service card to save it here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  )
                else
                  ...favoriteServices.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final service = entry.value;
                    return ServiceCard(
                      service: service,
                      index: idx,
                      onTap: () {
                        final provider = mockProviders.firstWhere(
                          (p) => p.id == service.providerId,
                          orElse: () => mockProviders.first,
                        );
                        ref.read(draftBookingProvider.notifier).initService(service, provider);
                        Navigator.pushNamed(context, '/service-details');
                      },
                    );
                  }),
                const SizedBox(height: 24),

                // Account Navigation Links
                _buildMenuSection(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildMenuItem(context, Icons.info_outline_rounded, 'About Slotly', '/about'),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.contact_support_outlined, 'Contact Support', '/contact'),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.help_outline_rounded, 'FAQ & Help Center', '/faq'),
          const Divider(height: 1),
          _buildMenuItem(context, Icons.article_outlined, 'Wellness & Beauty Blog', '/blog'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textPrimary, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}
