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
      icon: Icons.visibility_outlined,
      technique: 'Use sight, touch, hearing, smell, and taste to ground yourself in the present moment',
      page: const SensoryGroundingPage(),
    ),
    GroundingCategory(
      name: 'Physical Grounding',
      description: 'Temperature, muscle tension, and touch-based techniques',
      icon: Icons.front_hand_outlined,
      technique: 'Ice cubes, progressive muscle relaxation, and finger grounding exercises',
      page: const PhysicalGroundingPage(),
    ),
    GroundingCategory(
      name: 'Cognitive Grounding',
      description: 'Mental games and exercises to redirect focus',
      icon: Icons.psychology_outlined,
      technique: 'Categories, alphabet games, and simple math problems',
      page: const MiniGamesPage(),
    ),
    GroundingCategory(
      name: 'Movement Grounding',
      description: 'Gentle movement and body awareness exercises',
      icon: Icons.directions_walk,
      technique: 'Mindful walking, stretching, and bilateral tapping',
      page: const MovementGroundingPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              // Header
              Text(
                'Grounding Toolkit',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),              
              const SizedBox(height: 24),
              
              // Techniques Grid
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(
                    child: Text(
                    'Choose a grounding technique to calm your mind',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showGroundingInfoDialog(context),
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF848767),
                      size: 18,
                    ),
                  ),
                  ],
                ),

              const SizedBox(height: 16),
              
              // Techniques List
              Expanded(
                child: ListView.builder(
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
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Card(
        elevation: 6, // Increased elevation for shadow
        shadowColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.15), // Custom shadow color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => category.page),
            );
          },
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Technique Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Arrow
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _showGroundingInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'When to use grounding techniques',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 16,
                        ),
                        padding: EdgeInsets.all(2),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grounding techniques help you reconnect with the present moment and calm your nervous system. Use them:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoItem(context, Icons.psychology, 'When feeling anxious or overwhelmed'),
                      _buildInfoItem(context, Icons.emergency, 'During panic attacks or high stress'),
                      _buildInfoItem(context, Icons.speed, 'When your mind is racing'),
                      _buildInfoItem(context, Icons.center_focus_strong, 'To reconnect with the present moment'),
                      _buildInfoItem(context, Icons.event, 'Before important events or exams'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroundingCategory {
  final String name;
  final String description;
  final IconData icon;
  final String technique;
  final Widget page;

  GroundingCategory({
    required this.name,
    required this.description,
    required this.icon,
    required this.technique,
    required this.page,
  });
}
