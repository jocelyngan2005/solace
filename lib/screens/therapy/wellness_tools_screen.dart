import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'grounding_toolkit/grounding_techniques.dart';
import 'meditation_screen.dart';
import 'positive_affirmation_screen.dart';
import 'breathing_exercises_screen.dart';
import '../../widgets/habit_tracker.dart';
import '../../data/mood_entry_service.dart';

class WellnessToolsScreen extends StatelessWidget {
  const WellnessToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wellness Tools',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose an activity that feels right for you today',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Breathing Exercises
          _buildToolCard(
            context,
            'Mindfulness Breathing',
            'Calm your mind with guided breathing',
            Icons.air,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BreathingExercisePage()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Grounding Techniques
          _buildToolCard(
            context,
            'Grounding Techniques',
            'Connect with the present moment',
            Icons.nature_people,

            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroundingTechniquesPage()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Positive Affirmations
          _buildToolCard(
            context,
            'Positive Affirmations',
            'Daily mantras for self-love',
            Icons.favorite,

            Colors.pink,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PositiveAffirmationPage()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stress Check-in
          _buildToolCard(
            context,
            'Stress Check-in',
            'Quick assessment and coping tips',
            Icons.thermostat,
            Colors.red,
            () => _showStressCheckin(context),
          ),

          const SizedBox(height: 16),
          
          // Anxiety Check-in
          _buildToolCard(
            context,
            'Anxiety Check-in',
            'Quick assessment and coping tips',
            Icons.sentiment_dissatisfied,
            Colors.pink,
            () => _showAnxietyCheckin(context),
          ),
          
          const SizedBox(height: 16),

          // Habit Tracker
          _buildToolCard(
            context,
            'Habit Tracker',
            'Monitor your daily habits',
            Icons.check_circle,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HabitTracker()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Progress Insights
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.insights,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Your Progress',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildProgressItem('Days journaling this week', '5/7'),
                  _buildProgressItem('Breathing exercises completed', '12'),
                  _buildProgressItem('Average mood this week', '3.2/5'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
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

  void _showStressCheckin(BuildContext context) {
    double stressLevel = 5;
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Quick Stress Check'),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Rate your current stress level:'),
                    const SizedBox(height: 20),
                    Text('Selected: ${stressLevel.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: stressLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: stressLevel.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          stressLevel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text('😌 1-2: Calm and relaxed'),
                    const Text('😐 3-4: Slightly tense'),
                    const Text('😰 5-6: Moderately stressed'),
                    const Text('😵 7-8: Very stressed'),
                    const Text('🚨 9-10: Overwhelmed'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Why do you feel this way?',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Sync stress level with MoodEntryService
                  await MoodEntryService.markMoodEntryCompleted(
                    stressLevel: stressLevel,
                    stressReason: reasonController.text.trim().isNotEmpty ? reasonController.text.trim() : null,
                  );
                  
                  Navigator.pop(context);
                  _showStressVisualization(context, stressLevel);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStressVisualization(BuildContext context, double currentStressLevel) {
    // Sample stress data for the past 7 days (including today)
    List<FlSpot> stressData = [
      const FlSpot(0, 4), // 6 days ago
      const FlSpot(1, 3), // 5 days ago
      const FlSpot(2, 6), // 4 days ago
      const FlSpot(3, 5), // 3 days ago
      const FlSpot(4, 7), // 2 days ago
      const FlSpot(5, 4), // Yesterday
      FlSpot(6, currentStressLevel), // Today
    ];

    // Calculate week average for insights
    double weekAverage = stressData.map((spot) => spot.y).reduce((a, b) => a + b) / stressData.length;
    List<double> peaks = stressData.where((spot) => spot.y >= 7).map((spot) => spot.y).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.analytics, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Your Stress Pattern'),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past 7 days stress levels',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 25,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            // Only show "Today" for the last data point (index 6)
                            if (value.toInt() == 6) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Today',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink(); // Hide other labels
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: stressData,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.red.withOpacity(0.3),
                              Colors.red.withOpacity(0.05),
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            if (index == 6) { // Today's data point
                              return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.red,
                                strokeWidth: 3,
                                strokeColor: Colors.white,
                              );
                            }
                            return FlDotCirclePainter(
                              radius: 3,
                              color: Colors.red,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Insights container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getInsightColor(currentStressLevel).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getInsightColor(currentStressLevel).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getInsightIcon(currentStressLevel),
                          color: _getInsightColor(currentStressLevel),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getInsightText(currentStressLevel, weekAverage, peaks.length),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Week average: ${weekAverage.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          'High stress days: ${peaks.length}',
                          style: TextStyle(
                            fontSize: 11,
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showStressTips(context);
            },
            child: const Text('Show Coping Tips'),
          ),
        ],
      ),
    );
  }

  Color _getInsightColor(double stressLevel) {
    if (stressLevel >= 7) return Colors.red;
    if (stressLevel >= 5) return Colors.orange;
    return Colors.green;
  }

  IconData _getInsightIcon(double stressLevel) {
    if (stressLevel >= 7) return Icons.warning;
    if (stressLevel >= 5) return Icons.info;
    return Icons.check_circle;
  }

  String _getInsightText(double stressLevel, double weekAverage, int peakDays) {
    if (stressLevel >= 7) {
      return 'High stress detected. Consider immediate stress relief techniques.';
    } else if (stressLevel >= 5) {
      return 'Moderate stress pattern. Your stress is manageable but worth monitoring.';
    } else {
      return 'Good stress management! You\'re handling stress well this week.';
    }
  }

  void _showStressTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Stress Relief Tips'),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick relief (right now):'),
                Text('• Take 3 deep breaths\n• Drink some water\n• Step outside briefly\n'),
                Text('Short-term (next hour):'),
                Text('• Take a 5-minute walk\n• Listen to calming music\n• Do gentle stretches\n'),
                Text('Long-term (today/this week):'),
                Text('• Plan breaks between tasks\n• Talk to a friend\n• Practice gratitude'),
              ],
            ),
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

  void _showAnxietyCheckin(BuildContext context) {
    double anxietyLevel = 5;
    TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Quick Anxiety Check'),
            contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Rate your current anxiety level:'),
                    const SizedBox(height: 20),
                    Text('Selected: ${anxietyLevel.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: anxietyLevel,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: anxietyLevel.toInt().toString(),
                      onChanged: (value) {
                        setState(() {
                          anxietyLevel = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text('😌 1-2: Calm and relaxed'),
                    Text('😐 3-4: Slightly tense'),
                    Text('😰 5-6: Moderately anxious'),
                    Text('😵 7-8: Very anxious'),
                    Text('🚨 9-10: Overwhelmed'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Why do you feel this way?',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Sync anxiety level with MoodEntryService
                  await MoodEntryService.markMoodEntryCompleted(
                    anxietyLevel: anxietyLevel,
                    anxietyReason: reasonController.text.trim().isNotEmpty ? reasonController.text.trim() : null,
                  );
                  
                  Navigator.pop(context);
                  _showAnxietyVisualization(context, anxietyLevel);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAnxietyVisualization(BuildContext context, double currentAnxietyLevel) {
    // Sample anxiety data for the past 7 days (including today)
    List<FlSpot> anxietyData = [
      const FlSpot(0, 3), // 6 days ago
      const FlSpot(1, 4), // 5 days ago
      const FlSpot(2, 2), // 4 days ago
      const FlSpot(3, 6), // 3 days ago
      const FlSpot(4, 5), // 2 days ago
      const FlSpot(5, 3), // Yesterday
      FlSpot(6, currentAnxietyLevel), // Today
    ];

    // Calculate week average for insights
    double weekAverage = anxietyData.map((spot) => spot.y).reduce((a, b) => a + b) / anxietyData.length;
    List<double> peaks = anxietyData.where((spot) => spot.y >= 7).map((spot) => spot.y).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.analytics, color: Colors.pink, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Your Anxiety Pattern'),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past 7 days anxiety levels',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withOpacity(0.2),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 25,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            // Only show "Today" for the last data point (index 6)
                            if (value.toInt() == 6) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Today',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink(); // Hide other labels
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 10,
                    lineBarsData: [
                      LineChartBarData(
                        spots: anxietyData,
                        isCurved: true,
                        color: Colors.pink,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.pink.withOpacity(0.3),
                              Colors.pink.withOpacity(0.05),
                            ],
                          ),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            if (index == 6) { // Today's data point
                              return FlDotCirclePainter(
                                radius: 6,
                                color: Colors.pink,
                                strokeWidth: 3,
                                strokeColor: Colors.white,
                              );
                            }
                            return FlDotCirclePainter(
                              radius: 3,
                              color: Colors.pink,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Insights container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getAnxietyInsightColor(currentAnxietyLevel).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getAnxietyInsightColor(currentAnxietyLevel).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          _getAnxietyInsightIcon(currentAnxietyLevel),
                          color: _getAnxietyInsightColor(currentAnxietyLevel),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getAnxietyInsightText(currentAnxietyLevel, weekAverage, peaks.length),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Week average: ${weekAverage.toStringAsFixed(1)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          'High anxiety days: ${peaks.length}',
                          style: TextStyle(
                            fontSize: 11,
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
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showAnxietyTips(context);
            },
            child: const Text('Show Coping Tips'),
          ),
        ],
      ),
    );
  }

  Color _getAnxietyInsightColor(double anxietyLevel) {
    if (anxietyLevel >= 7) return Colors.red;
    if (anxietyLevel >= 5) return Colors.orange;
    return Colors.green;
  }

  IconData _getAnxietyInsightIcon(double anxietyLevel) {
    if (anxietyLevel >= 7) return Icons.warning;
    if (anxietyLevel >= 5) return Icons.info;
    return Icons.check_circle;
  }

  String _getAnxietyInsightText(double anxietyLevel, double weekAverage, int peakDays) {
    if (anxietyLevel >= 7) {
      return 'High anxiety detected. Consider immediate calming techniques.';
    } else if (anxietyLevel >= 5) {
      return 'Moderate anxiety pattern. Your anxiety is manageable but worth monitoring.';
    } else {
      return 'Good anxiety management! You\'re handling anxiety well this week.';
    }
  }

  void _showAnxietyTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Anxiety Relief Tips'),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick relief (right now):'),
                Text('• Use 4-7-8 breathing technique\n• Name 5 things you can see\n• Hold an ice cube or splash cold water\n'),
                Text('Short-term (next hour):'),
                Text('• Practice progressive muscle relaxation\n• Listen to calming music\n• Take a mindful walk\n'),
                Text('Long-term (today/this week):'),
                Text('• Maintain regular sleep schedule\n• Limit caffeine intake\n• Practice grounding exercises'),
              ],
            ),
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
}


