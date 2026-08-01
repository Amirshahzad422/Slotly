import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../components/header.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  static const List<Map<String, String>> posts = [
    {
      'title': 'Top 5 Skincare Routines Before Your Hydrating Facial Spa',
      'category': 'Salon & Beauty',
      'readTime': '3 min read',
      'image': 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=500&q=80',
      'excerpt': 'Prepare your skin texture with gentle exfoliation and moisture sealing for maximum radiant glow after your salon facial.',
    },
    {
      'title': 'How 1-on-1 Fitness Coaching Accelerates Strength & Metabolism',
      'category': 'Gym & Fitness',
      'readTime': '5 min read',
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=500&q=80',
      'excerpt': 'Structured gym workouts paired with body composition tracking maximize athletic stamina and functional mobility.',
    },
    {
      'title': 'Why Deep Tissue Massage is Essential for Post-Workout Recovery',
      'category': 'Spa & Wellness',
      'readTime': '4 min read',
      'image': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=500&q=80',
      'excerpt': 'Discover how hot basalt stones and targeted pressure release chronic muscle tightness and joint fatigue.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(
                showBackButton: true,
                centerTitle: 'Blog & Wellness Guides',
              ),
              const SizedBox(height: 16),

              ...posts.map((post) => Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: Image.network(
                            post['image']!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.softMint,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      post['category']!,
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    post['readTime']!,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                post['title']!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                post['excerpt']!,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
