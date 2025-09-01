import 'package:flutter/material.dart';
import 'sensory_grounding.dart';
import 'physical_grounding.dart';
import 'mini_games.dart';
import 'movement_grounding.dart';

class GroundingTechniquesPage extends StatefulWidget {
  const GroundingTechniquesPage({super.key});

  @override
  State<GroundingTechniquesPage> createState() => _GroundingTechniquesPageState();
}

class _GroundingTechniquesPageState extends State<GroundingTechniquesPage> {
  final List<GroundingCategory> categories = [
    GroundingCategory(
      name: 'Sensory Grounding',
      description: '5-4-3-2-1 technique using your five senses',
      icon: Icons.visibility,
      color: Colors.green,
      technique: 'Use sight, touch, hearing, smell, and taste to ground yourself in the present moment',
      page: const SensoryGroundingPage(),
    ),
    GroundingCategory(
      name: 'Physical Grounding',
      description: 'Temperature, muscle tension, and touch-based techniques',
      icon: Icons.front_hand_rounded,
      color: Colors.blue,
      technique: 'Ice cubes, progressive muscle relaxation, and finger grounding exercises',
      page: const PhysicalGroundingPage(),
    ),
    GroundingCategory(
      name: 'Cognitive Grounding',
      description: 'Mental games and exercises to redirect focus',
      icon: Icons.psychology,
      color: Colors.pink,
      technique: 'Categories, alphabet games, and simple math problems',
      page: const MiniGamesPage(),
    ),
    GroundingCategory(
      name: 'Movement Grounding',
      description: 'Gentle movement and body awareness exercises',
      icon: Icons.directions_walk,
      color: Colors.orange,
      technique: 'Mindful walking, stretching, and bilateral tapping',
      page: const MovementGroundingPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grounding Toolkit'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [              
              // Information Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'When to use grounding techniques:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '• When feeling anxious or overwhelmed\n'
                        '• During panic attacks or high stress\n'
                        '• When your mind is racing\n'
                        '• To reconnect with the present moment\n'
                        '• Before important events or exams',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Techniques Grid
              Text(
                'Choose Your Technique',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return _buildTechniqueCard(category);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTechniqueCard(GroundingCategory category) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => category.page),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: 28,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Title
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                category.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroundingCategory {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String technique;
  final Widget page;

  GroundingCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.technique,
    required this.page,
  });
}
