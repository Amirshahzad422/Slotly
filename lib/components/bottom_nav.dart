import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF7D69D8); // Fill color #7D69D8

    final List<IconData> icons = [
      Icons.home_outlined,
      Icons.calendar_today_rounded,
      Icons.grid_view_rounded,
      Icons.person_outline_rounded,
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Active Item - Large Standalone Circle with White Ring Border
            GestureDetector(
              onTap: () => onItemTapped(selectedIndex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: activeColor,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icons[selectedIndex],
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            const SizedBox(width: 6),

            // 2. Unselected Items - Capsule Pill with White Ring Border
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(icons.length, (index) {
                  if (index == selectedIndex) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () => onItemTapped(index),
                    child: Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE5E9ED),
                      ),
                      child: Icon(
                        icons[index],
                        color: const Color(0xFF1E1E1E),
                        size: 20,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
