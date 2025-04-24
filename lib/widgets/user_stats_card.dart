import '../models/user_model.dart';
import '../utils/app_enums.dart';
import '../utils/theme_constants.dart';
import 'package:flutter/material.dart';

class UserStatsCard extends StatelessWidget {
  final AppUser user;

  const UserStatsCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppTheme.darkBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // _buildUserHeader(),
          // const SizedBox(height: 8),
          // _buildHealthBar(),
          // const SizedBox(height: 4),
          // _buildExperienceBar(),
          // const SizedBox(height: 4),
          // _buildLevelAndCoins(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile picture with decorative elements
              Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.purple.shade300.withOpacity(0.5),
                          Colors.transparent,
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                  // Profile picture
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // gradient: LinearGradient(
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      //   colors: [
                      //     Colors.purple.shade100,
                      //     Colors.purple.shade200,
                      //   ],
                      // ),
                      border: Border.all(
                        color: Colors.deepPurple.shade300,
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _getProfileImagePath(user.gender), // This function will return the appropriate image path
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    // const Icon(
                    //   Icons.person_outline,
                    //   size: 45,
                    //   color: Colors.deepPurple,
                    // ),
                  ),
                  // Level badge
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade500,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${user.level}-р үе',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 20),

              // Stats column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Health Bar
                    _buildStatBar(
                      icon: Icons.favorite,
                      iconColor: AppTheme.healthRed,
                      value: user.healthPoint / 100,
                      valueColor: AppTheme.healthRed,
                      valueText: '${user.healthPoint}/100',
                      label: 'Амь',
                    ),

                    const SizedBox(height: 12),

                    // Experience Bar
                    _buildStatBar(
                      icon: Icons.star,
                      iconColor: AppTheme.expAmber,
                      value: user.expPoint / user.maxExp,
                      valueColor: AppTheme.expAmber,
                      valueText: '${user.expPoint}/${user.maxExp}',
                      label: 'Туршлага',
                    ),

                    const SizedBox(height: 12),

                    // Coins with animated background
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.coinOrange.withOpacity(0.8),
                                AppTheme.coinOrange.withOpacity(0.6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.coinOrange.withOpacity(0.3),
                                blurRadius:

                                6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${user.coin}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildStatBar({
    required IconData icon,
    required Color iconColor,
    required double value,
    required Color valueColor,
    required String valueText,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    valueText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  // Track
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Value
                  FractionallySizedBox(
                    widthFactor: value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            valueColor,
                            valueColor.withOpacity(0.7),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: valueColor.withOpacity(0.5),
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getProfileImagePath(Gender? gender) {
      switch (gender) {
        case Gender.male:
          return 'assets/images/male.jpg';
        case Gender.female:
          return 'assets/images/female.jpg';
        case Gender.other:
        case null:
          return 'assets/images/other.jpg';
    }
  }
}