import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../styles/colors.dart';
import '../providers/booking_provider.dart';

class CustomHeader extends ConsumerWidget {
  final bool showProfilePill;
  final bool showBackButton;
  final String? centerTitle;
  final bool alignTitleLeft;
  final String userName;
  final String greetingText;
  final List<Widget>? rightIcons;
  final bool isStandaloneDesktopHeader;

  const CustomHeader({
    super.key,
    this.showProfilePill = false,
    this.showBackButton = false,
    this.centerTitle,
    this.alignTitleLeft = true,
    this.userName = 'Anna Grace',
    this.greetingText = 'Welcome',
    this.rightIcons,
    this.isStandaloneDesktopHeader = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointments = ref.watch(appointmentsProvider);
    final upcomingCount = appointments.where((a) => a.status == 'upcoming').toList().length;

    final isWeb = MediaQuery.of(context).size.width > 768;

    if (isWeb) {
      if (isStandaloneDesktopHeader) {
        return _buildDesktopHeader(context, upcomingCount);
      }
      return const SizedBox.shrink();
    }

    // --- Mobile / Narrow View ---
    final canPop = Navigator.canPop(context);
    final shouldShowBack = showBackButton || centerTitle != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Row(
        children: [
          // Left Action: Back button or Profile Pill
          if (shouldShowBack)
            GestureDetector(
              onTap: () {
                if (canPop) {
                  Navigator.maybePop(context);
                } else {
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 18),
              ),
            )
          else if (showProfilePill)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(
                      radius: 16.0,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80'),
                    ),
                    const SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          greetingText,
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            const SizedBox(width: 44),

          // Left-Aligned Page / Category Title
          Expanded(
            child: centerTitle != null
                ? Padding(
                    padding: EdgeInsets.only(left: shouldShowBack ? 10.0 : 0.0),
                    child: Text(
                      centerTitle!,
                      textAlign: alignTitleLeft ? TextAlign.left : TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),

          // Right Actions
          if (rightIcons != null)
            Row(mainAxisSize: MainAxisSize.min, children: rightIcons!)
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Location Button
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Location set to Downtown Center')),
                    );
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.location_on_outlined, color: AppColors.textPrimary, size: 20),
                  ),
                ),
                const SizedBox(width: 8),

                // Cart / Appointments Badge Button
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/appointments'),
                  child: Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary, size: 20),
                      ),
                      if (upcomingCount > 0)
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '$upcomingCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopHeader(BuildContext context, int upcomingCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Logo
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Slotly',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),

                // Web Nav Links
                _webNavLink(context, 'Home', '/'),
                _webNavLink(context, 'Services', '/services'),
                _webNavLink(context, 'Appointments', '/appointments'),
                _webNavLink(context, 'Profile', '/profile'),
                _webNavLink(context, 'About Us', '/about'),
                _webNavLink(context, 'Contact', '/contact'),

                const SizedBox(width: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/services'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPill,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  child: const Text('Book Now', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),

                // User Profile Badge Button on Desktop
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=150&q=80',
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Anna Grace',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _webNavLink(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}