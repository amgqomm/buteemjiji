// widgets/profile_item.dart
import 'package:flutter/material.dart';
import '../utils/theme_constants.dart';

class ProfileItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isPassword;
  final VoidCallback? onTap;

  const ProfileItem({
    super.key,
    required this.label,
    required this.value,
    this.isPassword = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            Text(
              value,
              style: TextStyle(
                color: isPassword ? AppTheme.textSecondary : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}