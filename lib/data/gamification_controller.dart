import 'dart:async';
import 'package:flutter/material.dart';
import 'badges.dart';
import 'user_progress.dart';
import 'gamification_service.dart';
import '../widgets/animations/achievement_unlock_animation.dart';

class GamificationController {
  static final GamificationController _instance = GamificationController._internal();
  factory GamificationController() => _instance;
  GamificationController._internal();

  UserProgress? _userProgress;

  // Initialize with user progress
  void initialize(UserProgress userProgress) {
    _userProgress = userProgress;
  }

  // Process activity and check for achievements/level ups
  Future<ActivityResult> processActivity({
    required BuildContext context,
    required String activityType,
    int xpGained = 0,
    Map<String, dynamic>? activityData,
  }) async {
    if (_userProgress == null) return ActivityResult();

    // Add XP
    final oldLevel = _userProgress!.currentLevel;
    final oldXp = _userProgress!.totalXp;
    
    // Calculate XP if not provided
    if (xpGained == 0) {
      xpGained = GamificationService.getXpForActivity(activityType);
    }

    _userProgress = _userProgress!.addXp(xpGained);
    
    // Update activity count
    _userProgress = _userProgress!.updateActivityCount(activityType);

    // Check for new achievements
    final newAchievements = _checkForNewAchievements(activityType);
    
    // Update unlocked achievements
    for (final achievement in newAchievements) {
      _userProgress = _userProgress!.addAchievement(achievement.id);
    }

    // Check for level up
    final newLevel = _userProgress!.currentLevel;
    final leveledUp = newLevel > oldLevel;

    // Show animations
    if (newAchievements.isNotEmpty) {
      await _showAchievementAnimations(context, newAchievements);
    }

    if (leveledUp) {
      await _showLevelUpAnimation(context, newLevel);
    }

    return ActivityResult(
      xpGained: _userProgress!.totalXp - oldXp,
      newLevel: leveledUp ? newLevel : null,
      newAchievements: newAchievements,
      userProgress: _userProgress!,
    );
  }

  // Check for newly unlocked achievements
  List<Achievement> _checkForNewAchievements(String activityType) {
    if (_userProgress == null) return [];

    final newlyUnlocked = <Achievement>[];
    
    for (final achievement in AchievementData.allAchievements) {
      // Skip if already unlocked
      if (_userProgress!.unlockedAchievements.contains(achievement.id)) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        // Streak achievements
        case 'streak_3':
          shouldUnlock = _userProgress!.streakDays >= 3;
          break;
        case 'streak_7':
          shouldUnlock = _userProgress!.streakDays >= 7;
          break;
        case 'streak_30':
          shouldUnlock = _userProgress!.streakDays >= 30;
          break;
        case 'streak_100':
          shouldUnlock = _userProgress!.streakDays >= 100;
          break;

        // Activity-based achievements
        case 'mindful_first':
          shouldUnlock = activityType == 'breathing_exercise' && 
                        _userProgress!.getActivityCount('breathing_exercises') >= 1;
          break;
        case 'mindful_moments':
          shouldUnlock = _userProgress!.getActivityCount('breathing_exercises') >= 10;
          break;
        case 'journal_keeper':
          shouldUnlock = _userProgress!.getActivityCount('journal_entries') >= 20;
          break;
        case 'early_bird':
          shouldUnlock = _userProgress!.getActivityCount('early_mood_checks') >= 5;
          break;
        case 'focus_master':
          shouldUnlock = _userProgress!.getActivityCount('focus_sessions') >= 25;
          break;

        // Milestone achievements
        case 'first_week':
          shouldUnlock = _userProgress!.totalActiveDays >= 7;
          break;
        case 'month_milestone':
          shouldUnlock = _userProgress!.totalActiveDays >= 30;
          break;
        case 'quarter_champion':
          shouldUnlock = _userProgress!.totalActiveDays >= 90;
          break;
        case 'year_legend':
          shouldUnlock = _userProgress!.totalActiveDays >= 365;
          break;
      }

      if (shouldUnlock) {
        newlyUnlocked.add(achievement);
      }
    }

    return newlyUnlocked;
  }

  // Show achievement unlock animations
  Future<void> _showAchievementAnimations(BuildContext context, List<Achievement> achievements) async {
    for (final achievement in achievements) {
      await _showSingleAchievementAnimation(context, achievement);
    }
  }

  // Show single achievement animation
  Future<void> _showSingleAchievementAnimation(BuildContext context, Achievement achievement) async {
    final completer = Completer<void>();
    
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          AchievementUnlockAnimation(
            badgeTitle: achievement.title,
            badgeEmoji: achievement.emoji,
            badgeColor: achievement.color,
            onComplete: () {
              Navigator.of(context).pop();
              completer.complete();
            },
          ),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: const Duration(milliseconds: 300),
        opaque: false,
      ),
    );

    return completer.future;
  }

  // Show level up animation (placeholder for now)
  Future<void> _showLevelUpAnimation(BuildContext context, int newLevel) async {
    // For now, just show a simple dialog
    // TODO: Implement full level up animation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Level Up!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Congratulations! You reached level $newLevel!'),
            const SizedBox(height: 8),
            Text(
              GamificationService.getLevelTitle(newLevel),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Get current user progress
  UserProgress? get userProgress => _userProgress;

  // Simulate completing an activity (for testing)
  Future<ActivityResult> completeActivity(BuildContext context, String activityType) async {
    return processActivity(
      context: context,
      activityType: activityType,
    );
  }

  // Add streak day
  void addStreakDay() {
    if (_userProgress != null) {
      _userProgress = _userProgress!.updateStreak(_userProgress!.streakDays + 1);
    }
  }

  // Reset streak
  void resetStreak() {
    if (_userProgress != null) {
      _userProgress = _userProgress!.updateStreak(0);
    }
  }
}

class ActivityResult {
  final int xpGained;
  final int? newLevel;
  final List<Achievement> newAchievements;
  final UserProgress? userProgress;

  ActivityResult({
    this.xpGained = 0,
    this.newLevel,
    this.newAchievements = const [],
    this.userProgress,
  });

  bool get hasRewards => xpGained > 0 || newLevel != null || newAchievements.isNotEmpty;
}

// Extension to make it easier to use
extension BuildContextGamification on BuildContext {
  GamificationController get gamification => GamificationController();
}
