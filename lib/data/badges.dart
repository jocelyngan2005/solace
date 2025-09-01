import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final AchievementCategory category;
  final int requirement;
  final bool isUnlocked;
  final DateTime? unlockedDate;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.color,
    required this.category,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedDate,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? emoji,
    Color? color,
    AchievementCategory? category,
    int? requirement,
    bool? isUnlocked,
    DateTime? unlockedDate,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      category: category ?? this.category,
      requirement: requirement ?? this.requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }
}

enum AchievementCategory {
  streak,
  mindfulness,
  wellness,
  academic,
  personal,
  milestone,
  challenge,
}

class AchievementData {
  static const List<Achievement> allAchievements = [
    // Streak Achievements
    Achievement(
      id: 'streak_3',
      title: 'Getting Started',
      description: 'Log your mood for 3 consecutive days',
      emoji: '🌱',
      color: Colors.green,
      category: AchievementCategory.streak,
      requirement: 3,
    ),
    Achievement(
      id: 'streak_7',
      title: '7-Day Streak',
      description: 'Complete daily check-ins for a week',
      emoji: '🔥',
      color: Colors.orange,
      category: AchievementCategory.streak,
      requirement: 7,
      isUnlocked: true,
    ),
    Achievement(
      id: 'streak_30',
      title: 'Month Warrior',
      description: 'Maintain a 30-day streak',
      emoji: '⚡',
      color: Colors.amber,
      category: AchievementCategory.streak,
      requirement: 30,
    ),
    Achievement(
      id: 'streak_100',
      title: 'Century Club',
      description: 'Reach 100 consecutive days',
      emoji: '💯',
      color: Colors.purple,
      category: AchievementCategory.streak,
      requirement: 100,
    ),

    // Mindfulness Achievements
    Achievement(
      id: 'mindful_first',
      title: 'First Steps',
      description: 'Complete your first breathing exercise',
      emoji: '🧘',
      color: Colors.blue,
      category: AchievementCategory.mindfulness,
      requirement: 1,
    ),
    Achievement(
      id: 'mindful_moments',
      title: 'Mindful Moments',
      description: 'Complete 10 breathing exercises',
      emoji: '🧘‍♀️',
      color: Colors.green,
      category: AchievementCategory.mindfulness,
      requirement: 10,
      isUnlocked: true,
    ),
    Achievement(
      id: 'meditation_master',
      title: 'Meditation Master',
      description: 'Spend 5 hours in mindfulness activities',
      emoji: '🕉️',
      color: Colors.indigo,
      category: AchievementCategory.mindfulness,
      requirement: 300, // 300 minutes = 5 hours
    ),
    Achievement(
      id: 'zen_warrior',
      title: 'Zen Warrior',
      description: 'Complete 50 mindfulness sessions',
      emoji: '☯️',
      color: Colors.teal,
      category: AchievementCategory.mindfulness,
      requirement: 50,
    ),

    // Wellness Achievements
    Achievement(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Log mood before 8 AM for 5 days',
      emoji: '🌅',
      color: Colors.blue,
      category: AchievementCategory.wellness,
      requirement: 5,
      isUnlocked: true,
    ),
    Achievement(
      id: 'sleep_champion',
      title: 'Sleep Champion',
      description: 'Get 8+ hours of sleep for a week',
      emoji: '😴',
      color: Colors.deepPurple,
      category: AchievementCategory.wellness,
      requirement: 7,
    ),
    Achievement(
      id: 'hydration_hero',
      title: 'Hydration Hero',
      description: 'Track water intake for 14 days',
      emoji: '💧',
      color: Colors.cyan,
      category: AchievementCategory.wellness,
      requirement: 14,
    ),
    Achievement(
      id: 'exercise_enthusiast',
      title: 'Exercise Enthusiast',
      description: 'Log 20 workout sessions',
      emoji: '💪',
      color: Colors.red,
      category: AchievementCategory.wellness,
      requirement: 20,
    ),

    // Academic Achievements
    Achievement(
      id: 'study_starter',
      title: 'Study Starter',
      description: 'Use focus techniques during study sessions',
      emoji: '📚',
      color: Colors.blue,
      category: AchievementCategory.academic,
      requirement: 1,
    ),
    Achievement(
      id: 'focus_master',
      title: 'Focus Master',
      description: 'Complete 25 focused study sessions',
      emoji: '🎯',
      color: Colors.red,
      category: AchievementCategory.academic,
      requirement: 25,
      isUnlocked: true,
    ),
    Achievement(
      id: 'productivity_pro',
      title: 'Productivity Pro',
      description: 'Track productive hours for 2 weeks',
      emoji: '⚡',
      color: Colors.yellow,
      category: AchievementCategory.academic,
      requirement: 14,
    ),
    Achievement(
      id: 'stress_slayer',
      title: 'Stress Slayer',
      description: 'Use stress management tools 15 times',
      emoji: '🗡️',
      color: Colors.purple,
      category: AchievementCategory.academic,
      requirement: 15,
    ),

    // Personal Growth Achievements
    Achievement(
      id: 'self_care_champion',
      title: 'Self-Care Champion',
      description: 'Practice self-care activities for 2 weeks',
      emoji: '💙',
      color: Colors.purple,
      category: AchievementCategory.personal,
      requirement: 14,
      isUnlocked: true,
    ),
    Achievement(
      id: 'journal_keeper',
      title: 'Journal Keeper',
      description: 'Write 20 journal entries',
      emoji: '📝',
      color: Colors.brown,
      category: AchievementCategory.personal,
      requirement: 20,
    ),
    Achievement(
      id: 'reflection_master',
      title: 'Reflection Master',
      description: 'Complete 30 self-reflection sessions',
      emoji: '🪞',
      color: Colors.teal,
      category: AchievementCategory.personal,
      requirement: 30,
    ),
    Achievement(
      id: 'gratitude_guru',
      title: 'Gratitude Guru',
      description: 'Practice gratitude for 21 days',
      emoji: '🙏',
      color: Colors.amber,
      category: AchievementCategory.personal,
      requirement: 21,
    ),

    // Challenge Achievements
    Achievement(
      id: 'breath_master',
      title: 'Breath Master',
      description: 'Complete the Daily Breathing Practice challenge',
      emoji: '🧘‍♀️',
      color: Colors.teal,
      category: AchievementCategory.challenge,
      requirement: 1,
    ),
    Achievement(
      id: 'sleep_champion',
      title: 'Sleep Champion',
      description: 'Complete the Sleep Schedule Master challenge',
      emoji: '😴',
      color: Colors.indigo,
      category: AchievementCategory.challenge,
      requirement: 1,
    ),
    Achievement(
      id: 'hydration_hero',
      title: 'Hydration Hero',
      description: 'Complete the Hydration Hero challenge',
      emoji: '💧',
      color: Colors.blue,
      category: AchievementCategory.challenge,
      requirement: 1,
    ),
    Achievement(
      id: 'productivity_master',
      title: 'Productivity Master',
      description: 'Complete the Pomodoro Productivity challenge',
      emoji: '🍅',
      color: Colors.red,
      category: AchievementCategory.challenge,
      requirement: 1,
    ),
    Achievement(
      id: 'social_butterfly',
      title: 'Social Butterfly',
      description: 'Complete the Social Connection Week challenge',
      emoji: '🤝',
      color: Colors.pink,
      category: AchievementCategory.challenge,
      requirement: 1,
    ),
    Achievement(
      id: 'creative_soul',
      title: 'Creative Soul',
      description: 'Complete the Daily Creative Expression challenge',
      emoji: '🎨',
      color: Colors.purple,
      category: AchievementCategory.challenge,
      requirement: 1,
    ),
    Achievement(
      id: 'challenge_starter',
      title: 'Challenge Starter',
      description: 'Start your first weekly challenge',
      emoji: '🚀',
      color: Colors.orange,
      category: AchievementCategory.milestone,
      requirement: 1,
    ),
    Achievement(
      id: 'challenge_champion',
      title: 'Challenge Champion',
      description: 'Complete 5 weekly challenges',
      emoji: '🏅',
      color: Colors.amber,
      category: AchievementCategory.milestone,
      requirement: 5,
    ),
    Achievement(
      id: 'challenge_legend',
      title: 'Challenge Legend',
      description: 'Complete 10 weekly challenges',
      emoji: '👑',
      color: Colors.deepPurple,
      category: AchievementCategory.milestone,
      requirement: 10,
    ),

    // Milestone Achievements
    Achievement(
      id: 'first_week',
      title: 'First Week Complete',
      description: 'Successfully complete your first week',
      emoji: '🎉',
      color: Colors.green,
      category: AchievementCategory.milestone,
      requirement: 1,
    ),
    Achievement(
      id: 'month_milestone',
      title: 'One Month Strong',
      description: 'Active for 30 days',
      emoji: '🏆',
      color: Colors.amber,
      category: AchievementCategory.milestone,
      requirement: 30,
    ),
    Achievement(
      id: 'quarter_champion',
      title: 'Quarter Champion',
      description: 'Active for 90 days',
      emoji: '👑',
      color: Colors.purple,
      category: AchievementCategory.milestone,
      requirement: 90,
    ),
    Achievement(
      id: 'year_legend',
      title: 'Year Legend',
      description: 'Complete a full year of wellness',
      emoji: '🌟',
      color: Colors.deepPurple,
      category: AchievementCategory.milestone,
      requirement: 365,
    ),
  ];

  static List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return allAchievements.where((achievement) => achievement.category == category).toList();
  }

  static List<Achievement> getUnlockedAchievements() {
    return allAchievements.where((achievement) => achievement.isUnlocked).toList();
  }

  static List<Achievement> getLockedAchievements() {
    return allAchievements.where((achievement) => !achievement.isUnlocked).toList();
  }

  static int getTotalAchievements() => allAchievements.length;

  static int getUnlockedCount() => getUnlockedAchievements().length;

  static double getCompletionPercentage() {
    return (getUnlockedCount() / getTotalAchievements()) * 100;
  }

  static String getCategoryName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.streak:
        return 'Streaks';
      case AchievementCategory.mindfulness:
        return 'Mindfulness';
      case AchievementCategory.wellness:
        return 'Wellness';
      case AchievementCategory.academic:
        return 'Academic';
      case AchievementCategory.personal:
        return 'Personal Growth';
      case AchievementCategory.milestone:
        return 'Milestones';
      case AchievementCategory.challenge:
        return 'Challenges';
    }
  }

  static String getCategoryEmoji(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.streak:
        return '🔥';
      case AchievementCategory.mindfulness:
        return '🧘';
      case AchievementCategory.wellness:
        return '💪';
      case AchievementCategory.academic:
        return '📚';
      case AchievementCategory.personal:
        return '🌱';
      case AchievementCategory.milestone:
        return '🏆';
      case AchievementCategory.challenge:
        return '🎯';
    }
  }
}
