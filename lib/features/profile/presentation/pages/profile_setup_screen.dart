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
  late PageController _pageController;
  int _currentStep = 0;
  
  // Réponses
  String?   _selectedAgeRange;
  bool?   _hasFirstPeriod;
  bool?  _hasMenopause;

  final List<String> _ageRanges = [
    '10-14 ans',
    '15-17 ans',
    '18-24 ans',
    '25-34 ans',
    '35-44 ans',
    '45+ ans',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _canContinue {
    switch (_currentStep) {
      case 0:
        return _selectedAgeRange != null;
      case 1:
        return _hasFirstPeriod != null;
      case 2:
        return _hasMenopause != null;
      default:  
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves. easeInOut,
      );
    } else {
      _saveProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _saveProfile() {
    final profile = UserProfile(
      ageRange: _selectedAgeRange!,
      hasFirstPeriod: _hasFirstPeriod!,
      hasMenopause: _hasMenopause!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✨ Profil configuré avec succès !'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // TODO: Navigation vers Home
        // context.go('/home');
      }
    });
  }

  void _skipProfileSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Passer cette étape ?'),
        content: const Text(
          'Tu pourras configurer ton profil plus tard pour une meilleure expérience personnalisée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continuer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to Home
            },
            child: const Text('Passer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec progress bar et skip button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skip button en haut
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed:  _skipProfileSetup,
                      child: Text(
                        'Passer',
                        style: Theme.of(context).textTheme.bodyLarge?. copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Titre
                  Text(
                    'Parle-nous de toi',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Sous-titre
                  Text(
                    'Pour te proposer un contenu adapté à tes besoins',
                    style:  Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_currentStep + 1) / 3,
                      minHeight: 6,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Étape courante
                  Text(
                    'Étape ${_currentStep + 1}/3',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Contenu des étapes
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  // Étape 1 :  Âge
                  _buildAgeStep(),
                  
                  // Étape 2 : Première menstruation
                  _buildFirstPeriodStep(),
                  
                  // Étape 3 : Ménopause
                  _buildMenopauseStep(),
                ],
              ),
            ),
            
            // Boutons d'action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Row(
                children: [
                  // Bouton Retour
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Retour'),
                      ),
                    ),
                  
                  if (_currentStep > 0) const SizedBox(width: 12),
                  
                  // Bouton Suivant/Terminer
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canContinue ? _nextStep :  null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        _currentStep < 2 ? 'Suivant' : 'Terminer',
                        style: const TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildAgeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          // Icône
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors. secondary. withOpacity(0.1),
              ),
              child:  const Icon(
                Icons.cake_outlined,
                size: 40,
                color: AppColors. secondary,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Titre
          Text(
            'Quelle est ta tranche d\'âge ?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Options d'âge en grille
          ..._ageRanges.map((age) {
            final isSelected = _selectedAgeRange == age;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAgeRange = age;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected ? AppColors.secondary. withOpacity(0.1) : AppColors.surface,
                    border: Border.all(
                      color: isSelected ? AppColors.secondary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors. secondary : AppColors.textLight,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                          Icons.check,
                          size: 14,
                          color: AppColors.secondary,
                        )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        age,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight. normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFirstPeriodStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          // Icône
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape. circle,
                color: AppColors.categoryMenstruation. withOpacity(0.1),
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 40,
                color: AppColors.categoryMenstruation,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Titre
          Text(
            'As-tu eu tes premières règles ?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Sous-titre
          Text(
            'Cela nous aidera à adapter les informations',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 48),
          
          // Boutons Oui/Non (taille réduite)
          Row(
            children: [
              Expanded(
                child: _buildYesNoButton(
                  label: 'Oui',
                  icon: Icons.check_circle_outline,
                  isSelected: _hasFirstPeriod == true,
                  onTap: () {
                    setState(() {
                      _hasFirstPeriod = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildYesNoButton(
                  label: 'Non',
                  icon: Icons.cancel_outlined,
                  isSelected: _hasFirstPeriod == false,
                  onTap: () {
                    setState(() {
                      _hasFirstPeriod = false;
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenopauseStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          // Icône
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.tertiary.withOpacity(0.1),
              ),
              child: const Icon(
                Icons. wb_sunny_outlined,
                size: 40,
                color: AppColors. tertiary,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Titre
          Text(
            'Es-tu en ménopause ou en péri-ménopause ?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign:  TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Sous-titre
          Text(
            'Sans jugement, c\'est juste pour te conseiller au mieux',
            style: Theme. of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 48),
          
          // Boutons Oui/Non (taille réduite)
          Row(
            children: [
              Expanded(
                child: _buildYesNoButton(
                  label: 'Oui',
                  icon: Icons. check_circle_outline,
                  isSelected: _hasMenopause == true,
                  onTap: () {
                    setState(() {
                      _hasMenopause = true;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildYesNoButton(
                  label: 'Non',
                  icon:  Icons.cancel_outlined,
                  isSelected: _hasMenopause == false,
                  onTap: () {
                    setState(() {
                      _hasMenopause = false;
                    });
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildYesNoButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.primary. withOpacity(0.1) : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors. primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ?  AppColors.primary : AppColors. textLight. withOpacity(0.2),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ?  Colors.white : AppColors.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style:  Theme.of(context).textTheme.labelLarge?.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight:  isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}