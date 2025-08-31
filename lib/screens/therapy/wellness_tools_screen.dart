import 'package:flutter/material.dart';

import 'grounding_toolkit/grounding_techniques.dart';
import 'meditation_screen.dart';
import 'positive_affirmation_screen.dart';
import 'breathing_exercises_screen.dart';
import '../../widgets/breathing_exercise.dart';
import '../../widgets/habit_tracker.dart';

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
            'Breathing Exercises',
            'Calm your mind with guided breathing',
            Icons.air,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BreathingExercisePage()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Mindfulness Library
          _buildToolCard(
            context,
            'Mindfulness Library',
            'Guided practices for inner peace',
            Icons.self_improvement,

            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MeditationPage()),
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
            content: SingleChildScrollView(
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
                  Text('😌 1-2: Calm and relaxed'),
                  Text('😐 3-4: Slightly tense'),
                  Text('😰 5-6: Moderately stressed'),
                  Text('😵 7-8: Very stressed'),
                  Text('🚨 9-10: Overwhelmed'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Why do you feel this way?',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
      },
    );
  }

  void _showStressTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Stress Relief Tips'),
        content: const SingleChildScrollView(
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
            content: SingleChildScrollView(
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
      },
    );
  }

  void _showAnxietyTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Stress Relief Tips'),
        content: const SingleChildScrollView(
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


