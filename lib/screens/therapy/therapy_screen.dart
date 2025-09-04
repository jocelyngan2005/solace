import 'package:flutter/material.dart';
import 'journal_entry_screen.dart';
import 'wellness_tools_screen.dart';
import '../../data/mood_entry_service.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> with RouteAware {
  bool _hasCompletedEntry = false;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _checkMoodEntryStatus();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check mood entry status when returning to this screen
    if (ModalRoute.of(context)?.isCurrent == true) {
      _checkMoodEntryStatus();
    }
  }
  
  Future<void> _checkMoodEntryStatus() async {
    final hasEntry = await MoodEntryService.hasMoodEntryForToday();
    print('TherapyScreen: Mood entry status - $hasEntry');
    print('Debug info: ${MoodEntryService.getDebugInfo()}');
    if (mounted) {
      setState(() {
        _hasCompletedEntry = hasEntry;
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapy & Wellness'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _hasCompletedEntry 
              ? const WellnessToolsScreen()
              : _buildMoodEntryRequired(),
    );
  }

  Widget _buildMoodEntryRequired() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.psychology_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Daily Check-in Required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'To access wellness tools and exercises, please complete your daily mood and journal entry first. This helps us provide personalized support.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToJournalEntry(),
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Start Daily Check-in'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _showWhyRequired(context);
                  },
                  child: const Text('Why is this required?'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToJournalEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEntryScreen(
          onCompleted: () {
            setState(() {
              _hasCompletedEntry = true;
            });
            Navigator.pop(context);
          },
          selectedMood: 'Neutral',
        ),
      ),
    );
  }

  void _showWhyRequired(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Why daily check-ins?'),
        content: const Text(
          'Daily mood tracking helps us:\n\n'
          '• Understand your emotional patterns\n'
          '• Provide personalized wellness suggestions\n'
          '• Track your progress over time\n'
          '• Offer timely support when needed\n\n'
          'Your privacy is protected - all data stays on your device.',
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
}
