import 'package:flutter/material.dart';

enum ChallengeType {
  habit,
  wellbeing,
  mindfulness,
  social,
  academic,
  creativity,
}

enum ChallengeDifficulty {
  beginner,
  intermediate,
  advanced,
}

enum ChallengeStatus {
  notStarted,
  inProgress,
  completed,
  expired,
}

class WeeklyChallenge {
  final String id;
  final String title;
  final String description;
  final String detailedDescription;
  final String emoji;
  final ChallengeType type;
  final ChallengeDifficulty difficulty;
  final int durationDays;
  final int targetCount;
  final int xpReward;
  final String unlockBadgeId;
  final Color primaryColor;
  final Color accentColor;
  final List<String> tips;
  final List<ChallengeTask> tasks;
  final DateTime? startDate;
  final DateTime? endDate;
  final ChallengeStatus status;
  final int currentProgress;

  const WeeklyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.emoji,
    required this.type,
    required this.difficulty,
    required this.durationDays,
    required this.targetCount,
    required this.xpReward,
    required this.unlockBadgeId,
    required this.primaryColor,
    required this.accentColor,
    required this.tips,
    required this.tasks,
    this.startDate,
    this.endDate,
    this.status = ChallengeStatus.notStarted,
    this.currentProgress = 0,
  });

  WeeklyChallenge copyWith({
    String? id,
    String? title,
    String? description,
    String? detailedDescription,
    String? emoji,
    ChallengeType? type,
    ChallengeDifficulty? difficulty,
    int? durationDays,
    int? targetCount,
    int? xpReward,
    String? unlockBadgeId,
    Color? primaryColor,
    Color? accentColor,
    List<String>? tips,
    List<ChallengeTask>? tasks,
    DateTime? startDate,
    DateTime? endDate,
    ChallengeStatus? status,
    int? currentProgress,
  }) {
    return WeeklyChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      emoji: emoji ?? this.emoji,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      durationDays: durationDays ?? this.durationDays,
      targetCount: targetCount ?? this.targetCount,
      xpReward: xpReward ?? this.xpReward,
      unlockBadgeId: unlockBadgeId ?? this.unlockBadgeId,
      primaryColor: primaryColor ?? this.primaryColor,
      accentColor: accentColor ?? this.accentColor,
      tips: tips ?? this.tips,
      tasks: tasks ?? this.tasks,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  double get progressPercentage => currentProgress / targetCount;
  
  int get daysRemaining {
    if (endDate == null) return 0;
    final now = DateTime.now();
    return endDate!.difference(now).inDays;
  }

  bool get isExpired => endDate != null && DateTime.now().isAfter(endDate!);
  bool get isCompleted => status == ChallengeStatus.completed;
  bool get isActive => status == ChallengeStatus.inProgress && !isExpired;

  String get difficultyLabel {
    switch (difficulty) {
      case ChallengeDifficulty.beginner:
        return 'Beginner';
      case ChallengeDifficulty.intermediate:
        return 'Intermediate';
      case ChallengeDifficulty.advanced:
        return 'Advanced';
    }
  }

  String get typeLabel {
    switch (type) {
      case ChallengeType.habit:
        return 'Habit';
      case ChallengeType.wellbeing:
        return 'Wellbeing';
      case ChallengeType.mindfulness:
        return 'Mindfulness';
      case ChallengeType.social:
        return 'Social';
      case ChallengeType.academic:
        return 'Academic';
      case ChallengeType.creativity:
        return 'Creativity';
    }
  }
}

class ChallengeTask {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime? completedDate;

  const ChallengeTask({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.completedDate,
  });

  ChallengeTask copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? completedDate,
  }) {
    return ChallengeTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

class WeeklyChallengeData {
  static final List<WeeklyChallenge> _allChallenges = [
    // Mindfulness Challenges
    WeeklyChallenge(
      id: 'gratitude_week',
      title: 'Gratitude Practice',
      description: 'Write down 3 things you\'re grateful for each day',
      detailedDescription: 'Cultivate a positive mindset by taking a few minutes each day to reflect on what you\'re grateful for. This simple practice can significantly improve your mental wellbeing and perspective.',
      emoji: '🙏',
      type: ChallengeType.mindfulness,
      difficulty: ChallengeDifficulty.beginner,
      durationDays: 7,
      targetCount: 7,
      xpReward: 150,
      unlockBadgeId: 'gratitude_guru',
      primaryColor: Colors.amber,
      accentColor: Colors.orange,
      tips: [
        'Write in your journal or use the notes app',
        'Be specific about what you\'re grateful for',
        'Include small everyday moments',
        'Try doing this at the same time each day',
        'Share your gratitude with friends or family',
      ],
      tasks: [
        ChallengeTask(
          id: 'gratitude_day_1',
          title: 'Day 1: Start your gratitude journey',
          description: 'Write down 3 things you\'re grateful for today',
        ),
        ChallengeTask(
          id: 'gratitude_day_2',
          title: 'Day 2: Focus on relationships',
          description: 'Include at least one person you\'re grateful for',
        ),
        ChallengeTask(
          id: 'gratitude_day_3',
          title: 'Day 3: Appreciate simple pleasures',
          description: 'Notice small, everyday things that bring joy',
        ),
        ChallengeTask(
          id: 'gratitude_day_4',
          title: 'Day 4: Reflect on personal growth',
          description: 'What challenges have helped you grow?',
        ),
        ChallengeTask(
          id: 'gratitude_day_5',
          title: 'Day 5: Academic appreciation',
          description: 'What aspects of your studies are you grateful for?',
        ),
        ChallengeTask(
          id: 'gratitude_day_6',
          title: 'Day 6: Express gratitude to others',
          description: 'Tell someone why you\'re grateful for them',
        ),
        ChallengeTask(
          id: 'gratitude_day_7',
          title: 'Day 7: Future gratitude',
          description: 'What are you looking forward to?',
        ),
      ],
    ),

    WeeklyChallenge(
      id: 'mindful_breathing',
      title: 'Daily Breathing Practice',
      description: 'Complete 10 minutes of breathing exercises daily',
      detailedDescription: 'Develop a consistent mindfulness practice through daily breathing exercises. This challenge will help you build resilience, reduce stress, and improve focus.',
      emoji: '🧘‍♀️',
      type: ChallengeType.mindfulness,
      difficulty: ChallengeDifficulty.intermediate,
      durationDays: 7,
      targetCount: 7,
      xpReward: 200,
      unlockBadgeId: 'breath_master',
      primaryColor: Colors.teal,
      accentColor: Colors.cyan,
      tips: [
        'Use the built-in breathing exercises in the app',
        'Find a quiet, comfortable space',
        'Start with shorter sessions if needed',
        'Focus on the sensation of breathing',
        'Don\'t worry if your mind wanders - that\'s normal',
      ],
      tasks: [
        ChallengeTask(
          id: 'breathing_day_1',
          title: 'Day 1: Basic breath awareness',
          description: 'Complete 10 minutes of basic breathing',
        ),
        ChallengeTask(
          id: 'breathing_day_2',
          title: 'Day 2: Box breathing technique',
          description: 'Try the 4-4-4-4 box breathing pattern',
        ),
        ChallengeTask(
          id: 'breathing_day_3',
          title: 'Day 3: Stress relief breathing',
          description: 'Use breathing to manage any stress today',
        ),
        ChallengeTask(
          id: 'breathing_day_4',
          title: 'Day 4: Morning breathing routine',
          description: 'Start your day with breathing exercises',
        ),
        ChallengeTask(
          id: 'breathing_day_5',
          title: 'Day 5: Study break breathing',
          description: 'Use breathing as a study break technique',
        ),
        ChallengeTask(
          id: 'breathing_day_6',
          title: 'Day 6: Evening wind-down',
          description: 'End your day with calming breaths',
        ),
        ChallengeTask(
          id: 'breathing_day_7',
          title: 'Day 7: Reflect on your practice',
          description: 'Notice how breathing practice affects you',
        ),
      ],
    ),

    // Wellbeing Challenges
    WeeklyChallenge(
      id: 'sleep_optimization',
      title: 'Sleep Schedule Master',
      description: 'Maintain consistent sleep and wake times for 7 days',
      detailedDescription: 'Establish a healthy sleep routine by going to bed and waking up at the same time each day. Good sleep is crucial for academic performance and mental health.',
      emoji: '😴',
      type: ChallengeType.wellbeing,
      difficulty: ChallengeDifficulty.intermediate,
      durationDays: 7,
      targetCount: 7,
      xpReward: 175,
      unlockBadgeId: 'sleep_champion',
      primaryColor: Colors.indigo,
      accentColor: Colors.purple,
      tips: [
        'Set a consistent bedtime and wake time',
        'Create a relaxing bedtime routine',
        'Avoid screens 1 hour before bed',
        'Keep your bedroom cool and dark',
        'Track your sleep in the habit tracker',
      ],
      tasks: [
        ChallengeTask(
          id: 'sleep_day_1',
          title: 'Day 1: Set your sleep schedule',
          description: 'Choose realistic bed and wake times',
        ),
        ChallengeTask(
          id: 'sleep_day_2',
          title: 'Day 2: Create bedtime routine',
          description: 'Develop a 30-minute wind-down routine',
        ),
        ChallengeTask(
          id: 'sleep_day_3',
          title: 'Day 3: Optimize sleep environment',
          description: 'Make your bedroom sleep-friendly',
        ),
        ChallengeTask(
          id: 'sleep_day_4',
          title: 'Day 4: Monitor caffeine intake',
          description: 'Avoid caffeine 6 hours before bedtime',
        ),
        ChallengeTask(
          id: 'sleep_day_5',
          title: 'Day 5: Digital detox before bed',
          description: 'No screens 1 hour before sleep',
        ),
        ChallengeTask(
          id: 'sleep_day_6',
          title: 'Day 6: Relaxation techniques',
          description: 'Try meditation or reading before bed',
        ),
        ChallengeTask(
          id: 'sleep_day_7',
          title: 'Day 7: Evaluate your progress',
          description: 'Reflect on how better sleep affects you',
        ),
      ],
    ),

    WeeklyChallenge(
      id: 'hydration_hero',
      title: 'Hydration Hero',
      description: 'Drink 8 glasses of water daily for a week',
      detailedDescription: 'Stay properly hydrated to improve concentration, energy levels, and overall health. This challenge helps establish a healthy drinking habit.',
      emoji: '💧',
      type: ChallengeType.wellbeing,
      difficulty: ChallengeDifficulty.beginner,
      durationDays: 7,
      targetCount: 56, // 8 glasses × 7 days
      xpReward: 125,
      unlockBadgeId: 'hydration_hero',
      primaryColor: Colors.blue,
      accentColor: Colors.lightBlue,
      tips: [
        'Use the water tracker in the habits section',
        'Keep a water bottle with you',
        'Set reminders on your phone',
        'Add lemon or fruit for flavor',
        'Track first thing in the morning',
      ],
      tasks: [
        ChallengeTask(
          id: 'hydration_day_1',
          title: 'Day 1: Establish baseline',
          description: 'Track your current water intake',
        ),
        ChallengeTask(
          id: 'hydration_day_2',
          title: 'Day 2: Morning hydration',
          description: 'Start each day with 2 glasses of water',
        ),
        ChallengeTask(
          id: 'hydration_day_3',
          title: 'Day 3: Study session hydration',
          description: 'Keep water nearby while studying',
        ),
        ChallengeTask(
          id: 'hydration_day_4',
          title: 'Day 4: Pre-meal hydration',
          description: 'Drink water before each meal',
        ),
        ChallengeTask(
          id: 'hydration_day_5',
          title: 'Day 5: Exercise hydration',
          description: 'Extra water on active days',
        ),
        ChallengeTask(
          id: 'hydration_day_6',
          title: 'Day 6: Evening routine',
          description: 'Include hydration in evening routine',
        ),
        ChallengeTask(
          id: 'hydration_day_7',
          title: 'Day 7: Reflect on benefits',
          description: 'Notice improvements in energy and focus',
        ),
      ],
    ),

    // Academic Challenges
    WeeklyChallenge(
      id: 'study_pomodoro',
      title: 'Pomodoro Productivity',
      description: 'Use Pomodoro technique for studying 5 days this week',
      detailedDescription: 'Master the Pomodoro Technique to improve focus and productivity. Study in 25-minute focused sessions with 5-minute breaks.',
      emoji: '🍅',
      type: ChallengeType.academic,
      difficulty: ChallengeDifficulty.intermediate,
      durationDays: 7,
      targetCount: 5,
      xpReward: 180,
      unlockBadgeId: 'productivity_master',
      primaryColor: Colors.red,
      accentColor: Colors.orange,
      tips: [
        'Use a timer for 25-minute work sessions',
        'Take 5-minute breaks between sessions',
        'After 4 sessions, take a longer 15-30 minute break',
        'Eliminate distractions during focus time',
        'Track your sessions in a journal',
      ],
      tasks: [
        ChallengeTask(
          id: 'pomodoro_day_1',
          title: 'Day 1: Learn the technique',
          description: 'Complete 2 Pomodoro sessions',
        ),
        ChallengeTask(
          id: 'pomodoro_day_2',
          title: 'Day 2: Eliminate distractions',
          description: 'Focus on removing interruptions',
        ),
        ChallengeTask(
          id: 'pomodoro_day_3',
          title: 'Day 3: Track your progress',
          description: 'Record what you accomplish each session',
        ),
        ChallengeTask(
          id: 'pomodoro_day_4',
          title: 'Day 4: Optimize break time',
          description: 'Find the best break activities for you',
        ),
        ChallengeTask(
          id: 'pomodoro_day_5',
          title: 'Day 5: Challenge yourself',
          description: 'Complete 4 consecutive sessions',
        ),
      ],
    ),

    // Social Challenges
    WeeklyChallenge(
      id: 'social_connection',
      title: 'Social Connection Week',
      description: 'Reach out to friends or family members daily',
      detailedDescription: 'Strengthen your social connections by intentionally connecting with people you care about. Social support is crucial for mental health.',
      emoji: '🤝',
      type: ChallengeType.social,
      difficulty: ChallengeDifficulty.beginner,
      durationDays: 7,
      targetCount: 7,
      xpReward: 140,
      unlockBadgeId: 'social_butterfly',
      primaryColor: Colors.pink,
      accentColor: Colors.pinkAccent,
      tips: [
        'Send a text, make a call, or meet in person',
        'Check in on friends who might be struggling',
        'Share something positive from your day',
        'Ask open-ended questions about their life',
        'Be present and listen actively',
      ],
      tasks: [
        ChallengeTask(
          id: 'social_day_1',
          title: 'Day 1: Reach out to a close friend',
          description: 'Connect with someone you haven\'t talked to recently',
        ),
        ChallengeTask(
          id: 'social_day_2',
          title: 'Day 2: Family connection',
          description: 'Have a meaningful conversation with family',
        ),
        ChallengeTask(
          id: 'social_day_3',
          title: 'Day 3: Study buddy check-in',
          description: 'Connect with a classmate or study partner',
        ),
        ChallengeTask(
          id: 'social_day_4',
          title: 'Day 4: Express appreciation',
          description: 'Tell someone why you appreciate them',
        ),
        ChallengeTask(
          id: 'social_day_5',
          title: 'Day 5: Make new connections',
          description: 'Introduce yourself to someone new',
        ),
        ChallengeTask(
          id: 'social_day_6',
          title: 'Day 6: Group activity',
          description: 'Organize or join a group activity',
        ),
        ChallengeTask(
          id: 'social_day_7',
          title: 'Day 7: Reflect on connections',
          description: 'Journal about your social interactions',
        ),
      ],
    ),

    // Creativity Challenges
    WeeklyChallenge(
      id: 'creative_expression',
      title: 'Daily Creative Expression',
      description: 'Engage in a creative activity for 15 minutes daily',
      detailedDescription: 'Nurture your creativity and mental wellbeing through daily creative expression. This can reduce stress and boost mood.',
      emoji: '🎨',
      type: ChallengeType.creativity,
      difficulty: ChallengeDifficulty.beginner,
      durationDays: 7,
      targetCount: 7,
      xpReward: 160,
      unlockBadgeId: 'creative_soul',
      primaryColor: Colors.purple,
      accentColor: Colors.deepPurple,
      tips: [
        'Try drawing, writing, music, or any creative outlet',
        'Don\'t worry about the quality - focus on the process',
        'Use creativity as a study break',
        'Document your creations',
        'Share with friends if you feel comfortable',
      ],
      tasks: [
        ChallengeTask(
          id: 'creative_day_1',
          title: 'Day 1: Explore different mediums',
          description: 'Try 3 different creative activities',
        ),
        ChallengeTask(
          id: 'creative_day_2',
          title: 'Day 2: Express your mood',
          description: 'Create something that reflects how you feel',
        ),
        ChallengeTask(
          id: 'creative_day_3',
          title: 'Day 3: Nature inspiration',
          description: 'Create something inspired by nature',
        ),
        ChallengeTask(
          id: 'creative_day_4',
          title: 'Day 4: Memory capture',
          description: 'Create something about a favorite memory',
        ),
        ChallengeTask(
          id: 'creative_day_5',
          title: 'Day 5: Future vision',
          description: 'Express your hopes or dreams creatively',
        ),
        ChallengeTask(
          id: 'creative_day_6',
          title: 'Day 6: Collaborative creation',
          description: 'Create something with or for someone else',
        ),
        ChallengeTask(
          id: 'creative_day_7',
          title: 'Day 7: Reflection piece',
          description: 'Create something about your week',
        ),
      ],
    ),
  ];

  static List<WeeklyChallenge> get allChallenges => List.unmodifiable(_allChallenges);

  static WeeklyChallenge? getChallengeById(String id) {
    try {
      return _allChallenges.firstWhere((challenge) => challenge.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<WeeklyChallenge> getChallengesByType(ChallengeType type) {
    return _allChallenges.where((challenge) => challenge.type == type).toList();
  }

  static List<WeeklyChallenge> getChallengesByDifficulty(ChallengeDifficulty difficulty) {
    return _allChallenges.where((challenge) => challenge.difficulty == difficulty).toList();
  }

  static List<WeeklyChallenge> getActiveChallenges() {
    return _allChallenges.where((challenge) => challenge.isActive).toList();
  }

  static List<WeeklyChallenge> getCompletedChallenges() {
    return _allChallenges.where((challenge) => challenge.isCompleted).toList();
  }

  static List<WeeklyChallenge> getAvailableChallenges() {
    return _allChallenges.where((challenge) => 
      challenge.status == ChallengeStatus.notStarted && !challenge.isExpired
    ).toList();
  }
}
