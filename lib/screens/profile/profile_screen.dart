import 'dart:async';
import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import '../../data/badges.dart';
import '../../data/user_progress.dart';
import '../../data/gamification_service.dart';
import '../../data/gamification_controller.dart';
import '../../data/weekly_challenge_service.dart';
import '../../widgets/animations/achievement_unlock_animation.dart';
import '../../widgets/habit_tracker.dart';
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
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/background/Profile_bg.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Profile section with transparent background
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(16, 100, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/Profile_Icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Stacie Raven',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            height: 24,
                            width: 80,
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Level 100',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.badge,
                            size: 14,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Psychology Student',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.person_outline,
                            size: 14,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Member since 2025',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                
                // White container that covers the background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(42),
                      topRight: Radius.circular(42),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                      
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildWeeklyChallengeSection(),

                              const SizedBox(height: 8),
                              Divider(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.2),
                                thickness: 2,
                              ),
                              const SizedBox(height: 8),

                              _buildAchievementsSection(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.track_changes,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                title: Text(
                                  'Focus Areas & Goals',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Set wellness priorities and track habits.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HabitTracker(),
                                    ),
                                  );
                                },
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.2),
                                height: 1,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.accessibility_outlined,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                title: Text(
                                  'Personalisation',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Adjust visuals, text, and voice support.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                onTap: () => _showPersonalisation(context),
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.2),
                                height: 1,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.lock_outline,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                title: Text(
                                  'Data & Privacy',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Understand what\'s collected and how it\'s used.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                onTap: () => _showDataInfo(context),
                              ),
                              Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withOpacity(0.2),
                                height: 1,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                title: Text(
                                  'About Solace',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  'Learn what this app does and why it was built.',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                    fontSize: 13,
                                    height: 1.2,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 24,
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                onTap: () => _showAbout(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChallengeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              'Weekly Challenge',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Gratitude Practice',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Write down 3 things you\'re grateful for each day.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.4, // Example: 40% complete
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.outline.withOpacity(0.4),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.tertiary,
                  ),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '3 days left',
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 8),
            Text(
              'Achievements',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAchievementChip(
              Icons.local_fire_department,
              '7-Day Streak',
              Color(0xFFFD904E),
            ),
            _buildAchievementChip(
              Icons.self_improvement,
              'Mindful Moments',
              Color(0xFF95A663),
            ),
            _buildAchievementChip(
              Icons.wb_sunny,
              'Early Bird',
              Color(0xFFFFCE5D),
            ),
            _buildAchievementChip(
              Icons.favorite,
              'Self-Care Champion',
              Color(0xFFA18FFF),
            ),
            _buildAchievementChip(
              Icons.track_changes,
              'Focus Master',
              Color(0xFFFE4B4B),
            ),
            _buildAchievementChip(
              Icons.water,
              'Hydration Hero',
              Color(0xFF8FA2FF),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievementChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showPersonalisation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Personalisation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Theme Selection
                const Text(
                  '🎨 App Theme',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _themes.map((theme) {
                    final isSelected = _selectedTheme == theme;
                    Color themeColor;
                    switch (theme) {
                      case 'Pastel Blue':
                        themeColor = Colors.blue.shade300;
                        break;
                      case 'Soft Lavender':
                        themeColor = Colors.purple.shade300;
                        break;
                      case 'Warm Beige':
                        themeColor = Colors.orange.shade300;
                        break;
                      default:
                        themeColor = Colors.blue.shade300;
                    }
                    
                    return FilterChip(
                      label: Text(theme),
                      selected: isSelected,
                      selectedColor: themeColor.withOpacity(0.3),
                      checkmarkColor: themeColor,
                      backgroundColor: Colors.grey.shade100,
                      onSelected: (selected) {
                        if (selected) {
                          setStateDialog(() {
                            _selectedTheme = theme;
                          });
                          setState(() {
                            _selectedTheme = theme;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 20),
                
                // Font Size
                const Text(
                  '📝 Text Size',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Small', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Slider(
                        value: _fontSize,
                        min: 12.0,
                        max: 24.0,
                        divisions: 6,
                        onChanged: (value) {
                          setStateDialog(() {
                            _fontSize = value;
                          });
                          setState(() {
                            _fontSize = value;
                          });
                        },
                      ),
                    ),
                    const Text('Large', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Text(
                  'Preview text at ${_fontSize.round()}pt',
                  style: TextStyle(fontSize: _fontSize, color: Colors.grey.shade600),
                ),
                
                const SizedBox(height: 20),
                
                // Accessibility Features
                const Text(
                  '♿ Accessibility',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                
                SwitchListTile(
                  title: const Text('Screen Reader Support', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Enhanced accessibility for screen readers', style: TextStyle(fontSize: 12)),
                  value: _screenReaderEnabled,
                  onChanged: (value) {
                    setStateDialog(() {
                      _screenReaderEnabled = value;
                    });
                    setState(() {
                      _screenReaderEnabled = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                
                SwitchListTile(
                  title: const Text('Notifications', style: TextStyle(fontSize: 14)),
                  subtitle: const Text('Receive wellness reminders and updates', style: TextStyle(fontSize: 12)),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setStateDialog(() {
                      _notificationsEnabled = value;
                    });
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade600, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your preferences are saved locally and help personalize your Solace experience.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
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
}
