import '../../data/badges.dart';

class GamificationService {
  static const Map<int, String> levelTitles = {
    1: 'Wellness Beginner',
    2: 'Mindful Student',
    3: 'Self-Care Apprentice',
    4: 'Wellness Seeker',
    5: 'Wellness Explorer',
    6: 'Mindfulness Practitioner',
    7: 'Self-Care Specialist',
    8: 'Wellness Advocate',
    9: 'Mindfulness Master',
    10: 'Wellness Guru',
    11: 'Mental Health Champion',
    12: 'Wellness Legend',
  };

  static const Map<String, int> xpRewards = {
    'mood_check': 10,
    'journal_entry': 15,
    'breathing_exercise': 20,
    'habit_completed': 5,
    'challenge_completed': 50,
    'streak_milestone': 25,
    'achievement_unlocked': 100,
    'mini_game_completed': 15,
    'focus_session': 30,
    'wellness_activity': 20,
  };

  // Calculate required XP for a given level
  static int getXpRequiredForLevel(int level) {
    return level * 100; // Simple formula: Level 1 = 100 XP, Level 2 = 200 XP, etc.
  }

  // Calculate level from total XP
  static int getLevelFromXp(int totalXp) {
    for (int level = 1; level <= 12; level++) {
      if (totalXp < getXpRequiredForLevel(level)) {
        return level - 1;
      }
    }
    return 12; // Max level
  }

  // Get level title
  static String getLevelTitle(int level) {
    return levelTitles[level] ?? 'Wellness Enthusiast';
  }

  // Calculate XP progress towards next level
  static Map<String, dynamic> getProgressToNextLevel(int totalXp) {
    final currentLevel = getLevelFromXp(totalXp);
    final nextLevel = currentLevel + 1;
    
    if (nextLevel > 12) {
      return {
        'currentLevel': currentLevel,
        'nextLevel': null,
        'currentLevelXp': totalXp,
        'nextLevelXp': null,
        'progress': 1.0,
        'xpToNext': 0,
      };
    }

    final currentLevelXp = currentLevel > 0 ? getXpRequiredForLevel(currentLevel) : 0;
    final nextLevelXp = getXpRequiredForLevel(nextLevel);
    final xpInCurrentLevel = totalXp - currentLevelXp;
    final xpNeededForNext = nextLevelXp - currentLevelXp;
    final progress = xpInCurrentLevel / xpNeededForNext;

    return {
      'currentLevel': currentLevel,
      'nextLevel': nextLevel,
      'currentLevelXp': currentLevelXp,
      'nextLevelXp': nextLevelXp,
      'progress': progress.clamp(0.0, 1.0),
      'xpToNext': nextLevelXp - totalXp,
      'xpInCurrentLevel': xpInCurrentLevel,
      'xpNeededForNext': xpNeededForNext,
    };
  }

  // Check if user should unlock achievements based on activity
  static List<Achievement> checkForUnlockedAchievements({
    required String activityType,
    required int count,
    required int streakDays,
    required int totalDays,
  }) {
    final List<Achievement> newlyUnlocked = [];

    for (final achievement in AchievementData.allAchievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        // Streak achievements
        case 'streak_3':
          shouldUnlock = streakDays >= 3;
          break;
        case 'streak_7':
          shouldUnlock = streakDays >= 7;
          break;
        case 'streak_30':
          shouldUnlock = streakDays >= 30;
          break;
        case 'streak_100':
          shouldUnlock = streakDays >= 100;
          break;

        // Activity-based achievements
        case 'mindful_first':
          shouldUnlock = activityType == 'breathing_exercise' && count >= 1;
          break;
        case 'mindful_moments':
          shouldUnlock = activityType == 'breathing_exercise' && count >= 10;
          break;
        case 'journal_keeper':
          shouldUnlock = activityType == 'journal_entry' && count >= 20;
          break;
        case 'early_bird':
          shouldUnlock = activityType == 'early_mood_check' && count >= 5;
          break;

        // Milestone achievements
        case 'first_week':
          shouldUnlock = totalDays >= 7;
          break;
        case 'month_milestone':
          shouldUnlock = totalDays >= 30;
          break;
        case 'quarter_champion':
          shouldUnlock = totalDays >= 90;
          break;
        case 'year_legend':
          shouldUnlock = totalDays >= 365;
          break;
      }

      if (shouldUnlock) {
        newlyUnlocked.add(achievement.copyWith(
          isUnlocked: true,
          unlockedDate: DateTime.now(),
        ));
      }
    }

    return newlyUnlocked;
  }

  // Get XP reward for activity
  static int getXpForActivity(String activityType) {
    return xpRewards[activityType] ?? 0;
  }

  // Calculate bonus XP for achievements
  static int getBonusXpForAchievements(List<Achievement> achievements) {
    return achievements.length * (xpRewards['achievement_unlocked'] ?? 100);
  }

  // Get motivational message for level up
  static String getLevelUpMessage(int newLevel) {
    switch (newLevel) {
      case 2:
        return "Great job! You're building healthy habits! 🌱";
      case 3:
        return "You're becoming more mindful every day! 🧘‍♀️";
      case 4:
        return "Your dedication to wellness is inspiring! ✨";
      case 5:
        return "You're exploring new ways to care for yourself! 🗺️";
      case 6:
        return "Your mindfulness practice is getting stronger! 💪";
      case 7:
        return "You're a specialist at self-care now! 🎯";
      case 8:
        return "You're advocating for your mental health! 📢";
      case 9:
        return "You've mastered the art of mindfulness! 🏆";
      case 10:
        return "You're a wellness guru! Share your wisdom! 🧙‍♀️";
      default:
        return "Congratulations on reaching level $newLevel! 🎉";
    }
  }

  // Get achievement unlock message
  static String getAchievementUnlockMessage(Achievement achievement) {
    return "🎉 Achievement Unlocked: ${achievement.emoji} ${achievement.title}!";
  }
}
