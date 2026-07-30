import 'package:flutter/material.dart';
import '../styles/colors.dart';

class CustomHeader extends StatelessWidget {
  final bool showProfilePill;
  final bool showBackButton;
  final String? centerTitle;
  final String userName;
  final String greetingText;
  final List<Widget> rightIcons;

  const CustomHeader({
    super.key,
    this.showProfilePill = false,
    this.showBackButton = false,
    this.centerTitle,
    this.userName = '',
    this.greetingText = 'Welcome',
    this.rightIcons = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          else if (showProfilePill)
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryBackground,
                  borderRadius: BorderRadius.circular(30.0),
                  border: Border.all(color: AppColors.borderLight, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark,
                      blurRadius: 4,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=47'),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            greetingText,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6.0),
                    ]
                )
            )
          else
            const SizedBox(width: 48),

          if (centerTitle != null)
            Text(
              centerTitle!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

          Row(
            children: rightIcons,
          ),
        ],
      ),
    );
  }
}