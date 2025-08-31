import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PhysicalGroundingPage extends StatefulWidget {
  const PhysicalGroundingPage({super.key});

  @override
  State<PhysicalGroundingPage> createState() => _PhysicalGroundingPageState();
}

class _PhysicalGroundingPageState extends State<PhysicalGroundingPage> {
  String selectedTechnique = 'temperature';
  bool isActive = false;
  int currentStep = 0;
  Timer? exerciseTimer;
  int countdown = 0;
  
  final Map<String, PhysicalTechnique> techniques = {
    'temperature': PhysicalTechnique(
      name: 'Temperature Reset',
      description: 'Use temperature to bring focus to the present',
      icon: Icons.ac_unit,
      color: const Color(0xFF5FB3BF),
      steps: [
        'Find something cold to hold (ice cube, cold water, etc.)',
        'Hold the cold object for 30 seconds',
        'Focus on the sensation of cold',
        'Notice how it affects your breathing',
        'Take 3 deep breaths while holding the cold object',
      ],
      duration: 5,
    ),
    'muscle': PhysicalTechnique(
      name: 'Progressive Muscle Relaxation',
      description: 'Tense and release muscle groups systematically',
      icon: Icons.fitness_center,
      color: const Color(0xFF8B5FBF),
      steps: [
        'Start with your hands - make tight fists',
        'Hold tension for 5 seconds, then release',
        'Move to shoulders - lift them to your ears',
        'Hold for 5 seconds, then let them drop',
        'Tense leg muscles for 5 seconds, then relax',
        'Notice the contrast between tension and relaxation',
      ],
      duration: 6,
    ),
    'finger': PhysicalTechnique(
      name: '5-Finger Grounding',
      description: 'Touch each finger while focusing on positives',
      icon: Icons.back_hand,
      color: const Color(0xFF7FB35F),
      steps: [
        'Touch your thumb to your index finger',
        'Name something you\'re grateful for',
        'Touch thumb to middle finger',
        'Name a positive quality about yourself',
        'Touch thumb to ring finger',
        'Name someone who cares about you',
        'Touch thumb to pinky',
        'Name something you\'re looking forward to',
        'Repeat the cycle 3 times',
      ],
      duration: 9,
    ),
  };

  List<String> fingerPrompts = [
    'Something you\'re grateful for',
    'A positive quality about yourself',
    'Someone who cares about you',
    'Something you\'re looking forward to',
  ];

  List<String> userResponses = [];

  @override
  void dispose() {
    exerciseTimer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      isActive = true;
      currentStep = 0;
      userResponses.clear();
    });
    
    if (selectedTechnique == 'muscle') {
      _startProgressiveMuscleRelaxation();
    } else if (selectedTechnique == 'finger') {
      _startFingerGrounding();
    } else {
      _startTemperatureReset();
    }
  }

  void _startProgressiveMuscleRelaxation() {
    final technique = techniques[selectedTechnique]!;
    _runStepByStep(technique);
  }

  void _startTemperatureReset() {
    final technique = techniques[selectedTechnique]!;
    _runStepByStep(technique);
  }

  void _startFingerGrounding() {
    // This will be handled differently with user input
    setState(() {
      currentStep = 0;
    });
  }

  void _runStepByStep(PhysicalTechnique technique) {
    if (currentStep >= technique.steps.length) {
      _completeExercise();
      return;
    }

    // For muscle relaxation, add haptic feedback
    if (selectedTechnique == 'muscle' && (currentStep == 1 || currentStep == 3 || currentStep == 4)) {
      HapticFeedback.mediumImpact();
    }

    // Auto-advance after a delay for non-interactive steps
    if (selectedTechnique != 'finger') {
      Timer(const Duration(seconds: 8), () {
        if (isActive && currentStep < technique.steps.length - 1) {
          setState(() {
            currentStep++;
          });
          _runStepByStep(technique);
        } else if (isActive) {
          _completeExercise();
        }
      });
    }
  }

  void _nextFingerStep() {
    if (currentStep < fingerPrompts.length) {
      setState(() {
        currentStep++;
      });
    } else {
      _completeExercise();
    }
  }

  void _addFingerResponse(String response) {
    setState(() {
      userResponses.add(response);
    });
    _nextFingerStep();
  }

  void _completeExercise() {
    setState(() {
      isActive = false;
    });
    
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Well Done! 🌟'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You\'ve completed the ${techniques[selectedTechnique]!.name} exercise.'),
            const SizedBox(height: 12),
            const Text('Take a moment to notice how your body feels now.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetExercise();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _resetExercise() {
    setState(() {
      isActive = false;
      currentStep = 0;
      userResponses.clear();
    });
    exerciseTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final technique = techniques[selectedTechnique]!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text('Physical Grounding'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isActive)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetExercise,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                    technique.color.withOpacity(0.1),
                    technique.color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                  children: [
                    Icon(
                    Icons.info_outline,
                    color: technique.color,
                    size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                    child: Text(
                      'Use your body to anchor yourself in the present',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    ),
                  ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                if (!isActive) ...[
                  // Technique Selector
                  Text(
                    'Choose Your Technique',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ...techniques.entries.map((entry) {
                    final key = entry.key;
                    final tech = entry.value;
                    final isSelected = selectedTechnique == key;
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedTechnique = key;
                            });
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? tech.color.withOpacity(0.1) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? tech.color : Colors.grey[300]!,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: tech.color.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    tech.icon,
                                    color: tech.color,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tech.name,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? tech.color : null,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        tech.description,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${tech.duration} minutes',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: tech.color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    color: tech.color,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 24),
                  
                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _startExercise,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: technique.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Start ${technique.name}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ] else ...[
                  // Active Exercise
                  _buildActiveExercise(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildActiveExercise() {
    final technique = techniques[selectedTechnique]!;
    
    if (selectedTechnique == 'finger') {
      return _buildFingerGroundingExercise();
    }
    
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
            children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Use Flexible to prevent overflow on small screens
                  Flexible(
                  child: Text(
                    technique.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                  'Step ${currentStep + 1}/${technique.steps.length}',
                  style: TextStyle(
                    color: technique.color,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ],
                ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: (currentStep + 1) / technique.steps.length,
                backgroundColor: technique.color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(technique.color),
                minHeight: 8,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Current step
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 300),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: technique.color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: technique.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  technique.icon,
                  size: 48,
                  color: technique.color,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                currentStep < technique.steps.length 
                  ? technique.steps[currentStep]
                  : 'Exercise Complete!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.6,
                ),
              ),
              
              const SizedBox(height: 32),
              
              if (selectedTechnique == 'muscle' && 
                  (currentStep == 1 || currentStep == 3 || currentStep == 4))
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: technique.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.vibration,
                        color: technique.color,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Feel the vibration feedback',
                        style: TextStyle(
                          color: technique.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Next button for manual progression
        if (selectedTechnique != 'muscle' && selectedTechnique != 'temperature')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (currentStep < technique.steps.length - 1) {
                  setState(() {
                    currentStep++;
                  });
                } else {
                  _completeExercise();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: technique.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentStep < technique.steps.length - 1 ? 'Next Step' : 'Complete',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildFingerGroundingExercise() {
    final technique = techniques['finger']!;
    
    return Column(
      children: [
        // Progress
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
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
            children: [
              Text(
                '5-Finger Grounding',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Touch your thumb to each finger and share something positive',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        if (currentStep < fingerPrompts.length)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: technique.color.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: technique.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.back_hand,
                    size: 48,
                    color: technique.color,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Touch thumb to ${_getFingerName(currentStep)}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  'Think of: ${fingerPrompts[currentStep]}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: technique.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your response here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: technique.color, width: 2),
                    ),
                  ),
                  onSubmitted: _addFingerResponse,
                ),
                
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _addFingerResponse('(Skipped)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: technique.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Next Finger'),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                Text(
                  'Your Positive Reflections:',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: userResponses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: technique.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fingerPrompts[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: technique.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(userResponses[index]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _completeExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: technique.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Complete Exercise'),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  String _getFingerName(int index) {
    switch (index) {
      case 0: return 'index finger';
      case 1: return 'middle finger';
      case 2: return 'ring finger';
      case 3: return 'pinky finger';
      default: return 'finger';
    }
  }
}

class PhysicalTechnique {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> steps;
  final int duration;

  PhysicalTechnique({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.steps,
    required this.duration,
  });
}
