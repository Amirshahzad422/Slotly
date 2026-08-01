import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../components/header.dart';
import '../components/search_bar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _query = '';

  static const List<Map<String, String>> faqs = [
    {
      'q': 'How do I book an appointment on Slotly?',
      'a': 'Simply browse our services on the home or services page, tap on your desired service, pick a date and available time slot, and tap "Confirm Booking". Your appointment will immediately appear under "Appointments".'
    },
    {
      'q': 'Can I reschedule or cancel my booking?',
      'a': 'Yes! Navigate to the "Appointments" tab, select your upcoming booking, and tap "Reschedule" to pick a new date/time, or tap "Cancel Booking".'
    },
    {
      'q': 'Are the service providers background checked?',
      'a': '100% yes. All service professionals on Slotly undergo rigorous identity verification, background screening, and skill certifications.'
    },
    {
      'q': 'Is any advance payment required?',
      'a': 'No advance payment is needed for local mock bookings. In live client deployments, secure digital payments or pay-at-venue options are supported.'
    },
    {
      'q': 'What happens if a provider is delayed?',
      'a': 'You will receive real-time updates and direct contact options via phone and chat on your appointment card.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFaqs = faqs.where((item) {
      final q = item['q']!.toLowerCase();
      final a = item['a']!.toLowerCase();
      final search = _query.toLowerCase();
      return q.contains(search) || a.contains(search);
    }).toList();

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
                centerTitle: 'Frequently Asked Questions',
              ),
              const SizedBox(height: 16),

              CustomSearchBar(
                initialValue: _query,
                hintText: 'Search FAQ topics...',
                onChanged: (val) => setState(() => _query = val),
              ),
              const SizedBox(height: 20),

              if (filteredFaqs.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: Text('No matching FAQ topics found.', style: TextStyle(color: AppColors.textSecondary))),
                )
              else
                ...filteredFaqs.map((faq) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ExpansionTile(
                        shape: Border.all(color: Colors.transparent),
                        title: Text(
                          faq['q']!,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                            child: Text(
                              faq['a']!,
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
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
