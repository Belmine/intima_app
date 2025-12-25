import 'package:flutter/material.dart';

/// Palette de couleurs de l'application Intima
class AppColors {
  // Couleurs principales
  static const Color primary = Color(0xFF6B4CE6);
  static const Color primaryLight = Color(0xFF8B6CE8);
  static const Color primaryDark = Color(0xFF4B2CC6);
  
  // Couleurs secondaires
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color tertiary = Color(0xFF4ECDC4);
  static const Color accent = Color(0xFFFFA94D);
  
  // Couleurs de fond
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFBFBFC);
  
  // Couleurs de texte
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFF95A5A6);
  static const Color textWhite = Colors.white;
  
  // Couleurs d'état
  static const Color success = Color(0xFF00B894);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color info = Color(0xFF74B9FF);
  
  // Couleurs par catégorie (pour les cartes de contenu)
  static const Color categoryPuberty = Color(0xFFFF6B9D);
  static const Color categoryContraception = Color(0xFF6B4CE6);
  static const Color categoryIST = Color(0xFF4ECDC4);
  static const Color categorySexuality = Color(0xFFFFA94D);
  static const Color categoryPregnancy = Color(0xFFFF8585);
  static const Color categoryMenstruation = Color(0xFFB565D8);
  
  // Dégradés
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFFFF8AB0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Ombres
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}