import 'package:flutter/material.dart';
import '../styles/colors.dart';

class CustomSearchBar extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String hintText;
  final VoidCallback? onFilterPressed;
  final bool hasActiveFilter;

  const CustomSearchBar({
    super.key,
    this.initialValue = '',
    required this.onChanged,
    this.hintText = 'Search services, salon, gym, clinic...',
    this.onFilterPressed,
    this.hasActiveFilter = false,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.8), width: 0.8),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.iconPrimary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              iconSize: 18,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.clear, color: AppColors.textLight),
              onPressed: () {
                _controller.clear();
                widget.onChanged('');
              },
            ),
          if (widget.onFilterPressed != null) ...[
            const SizedBox(width: 4),
            InkWell(
              onTap: widget.onFilterPressed,
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: widget.hasActiveFilter
                          ? AppColors.textPrimary
                          : AppColors.primaryBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowDark,
                          blurRadius: 4,
                          spreadRadius: 0.5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: widget.hasActiveFilter ? Colors.white : AppColors.iconPrimary,
                      size: 16,
                    ),
                  ),
                  if (widget.hasActiveFilter)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
