import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PhysicalGroundingPage extends StatefulWidget {
  const PhysicalGroundingPage({super.key});

  @override
  State<PhysicalGroundingPage> createState() => _PhysicalGroundingPageState();
}

class _PhysicalGroundingPageState extends State<PhysicalGroundingPage>
    with TickerProviderStateMixin {
  String selectedTechnique = 'temperature';
  bool isActive = false;
  int currentStep = 0;
  Timer? exerciseTimer;
  Timer? stepTimer;
  int countdown = 0;
  int stepDuration = 8; // seconds per step
  bool isPaused = false;
  late AnimationController _timerController;
  late Animation<double> _timerAnimation;
  
  final Map<String, PhysicalTechnique> techniques = {
    'temperature': PhysicalTechnique(
      name: 'Temperature Reset',
      description: 'Use temperature to bring focus to the present',
      icon: Icons.thermostat_outlined,
      color: Color(0xFFA596F5),
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
      color: Color(0xFFA596F5),
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
      color: Color(0xFFA596F5),
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
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: Duration(seconds: stepDuration),
      vsync: this,
    );
    _timerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _timerController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    exerciseTimer?.cancel();
    stepTimer?.cancel();
    _timerController.dispose();
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

    // Reset and start the timer animation
    _timerController.reset();
    if (!isPaused) {
      _timerController.forward();
    }
    
    // Start countdown
    setState(() {
      countdown = stepDuration;
    });
    
    stepTimer?.cancel();
    stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isActive || isPaused) {
        if (isPaused) {
          _timerController.stop();
        }
        if (!isActive) {
          timer.cancel();
        }
        return;
      }
      
      setState(() {
        countdown--;
      });
      
      if (countdown <= 0) {
        timer.cancel();
      }
    });

    // For muscle relaxation, add haptic feedback
    if (selectedTechnique == 'muscle' && (currentStep == 1 || currentStep == 3 || currentStep == 4)) {
      HapticFeedback.mediumImpact();
    }

    // Auto-advance after the step duration
    Timer(Duration(seconds: stepDuration), () {
      if (isActive && !isPaused && currentStep < technique.steps.length - 1) {
        setState(() {
          currentStep++;
        });
        _runStepByStep(technique);
      } else if (isActive && !isPaused) {
        _completeExercise();
      }
    });
  }

  void _pauseResume() {
    setState(() {
      isPaused = !isPaused;
    });
    
    if (isPaused) {
      _timerController.stop();
      stepTimer?.cancel();
    } else {
      // Resume animation from current position
      _timerController.forward();
      
      // Resume step timer
      stepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!isActive || isPaused) {
          if (isPaused) {
            _timerController.stop();
          }
          if (!isActive) {
            timer.cancel();
          }
          return;
        }
        
        setState(() {
          countdown--;
        });
        
        if (countdown <= 0) {
          timer.cancel();
          // Auto-advance to next step
          final technique = techniques[selectedTechnique]!;
          if (currentStep < technique.steps.length - 1) {
            setState(() {
              currentStep++;
            });
            _runStepByStep(technique);
          } else {
            _completeExercise();
          }
        }
      });
    }
  }

  void _adjustStepDuration() {
    showDialog(
      context: context,
      builder: (context) {
        int tempDuration = stepDuration;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Adjust Step Duration'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Current duration: $tempDuration seconds'),
                  const SizedBox(height: 16),
                  Slider(
                    value: tempDuration.toDouble(),
                    min: 3,
                    max: 15,
                    divisions: 12,
                    label: '$tempDuration seconds',
                    onChanged: (value) {
                      setDialogState(() {
                        tempDuration = value.round();
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      stepDuration = tempDuration;
                      countdown = stepDuration;
                      _timerController.duration = Duration(seconds: stepDuration);
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _resetCurrentStep() {
    setState(() {
      countdown = stepDuration;
      isPaused = false;
    });
    _timerController.reset();
    _timerController.forward();
    
    stepTimer?.cancel();
    final technique = techniques[selectedTechnique]!;
    _runStepByStep(technique);
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
      countdown = 0;
      isPaused = false;
      userResponses.clear();
    });
    exerciseTimer?.cancel();
    stepTimer?.cancel();
    _timerController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final technique = techniques[selectedTechnique]!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Physical Grounding'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                
                if (!isActive) ...[            
                  // info 
                  Text(
                    'Use your body to anchor yourself in the present moment. Select a technique below to begin:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ), 
                  const SizedBox(height: 24),     
                  ...techniques.entries.map((entry) {
                    final key = entry.key;
                    final tech = entry.value;
                    final isSelected = selectedTechnique == key;
                    
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
                            setState(() {
                              selectedTechnique = key;
                            });
                          },
                          borderRadius: BorderRadius.circular(32),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: isSelected ? Border.all(
                                color: tech.color,
                                width: 2,
                              ) : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Icon container
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected 
                                          ? tech.color.withOpacity(0.15)
                                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      tech.icon,
                                      color: isSelected ? tech.color : Theme.of(context).colorScheme.onSurface,
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
                                          tech.name,
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: isSelected ? tech.color : null,
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
                                              '${tech.duration} steps',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.outline,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          tech.description,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                            height: 1.4,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Arrow or check icon
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
                                      size: 24,
                                      color: isSelected ? tech.color : Theme.of(context).colorScheme.outline,
                                    ),
                                  ),
                                ],
                              ),
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Start ',
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
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                  'Step ${currentStep + 1}/${technique.steps.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  ),
                ],
                ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: (currentStep + 1) / technique.steps.length,
                backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                minHeight: 8,
              ),
            ],
          ),
        ),
        // Current step
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 300),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Instructions first
              Text(
                currentStep < technique.steps.length 
                  ? technique.steps[currentStep]
                  : 'Exercise Complete!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500, 
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Visual Timer (only for temperature and muscle techniques)
              if (selectedTechnique == 'temperature' || selectedTechnique == 'muscle') ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Timer circle
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: AnimatedBuilder(
                        animation: _timerAnimation,
                        builder: (context, child) {
                          return CircularProgressIndicator(
                            value: _timerAnimation.value,
                            strokeWidth: 8,
                            backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                          );
                        },
                      ),
                    ),
                    // Countdown number
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$countdown',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 48,
                          ),
                        ),
                        Text(
                          'seconds',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),                
                // Control Panel
                Container(
                  padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Adjust button                      
                          IconButton(
                            onPressed: _adjustStepDuration,
                            icon: Icon(
                              Icons.tune,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                      
                      // Play/Pause button
                    
                          IconButton(
                            onPressed: _pauseResume,
                            icon: Icon(
                              isPaused ? Icons.play_arrow : Icons.pause,
                              color: Theme.of(context).colorScheme.primary,
                              size: 28,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.onPrimary,
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                      // Reset button                     
                          IconButton(
                            onPressed: _resetCurrentStep,
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                ),
              ] else ...[
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
              ],
              
              const SizedBox(height: 32),
              
              if (selectedTechnique == 'muscle' && 
                  (currentStep == 1 || currentStep == 3 || currentStep == 4))
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.vibration,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Feel the vibration feedback',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
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
        
        // Next button only for finger technique (manual progression)
        if (selectedTechnique == 'finger')
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
            color: Theme.of(context).colorScheme.surface,
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
        
        const SizedBox(height: 16),
        
        if (currentStep < fingerPrompts.length)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 400),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: technique.color.withOpacity(0.1),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: technique.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.back_hand_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.onPrimary,
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
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
              color: Theme.of(context).colorScheme.surface,
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
                  height: 280,
                  child: ListView.builder(
                    itemCount: userResponses.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fingerPrompts[index],
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
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
                      backgroundColor: const Color(0xFFFFCE5D),
                      foregroundColor: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
