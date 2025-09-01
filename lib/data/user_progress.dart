class UserProgress {
  final int totalXp;
  final int currentLevel;
  final List<String> unlockedAchievements;
  final int streakDays;
  final int totalActiveDays;
  final Map<String, int> activityCounts;
  final DateTime lastActiveDate;
  final DateTime joinDate;

  UserProgress({
    this.totalXp = 450, // Example starting XP
    this.currentLevel = 5,
    this.unlockedAchievements = const [
      'streak_7',
      'mindful_moments',
      'early_bird',
      'self_care_champion',
      'focus_master',
    ],
    this.streakDays = 7,
    this.totalActiveDays = 45,
    this.activityCounts = const {
      'mood_checks': 45,
      'journal_entries': 15,
      'breathing_exercises': 12,
      'habits_completed': 89,
      'focus_sessions': 25,
    },
    DateTime? lastActiveDate,
    DateTime? joinDate,
  }) : lastActiveDate = lastActiveDate ?? DateTime.now(),
       joinDate = joinDate ?? DateTime.now().subtract(const Duration(days: 45));

  UserProgress copyWith({
    int? totalXp,
    int? currentLevel,
    List<String>? unlockedAchievements,
    int? streakDays,
    int? totalActiveDays,
    Map<String, int>? activityCounts,
    DateTime? lastActiveDate,
    DateTime? joinDate,
  }) {
    return UserProgress(
      totalXp: totalXp ?? this.totalXp,
      currentLevel: currentLevel ?? this.currentLevel,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      streakDays: streakDays ?? this.streakDays,
      totalActiveDays: totalActiveDays ?? this.totalActiveDays,
      activityCounts: activityCounts ?? this.activityCounts,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  // Add XP and return new progress
  UserProgress addXp(int xp) {
    final newTotalXp = totalXp + xp;
    final newLevel = _calculateLevel(newTotalXp);
    
    return copyWith(
      totalXp: newTotalXp,
      currentLevel: newLevel,
    );
  }

  // Add achievement
  UserProgress addAchievement(String achievementId) {
    if (unlockedAchievements.contains(achievementId)) {
      return this;
    }
    
    final newAchievements = List<String>.from(unlockedAchievements)
      ..add(achievementId);
    
    return copyWith(unlockedAchievements: newAchievements);
  }

  // Update activity count
  UserProgress updateActivityCount(String activityType, {int increment = 1}) {
    final newCounts = Map<String, int>.from(activityCounts);
    newCounts[activityType] = (newCounts[activityType] ?? 0) + increment;
    
    return copyWith(activityCounts: newCounts);
  }

  // Update streak
  UserProgress updateStreak(int newStreak) {
    return copyWith(streakDays: newStreak);
  }

  // Get activity count
  int getActivityCount(String activityType) {
    return activityCounts[activityType] ?? 0;
  }

  // Calculate level from XP
  int _calculateLevel(int xp) {
    for (int level = 1; level <= 12; level++) {
      if (xp < level * 100) {
        return level - 1;
      }
    }
    return 12; // Max level
  }

  // Get XP progress in current level
  Map<String, dynamic> getCurrentLevelProgress() {
    final currentLevelXp = currentLevel * 100;
    final nextLevelXp = (currentLevel + 1) * 100;
    final xpInCurrentLevel = totalXp - currentLevelXp;
    final xpNeededForNext = nextLevelXp - currentLevelXp;
    final progress = currentLevel >= 12 ? 1.0 : xpInCurrentLevel / xpNeededForNext;

    return {
      'progress': progress.clamp(0.0, 1.0),
      'xpToNext': currentLevel >= 12 ? 0 : nextLevelXp - totalXp,
      'xpInCurrentLevel': xpInCurrentLevel,
      'xpNeededForNext': xpNeededForNext,
    };
  }
}
