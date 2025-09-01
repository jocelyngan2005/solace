import 'package:flutter/material.dart';
import 'weekly_challenges.dart';
import 'gamification_controller.dart';

class WeeklyChallengeService {

  static WeeklyChallengeService? _instance;
  
  factory WeeklyChallengeService() {
    _instance ??= WeeklyChallengeService._internal();
    return _instance!;
  }
  
  WeeklyChallengeService._internal();

  final Map<String, WeeklyChallenge> _activeChallenges = {};
  final Map<String, WeeklyChallenge> _completedChallenges = {};
  final Map<String, int> _challengeProgress = {};

  // Initialize service
  Future<void> initialize() async {
    await _loadData();
    _checkExpiredChallenges();
  }

  // Start a new challenge
  Future<bool> startChallenge(String challengeId) async {
    final challenge = WeeklyChallengeData.getChallengeById(challengeId);
    if (challenge == null) return false;

    // Check if already active
    if (_activeChallenges.containsKey(challengeId)) return false;

    // Check if user has too many active challenges (max 3)
    if (_activeChallenges.length >= 3) return false;

    final now = DateTime.now();
    final startedChallenge = challenge.copyWith(
      status: ChallengeStatus.inProgress,
      startDate: now,
      endDate: now.add(Duration(days: challenge.durationDays)),
      currentProgress: 0,
    );

    _activeChallenges[challengeId] = startedChallenge;
    _challengeProgress[challengeId] = 0;
    
    await _saveData();
    return true;
  }

  // Update challenge progress
  Future<ChallengeProgressResult> updateProgress(
    String challengeId, {
    int increment = 1,
    BuildContext? context,
  }) async {
    if (!_activeChallenges.containsKey(challengeId)) {
      return ChallengeProgressResult(success: false);
    }

    final challenge = _activeChallenges[challengeId]!;
    if (challenge.isExpired || challenge.isCompleted) {
      return ChallengeProgressResult(success: false);
    }

    final newProgress = (challenge.currentProgress + increment)
        .clamp(0, challenge.targetCount);
    
    final updatedChallenge = challenge.copyWith(
      currentProgress: newProgress,
    );

    _activeChallenges[challengeId] = updatedChallenge;
    _challengeProgress[challengeId] = newProgress;

    // Check if challenge is completed
    if (newProgress >= challenge.targetCount) {
      await _completeChallenge(challengeId, context);
      return ChallengeProgressResult(
        success: true,
        progressUpdated: true,
        challengeCompleted: true,
        challenge: updatedChallenge,
      );
    }

    await _saveData();
    return ChallengeProgressResult(
      success: true,
      progressUpdated: true,
      challengeCompleted: false,
      challenge: updatedChallenge,
    );
  }

  // Complete a challenge
  Future<void> _completeChallenge(String challengeId, BuildContext? context) async {
    final challenge = _activeChallenges[challengeId];
    if (challenge == null) return;

    final completedChallenge = challenge.copyWith(
      status: ChallengeStatus.completed,
      currentProgress: challenge.targetCount,
    );

    // Move from active to completed
    _activeChallenges.remove(challengeId);
    _completedChallenges[challengeId] = completedChallenge;

    // Award XP and potentially unlock badge
    if (context != null) {
      final gamificationController = GamificationController();
      await gamificationController.processActivity(
        context: context,
        activityType: 'challenge_completed',
        xpGained: challenge.xpReward,
        activityData: {
          'challengeId': challengeId,
          'challengeType': challenge.type.toString(),
        },
      );
    }

    await _saveData();
  }

  // Abandon/quit a challenge
  Future<bool> abandonChallenge(String challengeId) async {
    if (!_activeChallenges.containsKey(challengeId)) return false;

    _activeChallenges.remove(challengeId);
    _challengeProgress.remove(challengeId);
    
    await _saveData();
    return true;
  }

  // Get available challenges (not started and not completed)
  List<WeeklyChallenge> getAvailableChallenges() {
    final available = <WeeklyChallenge>[];
    
    for (final challenge in WeeklyChallengeData.allChallenges) {
      // Skip if already active or completed
      if (_activeChallenges.containsKey(challenge.id) ||
          _completedChallenges.containsKey(challenge.id)) {
        continue;
      }
      
      available.add(challenge);
    }
    
    return available;
  }

  // Get active challenges
  List<WeeklyChallenge> getActiveChallenges() {
    return _activeChallenges.values.toList();
  }

  // Get completed challenges
  List<WeeklyChallenge> getCompletedChallenges() {
    return _completedChallenges.values.toList();
  }

  // Get specific challenge by ID
  WeeklyChallenge? getChallenge(String challengeId) {
    return _activeChallenges[challengeId] ?? 
           _completedChallenges[challengeId] ??
           WeeklyChallengeData.getChallengeById(challengeId);
  }

  // Get current week's featured challenge
  WeeklyChallenge? getFeaturedChallenge() {
    // Rotate featured challenge based on week number
    final weekNumber = DateTime.now().millisecondsSinceEpoch ~/ (7 * 24 * 60 * 60 * 1000);
    final challenges = getAvailableChallenges();
    if (challenges.isEmpty) return null;
    
    return challenges[weekNumber % challenges.length];
  }

  // Get challenge statistics
  Map<String, dynamic> getStatistics() {
    final totalChallenges = WeeklyChallengeData.allChallenges.length;
    final completedCount = _completedChallenges.length;
    final activeCount = _activeChallenges.length;
    
    int totalXpEarned = 0;
    for (final challenge in _completedChallenges.values) {
      totalXpEarned += challenge.xpReward;
    }

    return {
      'totalChallenges': totalChallenges,
      'completedChallenges': completedCount,
      'activeChallenges': activeCount,
      'completionRate': totalChallenges > 0 ? completedCount / totalChallenges : 0.0,
      'totalXpEarned': totalXpEarned,
      'averageXpPerChallenge': completedCount > 0 ? totalXpEarned / completedCount : 0,
    };
  }

  // Update task completion for a challenge
  Future<bool> updateTaskCompletion(String challengeId, String taskId, bool isCompleted) async {
    final challenge = _activeChallenges[challengeId];
    if (challenge == null) return false;

    final updatedTasks = challenge.tasks.map((task) {
      if (task.id == taskId) {
        return task.copyWith(
          isCompleted: isCompleted,
          completedDate: isCompleted ? DateTime.now() : null,
        );
      }
      return task;
    }).toList();

    final updatedChallenge = challenge.copyWith(tasks: updatedTasks);
    _activeChallenges[challengeId] = updatedChallenge;
    
    await _saveData();
    return true;
  }

  // Check for expired challenges
  void _checkExpiredChallenges() {
    final expiredIds = <String>[];
    
    for (final entry in _activeChallenges.entries) {
      if (entry.value.isExpired) {
        expiredIds.add(entry.key);
      }
    }

    for (final id in expiredIds) {
      _activeChallenges.remove(id);
      // Could optionally save expired challenges separately
    }

    if (expiredIds.isNotEmpty) {
      _saveData();
    }
  }

  // Save data to memory (simplified for now)
  Future<void> _saveData() async {
    // TODO: Implement persistent storage when needed
    // For now, data persists only during app session
  }

  // Load data from memory (simplified for now)
  Future<void> _loadData() async {
    // TODO: Implement persistent loading when needed
    // For now, start with empty data each session
  }

  // Clear all data (for testing or reset)
  Future<void> clearAllData() async {
    _activeChallenges.clear();
    _completedChallenges.clear();
    _challengeProgress.clear();
  }
}

class ChallengeProgressResult {
  final bool success;
  final bool progressUpdated;
  final bool challengeCompleted;
  final WeeklyChallenge? challenge;

  ChallengeProgressResult({
    required this.success,
    this.progressUpdated = false,
    this.challengeCompleted = false,
    this.challenge,
  });
}
