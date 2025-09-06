import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/dashboard_card.dart';

class AcademicScreen extends StatefulWidget {
  const AcademicScreen({super.key});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isPomodoroActive = false;
  int _pomodoroTimeLeft = 1500; // 25 minutes in seconds
  String _currentPomodoroPhase = 'Focus';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Support'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Focus Mode'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarTab(),
          _buildFocusModeTab(),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Week Overview
          DashboardCard(
            title: 'This Week',
            child: Column(
              children: [
                _buildWeekOverview(),
                const SizedBox(height: 16),
                _buildWellnessTip('Big week ahead! Remember to take breaks between study sessions.'),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Upcoming Deadlines
          DashboardCard(
            title: 'Upcoming Deadlines',
            child: Column(
              children: [
                _buildDeadlineItem(
                  'Psychology Essay',
                  DateTime.now().add(const Duration(days: 3)),
                  'Draft due',
                  Colors.red,
                  Icons.assignment,
                ),
                const SizedBox(height: 12),
                _buildDeadlineItem(
                  'Math Midterm',
                  DateTime.now().add(const Duration(days: 7)),
                  'Exam',
                  Colors.orange,
                  Icons.calculate,
                ),
                const SizedBox(height: 12),
                _buildDeadlineItem(
                  'Group Project Presentation',
                  DateTime.now().add(const Duration(days: 14)),
                  'Presentation',
                  Colors.blue,
                  Icons.group,
                ),
                const SizedBox(height: 12),
                _buildDeadlineItem(
                  'Chemistry Lab Report',
                  DateTime.now().add(const Duration(days: 10)),
                  'Report due',
                  Colors.green,
                  Icons.science,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Smart Notifications
          DashboardCard(
            title: '🤖 Smart Reminders',
            child: Column(
              children: [
                _buildNotificationItem(
                  'Schedule break time',
                  'You\'ve been studying for 2 hours. Time for a 15-minute break!',
                  Icons.coffee,
                  Colors.brown,
                ),
                const SizedBox(height: 12),
                _buildNotificationItem(
                  'Exam prep suggestion',
                  'Math midterm is in 7 days. Consider starting review sessions.',
                  Icons.alarm,
                  Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildNotificationItem(
                  'Wellness check',
                  'High-stress period detected. Remember to practice self-care.',
                  Icons.favorite,
                  Colors.pink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFocusModeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Pomodoro Timer
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    'Pomodoro Timer',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Timer Display
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isPomodoroActive 
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                        : Colors.grey[100],
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 4,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatTime(_pomodoroTimeLeft),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _currentPomodoroPhase,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Control Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isPomodoroActive = !_isPomodoroActive;
                        });
                      },
                      icon: Icon(_isPomodoroActive ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPomodoroActive ? 'Pause' : 'Start Focus Session'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Break Suggestions
          DashboardCard(
            title: 'Break Suggestions',
            child: Column(
              children: [
                _buildBreakSuggestion(
                  'Take a walk',
                  'Get some fresh air and light movement',
                  Icons.directions_walk,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                _buildBreakSuggestion(
                  'Hydrate',
                  'Drink a glass of water to stay refreshed',
                  Icons.water_drop,
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildBreakSuggestion(
                  'Stretch',
                  'Release tension with simple stretches',
                  Icons.accessibility_new,
                  Colors.orange,
                ),
                const SizedBox(height: 12),
                _buildBreakSuggestion(
                  'Deep breathing',
                  'Quick mindfulness exercise',
                  Icons.air,
                  Colors.purple,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Study Stats
          DashboardCard(
            title: 'Today\'s Focus Stats',
            child: Column(
              children: [
                _buildStatItem('Focus sessions completed', '3'),
                _buildStatItem('Total focus time', '2h 15m'),
                _buildStatItem('Breaks taken', '4'),
                _buildStatItem('Current streak', '5 days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildWeekDay('M', 'High', Colors.red),
        ),
        Expanded(
          child: _buildWeekDay('T', 'Med', Colors.orange),
        ),
        Expanded(
          child: _buildWeekDay('W', 'High', Colors.red),
        ),
        Expanded(
          child: _buildWeekDay('T', 'Low', Colors.green),
        ),
        Expanded(
          child: _buildWeekDay('F', 'Med', Colors.orange),
        ),
        Expanded(
          child: _buildWeekDay('S', 'Low', Colors.green),
        ),
        Expanded(
          child: _buildWeekDay('S', 'Low', Colors.green),
        ),
      ],
    );
  }

  Widget _buildWeekDay(String day, String intensity, Color color) {
    return Column(
      children: [
        Text(day, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          intensity,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildWellnessTip(String tip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String title, DateTime date, String type, Color color, IconData icon) {
    final daysUntil = date.difference(DateTime.now()).inDays;
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
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                type,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('MMM d').format(date),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '$daysUntil days',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationItem(String title, String message, IconData icon, Color color) {
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
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                message,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakSuggestion(String title, String description, IconData icon, Color color) {
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
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // Handle break action
          },
          icon: const Icon(Icons.play_arrow, size: 20),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
