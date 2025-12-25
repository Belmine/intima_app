import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intima_app/core/constants/app_colors.dart';
import 'package:intima_app/core/constants/app_typography.dart';
import 'package:intima_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:intima_app/features/profile/presentation/widgets/profile_setup_form.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  int _currentStep = 0;
  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _completeSetup() {
    context.read<ProfileBloc>().add(const CompleteProfileSetupEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimationController.drive(
            Tween<double>(begin: 0.0, end: 1.0),
          ),
          child: Column(
            children: [
              // Progress Bar
              _buildProgressBar(),
              
              // Step Indicator
              _buildStepIndicator(),
              
              // PageView for Multi-Step Form
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                    _buildStep4(),
                  ],
                ),
              ),
              
              // Navigation Buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: (_currentStep + 1) / _totalSteps,
          minHeight: 8,
          backgroundColor: AppColors.lightGrey,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _totalSteps,
          (index) => Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index <= _currentStep
                  ? AppColors.primary
                  : AppColors.lightGrey,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: AppTypography.body1.copyWith(
                  color: index <= _currentStep
                      ? Colors.white
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep1() {
    return SlideTransition(
      position: _slideAnimationController.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us about yourself',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'Step 1 of $_totalSteps',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextInputField(
              label: 'First Name',
              hint: 'Enter your first name',
            ),
            const SizedBox(height: 20),
            _buildTextInputField(
              label: 'Last Name',
              hint: 'Enter your last name',
            ),
            const SizedBox(height: 20),
            _buildTextInputField(
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return SlideTransition(
      position: _slideAnimationController.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Details',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'Step 2 of $_totalSteps',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextInputField(
              label: 'Date of Birth',
              hint: 'MM/DD/YYYY',
            ),
            const SizedBox(height: 20),
            _buildDropdownField(
              label: 'Gender',
              options: ['Male', 'Female', 'Non-binary', 'Prefer not to say'],
            ),
            const SizedBox(height: 20),
            _buildTextInputField(
              label: 'Location',
              hint: 'Enter your city/country',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep3() {
    return SlideTransition(
      position: _slideAnimationController.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferences',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'Step 3 of $_totalSteps',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildBinaryChoice(
              question: 'Make your profile public?',
              onYesPressed: () {},
              onNoPressed: () {},
            ),
            const SizedBox(height: 24),
            _buildBinaryChoice(
              question: 'Receive notifications?',
              onYesPressed: () {},
              onNoPressed: () {},
            ),
            const SizedBox(height: 24),
            _buildBinaryChoice(
              question: 'Enable two-factor authentication?',
              onYesPressed: () {},
              onNoPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep4() {
    return SlideTransition(
      position: _slideAnimationController.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review & Confirm',
              style: AppTypography.heading1,
            ),
            const SizedBox(height: 8),
            Text(
              'Step 4 of $_totalSteps',
              style: AppTypography.body2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildReviewCard(
              title: 'Personal Information',
              items: const ['Name', 'Email', 'Date of Birth'],
            ),
            const SizedBox(height: 20),
            _buildReviewCard(
              title: 'Preferences',
              items: const ['Public Profile', 'Notifications', '2FA Enabled'],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your profile is ready! Click finish to complete setup.',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinaryChoice({
    required String question,
    required VoidCallback onYesPressed,
    required VoidCallback onNoPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: AppTypography.body1,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onYesPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Yes',
                  style: AppTypography.body1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: onNoPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'No',
                  style: AppTypography.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextInputField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.body2.copyWith(
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.body1.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String title,
    required List<String> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.body1.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: AppTypography.body2,
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goToPreviousStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Back',
                  style: AppTypography.body1.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _currentStep < _totalSteps - 1
                  ? _goToNextStep
                  : _completeSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _currentStep < _totalSteps - 1 ? 'Next' : 'Finish',
                style: AppTypography.body1.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
