import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../utils/theme_constants.dart';
import '../utils/profile_dialogs.dart';
import '../extensions/gender_extensions.dart';
import 'profile_item.dart';

class ProfileSection extends StatelessWidget {
  final AppUser user;
  final VoidCallback onSignOut;

  const ProfileSection({
    super.key,
    required this.user,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Хувийн мэдээлэл',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildPersonalInfoCard(context),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: TextButton(
                      onPressed: onSignOut,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryBlue,
                      ),
                      child: const Center(
                        child: Text(
                          'Гарах',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ProfileItem(
            label: 'Нэр',
            value: user.username,
            onTap: () => ProfileDialogs.showEditUsernameDialog(context, user),
          ),
          const Divider(height: 1, color: AppTheme.darkBackground),
          ProfileItem(
            label: 'Имэйл',
            value: user.email,
            onTap: () => ProfileDialogs.showEditEmailDialog(context, user),
          ),
          const Divider(height: 1, color: AppTheme.darkBackground),
          ProfileItem(
            label: 'Нууц үг',
            value: '********',
            isPassword: true,
            onTap: () => ProfileDialogs.showChangePasswordDialog(context),
          ),
          const Divider(height: 1, color: AppTheme.darkBackground),
          ProfileItem(
            label: 'Хүйс',
            value: user.gender.translation,
            onTap: () => ProfileDialogs.showEditGenderDialog(context, user),
          ),
          const Divider(height: 1, color: AppTheme.darkBackground),
          ProfileItem(
            label: 'Нас',
            value: '${user.age}',
            onTap: () => ProfileDialogs.showEditAgeDialog(context, user),
          ),
        ],
      ),
    );
  }
}