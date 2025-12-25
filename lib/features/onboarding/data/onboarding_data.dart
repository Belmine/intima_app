import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Modèle de données pour une page d'onboarding
class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

/// Liste des pages d'onboarding
class OnboardingData {
  static final List<OnboardingPageData> pages = [
    const OnboardingPageData(
      icon: Icons.favorite_border,
      title: 'Bienvenue sur Intima',
      description: 'Ton espace confidentiel pour toutes tes questions sur la santé sexuelle et reproductive.',
      color: AppColors.secondary,
    ),
    const OnboardingPageData(
      icon: Icons.chat_bubble_outline,
      title: 'Ta Grande Sœur',
      description: 'Pose toutes tes questions sans jugement. Je suis là pour t\'aider avec des informations fiables.',
      color: AppColors.primary,
    ),
    const OnboardingPageData(
      icon: Icons.lock_outline,
      title: 'Totalement Confidentiel',
      description: 'Aucune donnée personnelle n\'est collectée. Ton anonymat est notre priorité.',
      color: AppColors.tertiary,
    ),
  ];
}