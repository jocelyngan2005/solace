import 'package:flutter/material.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main header card containing profile, greeting, and feeling input
            Container(
              padding: const EdgeInsets.fromLTRB(24, 90, 24, 24), // Increased top padding from 60 to 80
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
                child: Column(
                  children: [
                    // Header row with profile, greeting, and notification
                    Row(
                      children: [
                        // Profile avatar
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD4B5A0),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        // Greeting and status
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, Jocelyn!',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight : FontWeight.bold,
                                  color: Colors.black87,
                                  fontSize: 36 
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E8E8),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'member',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.purple,
                                            shape: BoxShape.rectangle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          '80%',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('😊', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Happy',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Notification icon
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            color: Colors.transparent,
                          ),
                          child: const Icon(Icons.notifications_outlined, color: Colors.grey, size: 20),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Feeling input section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'How are you feeling today?',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
                        ],
                      ),
                  ),
                ],
              ),
            ),            const SizedBox(height: 24),
            
            // Main content sections
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Motivational Quote
                  _buildMotivationalQuoteCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Mindfulness Metrics
                  _buildMindfulnessMetricsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Mood Tracker
                  _buildMoodTrackerSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Academic Overview
                  _buildAcademicOverviewSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Help button
                  _buildHelpButton(),
                  
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMotivationalQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB8E6B8), Color(0xFFA8D5A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Motivational Quote of the Day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D5016),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Progress is progress,\nno matter how small.',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D5016),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMindfulnessMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mindfulness Metrics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Mindful Minutes Card
            Expanded(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7FB069),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'Mindful Minutes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Text(
                      '80%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'achieved',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Journal Streak Card
            Expanded(
              child: Container(
                height: 160,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B7ED8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                        const Text(
                          'Journal Streak',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '10/31 days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    // Calendar grid
                    _buildMiniCalendar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniCalendar() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 1,
      ),
      itemCount: 28,
      itemBuilder: (context, index) {
        final isCompleted = index < 10;
        return Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.white : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }

  Widget _buildMoodTrackerSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_emotions, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Mood Tracker',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mood chart with emojis
          SizedBox(
            height: 120,
            child: const MoodChart(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your mood has been trending up this week, keep building on that momentum with some mindful breaks.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicOverviewSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Academic Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.school, color: Colors.black87, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Upcoming Deadlines',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDeadlineItem('Psychology Essay', 'urgent', 'Due in 1 day'),
          _buildDeadlineItem('Philosophy Essay', 'urgent', 'Due in 2 day'),
          _buildDeadlineItem('English Essay', '', 'Due in 7 day'),
          _buildDeadlineItem('Humanities Essay', '', 'Due in 10 day'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Exam week is approaching!\nRemember to balance study time with rest.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF856404),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String title, String urgency, String dueDate) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: urgency == 'urgent' ? Colors.red : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          if (urgency == 'urgent')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'urgent',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Text(
            dueDate,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle help action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB347),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Help! I\'m too stressed!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Custom painter for the hills decoration
class HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF90C695)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    
    // Create rolling hills
    for (double i = 0; i <= size.width; i += size.width / 6) {
      path.quadraticBezierTo(
        i + size.width / 12,
        size.height * 0.4,
        i + size.width / 6,
        size.height * 0.7,
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
