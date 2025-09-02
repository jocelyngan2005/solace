import 'package:flutter/material.dart';
import '../../widgets/breathing_exercise.dart';

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
              MaterialPageRoute(builder: (context) => const BreathingExercise()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Mindfulness Library
          _buildToolCard(
            context,
            'Mindfulness Library',
            '10 guided practices for inner peace',
            Icons.self_improvement,
            Colors.green,
            () => _showMindfulnessPractices(context),
          ),
          
          const SizedBox(height: 16),
          
          // Grounding Techniques
          _buildToolCard(
            context,
            'Grounding Techniques',
            'Connect with the present moment',
            Icons.nature_people,
            Colors.orange,
            () => _showGroundingTechniques(context),
          ),
          
          const SizedBox(height: 16),
          
          // Positive Affirmations
          _buildToolCard(
            context,
            'Positive Affirmations',
            'Daily mantras for self-love',
            Icons.favorite,
            Colors.pink,
            () => _showAffirmations(context),
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

  void _showMindfulnessPractices(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFFFEFEFE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.self_improvement, color: Colors.green),
                  const SizedBox(width: 12),
                  const Text(
                    'Mindfulness Library',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildPracticeItem('Body Scan Meditation', '15 mins', 'Release tension throughout your body'),
                  _buildPracticeItem('Loving Kindness', '10 mins', 'Cultivate compassion for yourself and others'),
                  _buildPracticeItem('Mindful Walking', '5 mins', 'Bring awareness to each step'),
                  _buildPracticeItem('Present Moment Awareness', '8 mins', 'Ground yourself in the here and now'),
                  _buildPracticeItem('Gratitude Reflection', '7 mins', 'Focus on what you\'re thankful for'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeItem(String title, String duration, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.play_arrow, color: Color(0xFFFEFEFE)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$duration • $description'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Simulate starting practice
        },
      ),
    );
  }

  void _showGroundingTechniques(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('5-4-3-2-1 Grounding Technique'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('When you feel overwhelmed, try this:'),
              SizedBox(height: 16),
              Text('👁️ 5 things you can SEE\nLook around and name them'),
              SizedBox(height: 12),
              Text('✋ 4 things you can TOUCH\nFeel their texture'),
              SizedBox(height: 12),
              Text('👂 3 things you can HEAR\nListen carefully'),
              SizedBox(height: 12),
              Text('👃 2 things you can SMELL\nTake a deep breath'),
              SizedBox(height: 12),
              Text('👅 1 thing you can TASTE\nNotice any flavors'),
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

  void _showAffirmations(BuildContext context) {
    final affirmations = [
      "I am capable of handling whatever comes my way",
      "My mental health matters and I prioritize it",
      "I am worthy of love and kindness, especially from myself",
      "Each challenge is an opportunity to grow stronger",
      "I choose to focus on what I can control",
      "I am doing my best with what I have right now",
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Color(0xFFFEFEFE),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.pink),
                  const SizedBox(width: 12),
                  const Text(
                    'Daily Affirmations',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: affirmations.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '"${affirmations[index]}"',
                          style: const TextStyle(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '${index + 1} of ${affirmations.length}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStressCheckin(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quick Stress Check'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Rate your current stress level:'),
            SizedBox(height: 20),
            Text('😌 1-2: Calm and relaxed'),
            Text('😐 3-4: Slightly tense'),
            Text('😰 5-6: Moderately stressed'),
            Text('😵 7-8: Very stressed'),
            Text('🚨 9-10: Overwhelmed'),
          ],
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
}
