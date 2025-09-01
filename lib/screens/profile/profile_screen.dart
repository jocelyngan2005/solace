import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import '../../data/badges.dart';
import '../../data/user_progress.dart';
import '../../data/gamification_service.dart';
import '../../data/gamification_controller.dart';
import '../../data/weekly_challenge_service.dart';
import '../../widgets/animations/achievement_unlock_animation.dart';
import 'achievements_screen.dart';
import 'weekly_challenges_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedTheme = 'Pastel Blue';
  final List<String> _focusAreas = ['Sleep', 'Anxiety'];
  double _fontSize = 16.0;
  bool _screenReaderEnabled = false;
  bool _notificationsEnabled = true;

  // User progress data
  final UserProgress _userProgress = UserProgress();
  late GamificationController _gamificationController;
  late WeeklyChallengeService _challengeService;

  final List<String> _themes = ['Pastel Blue', 'Soft Lavender', 'Warm Beige'];
  final List<String> _allFocusAreas = [
    'Sleep',
    'Anxiety',
    'Productivity',
    'Social',
    'Academic',
    'Self-esteem',
  ];

  @override
  void initState() {
    super.initState();
    _gamificationController = GamificationController();
    _gamificationController.initialize(_userProgress);
    _challengeService = WeeklyChallengeService();
    _challengeService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Text(
                        'A',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Johnson',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Psychology Student • Junior',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Member since Sept 2024',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Level & Experience
            DashboardCard(
              title: '⚡ Level & Experience',
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        '${_userProgress.currentLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level ${_userProgress.currentLevel} • ${GamificationService.getLevelTitle(_userProgress.currentLevel)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_userProgress.totalXp} XP',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _userProgress
                                    .getCurrentLevelProgress()['progress'],
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _userProgress.currentLevel >= 12
                                  ? 'Max Level!'
                                  : '${_userProgress.getCurrentLevelProgress()['xpToNext']} to next level',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Achievements/Badges
            DashboardCard(
              title: '🏆 Achievements',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${AchievementData.getUnlockedCount()} / ${AchievementData.getTotalAchievements()}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Achievements Unlocked',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircularProgressIndicator(
                          value:
                              AchievementData.getCompletionPercentage() / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Recent Badges
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AchievementData.allAchievements
                        .where(
                          (achievement) => _userProgress.unlockedAchievements
                              .contains(achievement.id),
                        )
                        .take(6)
                        .map((achievement) => _buildBadge(achievement))
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showNewAchievementUnlock(),
                          child: const Text('New Achievements'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AchievementsScreen(),
                              ),
                            );
                          },
                          child: const Text('View All'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Weekly Challenge
            DashboardCard(
              title: '📅 Weekly Challenges',
              child: _buildWeeklyChallengeSection(),
            ),

            const SizedBox(height: 24),

            Text(
              'Personalization',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Theme Selection
            DashboardCard(
              title: '🎨 App Theme',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Choose your preferred color scheme'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: _themes.map((theme) {
                      final isSelected = _selectedTheme == theme;
                      return ChoiceChip(
                        label: Text(theme),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedTheme = theme;
                            });
                          }
                        },
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Focus Areas
            DashboardCard(
              title: '🎯 Focus Areas',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What would you like to work on?'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _allFocusAreas.map((area) {
                      final isSelected = _focusAreas.contains(area);
                      return FilterChip(
                        label: Text(area),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _focusAreas.add(area);
                            } else {
                              _focusAreas.remove(area);
                            }
                          });
                        },
                        selectedColor: Theme.of(
                          context,
                        ).colorScheme.secondary.withOpacity(0.2),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Accessibility
            DashboardCard(
              title: '♿ Accessibility',
              child: Column(
                children: [
                  // Font Size
                  Row(
                    children: [
                      const Expanded(child: Text('Font Size')),
                      Text('${_fontSize.round()}pt'),
                    ],
                  ),
                  Slider(
                    value: _fontSize,
                    min: 12,
                    max: 24,
                    divisions: 6,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  // Screen Reader
                  SwitchListTile(
                    title: const Text('Screen Reader Support'),
                    subtitle: const Text('Enhanced accessibility features'),
                    value: _screenReaderEnabled,
                    onChanged: (value) {
                      setState(() {
                        _screenReaderEnabled = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),

                  // Notifications
                  SwitchListTile(
                    title: const Text('Push Notifications'),
                    subtitle: const Text('Reminders and wellness tips'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Data & Privacy',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Data Privacy
            DashboardCard(
              title: '🔒 Your Privacy',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security, color: Colors.green),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'All data stays on your device',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your journal entries, mood data, and personal information never leave your phone. We respect your privacy.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showDataInfo(context),
                          child: const Text('Learn More'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showExportOptions(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Export Data'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // App Info
            DashboardCard(
              title: 'ℹ️ About Solace',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Version 1.0.0'),
                  const SizedBox(height: 8),
                  const Text(
                    'A mindful companion for university students',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showFeedback(context),
                          child: const Text('Send Feedback'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _showAbout(context),
                          child: const Text('Credits'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(Achievement achievement) {
    return GestureDetector(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: achievement.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: achievement.color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(achievement.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 4),
            Text(
              achievement.title,
              style: TextStyle(
                color: achievement.color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Text(achievement.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  achievement.title,
                  style: TextStyle(
                    color: achievement.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: achievement.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: achievement.color.withOpacity(0.3)),
                ),
                child: Text(
                  achievement.category.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: achievement.color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.description,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Achievement Unlocked!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: achievement.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNewAchievementUnlock() {
    // Mock list of "newly unlocked" achievements for demo
    final mockNewAchievements = [
      AchievementData.allAchievements.firstWhere(
        (a) => a.id == 'mindful_moments',
        orElse: () => AchievementData.allAchievements.first,
      ),
      AchievementData.allAchievements.firstWhere(
        (a) => a.id == 'streak_7',
        orElse: () => AchievementData.allAchievements[1],
      ),
      AchievementData.allAchievements.firstWhere(
        (a) => a.id == 'early_bird',
        orElse: () => AchievementData.allAchievements[2],
      ),
    ];

    // Play animations for all mock achievements sequentially
    _playMultipleAchievementAnimations(mockNewAchievements);
  }

  Future<void> _playMultipleAchievementAnimations(
    List<Achievement> achievements,
  ) async {
    for (int i = 0; i < achievements.length; i++) {
      await _simulateAchievementUnlock(achievements[i]);

      // Small delay between animations if there are more to show
      if (i < achievements.length - 1) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    // Show completion message after all animations
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Unlocked ${achievements.length} new achievements!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _simulateAchievementUnlock(Achievement achievement) async {
    final completer = Completer<void>();

    // Import the animation widget
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

  void _showDataInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Your Data & Privacy'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🔒 Local Storage Only'),
              Text(
                'All your data is stored locally on your device and never transmitted to external servers.',
              ),
              SizedBox(height: 12),
              Text('📱 What We Store:'),
              Text(
                '• Mood entries and journal notes\n• Wellness activity completion\n• App preferences and settings',
              ),
              SizedBox(height: 12),
              Text('🚫 What We Don\'t Do:'),
              Text(
                '• Track your location\n• Access your contacts\n• Share data with third parties\n• Store data in the cloud',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Export Your Data'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You can export your data in the following formats:'),
            SizedBox(height: 12),
            Text('📊 CSV - Mood data for analysis'),
            Text('📝 PDF - Journal entries report'),
            Text('📈 JSON - Complete data backup'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export completed! Check your downloads.'),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showFeedback(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us how we can improve Solace...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Include app logs: '),
                Switch(value: true, onChanged: (value) {}),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thank you for your feedback!')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('About Solace'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Solace is designed by students, for students.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text('🎓 Created to support university student mental health'),
              Text('💙 Built with empathy and understanding'),
              Text('🔒 Privacy-first design'),
              Text('🌱 Focused on growth and self-care'),
              SizedBox(height: 12),
              Text(
                'Special thanks to mental health professionals and student beta testers who helped shape this app.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallengeSection() {
    final activeChallenges = _challengeService.getActiveChallenges();
    final featuredChallenge = _challengeService.getFeaturedChallenge();
    final stats = _challengeService.getStatistics();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Challenge Stats Row
        Row(
          children: [
            Expanded(
              child: _buildChallengeStatCard(
                'Active',
                '${activeChallenges.length}',
                Colors.blue,
                Icons.play_arrow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChallengeStatCard(
                'Completed',
                '${stats['completedChallenges']}',
                Colors.green,
                Icons.check_circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildChallengeStatCard(
                'XP Earned',
                '${stats['totalXpEarned']}',
                Colors.purple,
                Icons.star,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Active or Featured Challenge
        if (activeChallenges.isNotEmpty) ...[
          Text(
            'Active Challenge',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          _buildActiveChallengePreview(activeChallenges.first),
        ] else if (featuredChallenge != null) ...[
          Text(
            'Featured This Week',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          _buildFeaturedChallengePreview(featuredChallenge),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.emoji_events, size: 32, color: Colors.grey[400]),
                const SizedBox(height: 8),
                const Text(
                  'No active challenges',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const Text(
                  'Start a new challenge to boost your wellness journey!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Action Button
        SizedBox(
          width: double.infinity,
          child: Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WeeklyChallengesScreen(),
                  ),
                );
              },
              child: const Text('View All'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActiveChallengePreview(challenge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            challenge.primaryColor.withOpacity(0.1),
            challenge.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '${challenge.daysRemaining} days left',
                style: TextStyle(
                  fontSize: 12,
                  color: challenge.daysRemaining <= 2
                      ? Colors.red
                      : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress: ${challenge.currentProgress}/${challenge.targetCount}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                '${(challenge.progressPercentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: challenge.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: challenge.progressPercentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(challenge.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedChallengePreview(challenge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(challenge.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  challenge.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${challenge.xpReward} XP',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            challenge.description,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
