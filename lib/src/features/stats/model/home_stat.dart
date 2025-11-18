import 'package:flutter/material.dart';

class HomeStat {
  const HomeStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
}

class StreakData {
  const StreakData({required this.days});

  final int days;
}

class AISuggestion {
  const AISuggestion({required this.message});

  final String message;
}

const streakData = StreakData(days: 3);

const aiSuggestion = AISuggestion(
  message:
      'You are less active yesterday, and based on past activity this week has been less active too',
);
