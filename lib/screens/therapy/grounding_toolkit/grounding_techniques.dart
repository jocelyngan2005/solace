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
      color: const Color(0xFF7FB35F),
      technique: 'Use sight, touch, hearing, smell, and taste to ground yourself in the present moment',
      page: const SensoryGroundingPage(),
    ),
    GroundingCategory(
      name: 'Physical Grounding',
      description: 'Temperature, muscle tension, and touch-based techniques',
      icon: Icons.front_hand_rounded,
      color: const Color(0xFF5FB3BF),
      technique: 'Ice cubes, progressive muscle relaxation, and finger grounding exercises',
      page: const PhysicalGroundingPage(),
    ),
    GroundingCategory(
      name: 'Cognitive Grounding',
      description: 'Mental games and exercises to redirect focus',
      icon: Icons.psychology,
      color: const Color(0xFF8B5FBF),
      technique: 'Categories, alphabet games, and simple math problems',
      page: const MiniGamesPage(),
    ),
    GroundingCategory(
      name: 'Movement Grounding',
      description: 'Gentle movement and body awareness exercises',
      icon: Icons.directions_walk,
      color: const Color(0xFFBF7A5F),
      technique: 'Mindful walking, stretching, and bilateral tapping',
      page: const MovementGroundingPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDCCC),
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
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9EC),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF7FB35F),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'When to use grounding techniques:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF5D2A42), 
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• When feeling anxious or overwhelmed\n'
                      '• During panic attacks or high stress\n'
                      '• When your mind is racing\n'
                      '• To reconnect with the present moment\n'
                      '• Before important events or exams',
                      style: TextStyle(
                        height: 1.5,
                        color: const Color(0xFF5D2A42),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Techniques Grid
              Text(
                'Choose Your Technique',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5D2A42),
                ),
              ),
              const SizedBox(height: 16),
              
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => category.page),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFCB1A6),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9EC).withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                color: const Color(0xFF5D2A42),
                size: 28,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Title
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5D2A42),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Description
            Text(
              category.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF5D2A42).withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ],
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
