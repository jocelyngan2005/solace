import 'package:flutter/material.dart';
import '../../widgets/dashboard_card.dart';
import '../../widgets/mood_chart.dart';
import '../therapy/mood_entry_screen.dart';
import '../../widgets/journal_screen.dart';
import '../../data/mood_entry_service.dart';
import '../therapy/breathing_exercises_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  bool _hasMoodEntry = false;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Listen to mood entry status changes
    MoodEntryService.moodEntryNotifier.addListener(_onMoodEntryStatusChanged);
    
    _checkMoodEntryStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    MoodEntryService.moodEntryNotifier.removeListener(_onMoodEntryStatusChanged);
    super.dispose();
  }

  void _onMoodEntryStatusChanged() {
    // Refresh mood entry status when notified
    _checkMoodEntryStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check mood entry status when app resumes
      _checkMoodEntryStatus();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check mood entry status when this screen becomes active
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        _checkMoodEntryStatus();
      }
    });
  }

  Future<void> _checkMoodEntryStatus() async {
    final hasEntry = await MoodEntryService.hasMoodEntryForToday();
    if (mounted) {
      setState(() {
        _hasMoodEntry = hasEntry;
        _isLoading = false;
      });
    }
  }

  // Public method to refresh mood entry status
  void refreshMoodStatus() {
    _checkMoodEntryStatus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return Scaffold(
      appBar: AppBar(
        title: const Text('Good morning, Alex 👋'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick mood check
            _isLoading
                ? DashboardCard(
                    title: 'How are you feeling?',
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _hasMoodEntry
                    ? _buildMoodCompleted()
                    : _buildMoodSelection(),

            const SizedBox(height: 16),

            // Mood chart
            DashboardCard(
              title: 'Your mood this week',
              child: const SizedBox(height: 200, child: MoodChart()),
            ),

            const SizedBox(height: 16),

            // AI Insights
            DashboardCard(
              title: '🧠 AI Insights',
              child: Column(
                children: [
                  _buildInsightItem(
                    Icons.trending_down,
                    'Your mood has been trending down this week',
                    'Consider scheduling some downtime this weekend',
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildInsightItem(
                    Icons.school,
                    'Exam week is approaching',
                    'Remember to balance study time with rest',
                    Colors.blue,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Habit progress
            DashboardCard(
              title: 'Today\'s wellness goals',
              child: Column(
                children: [
                  _buildHabitProgress('Mindful minutes', 15, 20, Colors.green),
                  const SizedBox(height: 12),
                  _buildHabitProgress('Sleep hours', 7, 8, Colors.blue),
                  const SizedBox(height: 12),
                  _buildHabitProgress('Journal entries', 1, 1, Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Upcoming deadlines
            DashboardCard(
              title: 'Upcoming deadlines',
              child: Column(
                children: [
                  _buildDeadlineItem(
                    'Psychology Essay',
                    'Due in 3 days',
                    Icons.assignment,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildDeadlineItem(
                    'Math Midterm',
                    'Due in 1 week',
                    Icons.calculate,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildDeadlineItem(
                    'Group Project',
                    'Due in 2 weeks',
                    Icons.group,
                    Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    'Quick Journal',
                    Icons.edit_note,
                    Theme.of(context).colorScheme.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const JournalScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickActionCard(
                    context,
                    'Breathing Exercise',
                    Icons.air,
                    Theme.of(context).colorScheme.secondary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BreathingExercisePage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(
    BuildContext context,
    String emoji,
    String label,
    Color color,
  ) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoodEntryScreen(
              onCompleted: () {},
              selectedMood: label,
              fromHomeScreen: true,
            ),
          ),
        );
        // Refresh mood entry status when returning from mood entry
        _checkMoodEntryStatus();
      },
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHabitProgress(
    String title,
    int current,
    int target,
    Color color,
  ) {
    final progress = current / target;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$current/$target',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDeadlineItem(
    String title,
    String date,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelection() {
    return DashboardCard(
      title: 'How are you feeling?',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMoodButton(context, '😢', 'Very Low', Colors.red[100]!),
          _buildMoodButton(context, '😔', 'Low', Colors.orange[100]!),
          _buildMoodButton(
            context,
            '😐',
            'Neutral',
            Colors.yellow[100]!,
          ),
          _buildMoodButton(
            context,
            '😊',
            'Good',
            Colors.lightGreen[100]!,
          ),
          _buildMoodButton(
            context,
            '😄',
            'Excellent',
            Colors.green[100]!,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCompleted() {
    final moodEmoji = MoodEntryService.getTodayMoodEmoji() ?? '😊';
    final moodLabel = MoodEntryService.getTodayMoodLabel() ?? 'Good';
    
    return DashboardCard(
      title: 'Today\'s mood check ✓',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                moodEmoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feeling $moodLabel today',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mood logged successfully! Check your wellness tools in the therapy tab.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
