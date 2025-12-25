import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/models/user_profile.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _selectedAgeRange;
  bool? _hasFirstPeriod;
  bool? _hasMenopause;

  bool get _canContinue {
    return _selectedAgeRange != null &&
        _hasFirstPeriod != null &&
        _hasMenopause != null;
  }

  void _saveProfile() {
    if (!_canContinue) return;

    final profile = UserProfile(
      ageRange: _selectedAgeRange!,
      hasFirstPeriod: _hasFirstPeriod!,
      hasMenopause: _hasMenopause!,
    );

    print('Profil créé: $profile');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profil configuré avec succès !'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // TODO: Navigation vers Home
      }
    });
  }

  void _skipStep() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Configuration ignorée'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          AppStrings.profileSetupTitle,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                
                // Description
                Text(
                  AppStrings.profileSetupDesc,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                ),
                
                const SizedBox(height: 32),
                
                // Question 1: Âge avec dropdown élégant
                _buildQuestionCard(
                  icon: Icons.cake_outlined,
                  iconColor: AppColors.secondary,
                  title: AppStrings.questionAge,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedAgeRange != null
                            ? AppColors.primary.withOpacity(0.3)
                            : Colors.grey.shade300,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedAgeRange,
                        hint: Text(
                          'Sélectionne ta tranche d\'âge',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 15,
                          ),
                        ),
                        isExpanded: true,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.primary,
                        ),
                        items: AppStrings.ageRanges.map((String age) {
                          return DropdownMenuItem<String>(
                            value: age,
                            child: Text(
                              age,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedAgeRange = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Question 2: Premières règles
                _buildQuestionCard(
                  icon: Icons.water_drop_outlined,
                  iconColor: AppColors.categoryMenstruation,
                  title: AppStrings.questionFirstPeriod,
                  subtitle: 'Avez-vous déjà eu vos premières règles ?',
                  child: _buildToggleOption(
                    value: _hasFirstPeriod,
                    onChanged: (value) {
                      setState(() {
                        _hasFirstPeriod = value;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Question 3: Ménopause
                _buildQuestionCard(
                  icon: Icons.spa_outlined,
                  iconColor: AppColors.tertiary,
                  title: AppStrings.questionMenopause,
                  subtitle: 'Êtes-vous en période de ménopause ou post-ménopause ?',
                  child: _buildToggleOption(
                    value: _hasMenopause,
                    onChanged: (value) {
                      setState(() {
                        _hasMenopause = value;
                      });
                    },
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Bouton Continuer
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canContinue ? _saveProfile : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: _canContinue ? 2 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.continueButton,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _canContinue ? Colors.white : Colors.grey.shade500,
                          ),
                        ),
                        if (_canContinue) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                        ],
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Bouton Passer cette étape
                Center(
                  child: TextButton(
                    onPressed: _skipStep,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      AppStrings.skipStep,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required bool? value,
    required Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: value == true
                    ? AppColors.primary.withOpacity(0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: value == true
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (value == true)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  if (value == true) const SizedBox(width: 8),
                  Text(
                    AppStrings.yes,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: value == true
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: value == false
                    ? AppColors.textSecondary.withOpacity(0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: value == false
                      ? AppColors.textSecondary
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (value == false)
                    Icon(
                      Icons.check_circle,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  if (value == false) const SizedBox(width: 8),
                  Text(
                    AppStrings.no,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: value == false
                          ? AppColors.textSecondary
                          : AppColors.textSecondary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}