import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';

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

  final List<String> _themes = ['Pastel Blue', 'Soft Lavender', 'Warm Beige'];
  final List<String> _allFocusAreas = [
    'Sleep', 'Anxiety', 'Productivity', 'Social', 'Academic', 'Self-esteem'
  ];

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
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Member since Sept 2024',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Achievements/Badges
            DashboardCard(
              title: '🏆 Achievements',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge('7-Day Streak', '🔥', Colors.orange),
                  _buildBadge('Mindful Moments', '🧘', Colors.green),
                  _buildBadge('Early Bird', '🌅', Colors.blue),
                  _buildBadge('Self-Care Champion', '💙', Colors.purple),
                  _buildBadge('Focus Master', '🎯', Colors.red),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Weekly Challenge
            DashboardCard(
              title: '📅 This Week\'s Challenge',
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        const Text(
                          'Gratitude Practice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Write down 3 things you\'re grateful for each day',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Progress: 4/7 days'),
                        const Spacer(),
                        Text('3 days left'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 4/7,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            
            Text(
              'Personalization',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
                        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
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
                        selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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

  Widget _buildBadge(String title, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
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
              Text('All your data is stored locally on your device and never transmitted to external servers.'),
              SizedBox(height: 12),
              Text('📱 What We Store:'),
              Text('• Mood entries and journal notes\n• Wellness activity completion\n• App preferences and settings'),
              SizedBox(height: 12),
              Text('🚫 What We Don\'t Do:'),
              Text('• Track your location\n• Access your contacts\n• Share data with third parties\n• Store data in the cloud'),
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
                const SnackBar(content: Text('Export completed! Check your downloads.')),
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
                Switch(
                  value: true,
                  onChanged: (value) {},
                ),
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
}
