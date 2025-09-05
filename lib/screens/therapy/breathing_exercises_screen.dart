import 'package:flutter/material.dart';
import 'breathing_session.dart';

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage> {
  int selectedCycles = 5;
  
  final Map<String, BreathingTechnique> techniques = {
    'Box Breathing': BreathingTechnique(
      name: 'Box Breathing',
      inhale: 4,
      hold1: 4,
      exhale: 4,
      hold2: 4,
      description: 'Perfect for reducing stress and improving concentration.',
    ),
    '4-7-8 Breathing': BreathingTechnique(
      name: '4-7-8 Breathing',
      inhale: 4,
      hold1: 7,
      exhale: 8,
      hold2: 0,
      description: 'Helps with sleep and calms anxiety.',
    ),
    'Deep Belly': BreathingTechnique(
      name: 'Deep Belly',
      inhale: 6,
      hold1: 2,
      exhale: 6,
      hold2: 2,
      description: 'Activates the body\'s relaxation response.',
    ),
    'Calming Breath': BreathingTechnique(
      name: 'Calming Breath',
      inhale: 4,
      hold1: 2,
      exhale: 6,
      hold2: 2,
      description: 'Best for reducing stress in the moment.',
    ),
  };

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
            'Mindfulness Breathing',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a breathing technique to calm your mind',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
              
              const SizedBox(height: 16),
              
              // Cycles Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose number of cycles:',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB9998D).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<int>(
                      value: selectedCycles,
                      underline: const SizedBox(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      items: [3, 5, 8, 10, 15].map((cycles) => 
                        DropdownMenuItem(
                          value: cycles,
                          child: Text('$cycles cycles'),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCycles = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
                // Techniques List
                Expanded(
                child: ListView.builder(
                  itemCount: techniques.length,
                  itemBuilder: (context, index) {
                  final technique = techniques.values.elementAt(index);
                  return _buildTechniqueCard(technique);
                  },
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTechniqueCard(BreathingTechnique technique) {
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
          MaterialPageRoute(
          builder: (context) => BreathingSessionPage(
            technique: technique,
            totalCycles: selectedCycles,
            selectedSoundtrack: null, // Start with no soundtrack
          ),
          ),
        );
        },
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
          // Technique Info
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              technique.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              ),
              const SizedBox(height: 4),
                Row(
                children: [
                  Icon(
                  Icons.timer_outlined,
                  size: 14,
                  color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                  _getTechniquePattern(technique),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w500,
                  ),
                  ),
                ],
                ),
              const SizedBox(height: 8),
              Text(
              technique.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              ),
            ],
            ),
          ),
          const SizedBox(width: 12),
          // Arrow
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
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
  
  String _getTechniquePattern(BreathingTechnique technique) {
    List<String> pattern = [];
    pattern.add('${technique.inhale}s in');
    if (technique.hold1 > 0) pattern.add('${technique.hold1}s hold');
    pattern.add('${technique.exhale}s out');
    if (technique.hold2 > 0) pattern.add('${technique.hold2}s hold');
    return pattern.join(' • ');
  }
}
