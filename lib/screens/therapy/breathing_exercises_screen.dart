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
      description: 'Equal counts for balance and focus. Perfect for reducing stress and improving concentration.',
      color: Colors.blue[200]!,
    ),
    '4-7-8 Breathing': BreathingTechnique(
      name: '4-7-8 Breathing',
      inhale: 4,
      hold1: 7,
      exhale: 8,
      hold2: 0,
      description: 'Promotes deep relaxation and helps with sleep. Excellent for calming anxiety.',
      color: Colors.purple[200]!,
    ),
    'Deep Belly': BreathingTechnique(
      name: 'Deep Belly',
      inhale: 6,
      hold1: 2,
      exhale: 6,
      hold2: 2,
      description: 'Gentle diaphragmatic breathing that activates the body\'s relaxation response.',
      color: Colors.green[200]!,
    ),
    'Calming Breath': BreathingTechnique(
      name: 'Calming Breath',
      inhale: 4,
      hold1: 2,
      exhale: 6,
      hold2: 2,
      description: 'Extended exhale helps activate the parasympathetic nervous system for deep calm.',
      color: Colors.deepOrange[200]!,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercises'),
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
            'Breathe and Relax',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
              
              const SizedBox(height: 28),
              
              // Cycles Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Session Length',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
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
              
              const SizedBox(height: 20),
              
              // Techniques List
              Text(
                'Choose Your Technique',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BreathingSessionPage(
                  technique: technique,
                  totalCycles: selectedCycles,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Technique Icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: technique.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.air,
                    color: technique.color,
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
                        technique.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getTechniquePattern(technique),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: technique.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        technique.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
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
                  decoration: BoxDecoration(
                    color: technique.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: technique.color,
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
