import 'package:flutter/material.dart';
import 'dart:async';

class MovementGroundingPage extends StatefulWidget {
  const MovementGroundingPage({super.key});

  @override
  State<MovementGroundingPage> createState() => _MovementGroundingPageState();
}

class _MovementGroundingPageState extends State<MovementGroundingPage>
    with TickerProviderStateMixin {
  String selectedExercise = 'walking';
  bool isActive = false;
  int currentStep = 0;
  Timer? exerciseTimer;
  int countdown = 0;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  final Map<String, MovementExercise> exercises = {
    'walking': MovementExercise(
      name: 'Mindful Walking',
      description: 'Focus on each step and your connection to the ground',
      icon: Icons.directions_walk,
      color: Colors.green,
      duration: 120, // 2 minutes
      instructions: [
        'Stand up straight and take a deep breath',
        'Begin walking at a slow, comfortable pace',
        'Focus on how your foot feels as it touches the ground',
        'Notice the weight shifting from heel to toe',
        'Feel the ground supporting each step',
        'Breathe naturally as you walk',
        'If your mind wanders, gently return focus to your steps',
      ],
    ),
    'stretch': MovementExercise(
      name: 'Stretch & Count',
      description: 'Slow stretching movements with mindful counting',
      icon: Icons.accessibility_new,
      color: Colors.blue,
      duration: 90, // 1.5 minutes
      instructions: [
        'Stand with feet shoulder-width apart',
        'Slowly raise your arms above your head (count 1-5)',
        'Hold the stretch and breathe deeply',
        'Slowly lower your arms (count 1-5)',
        'Gently roll your shoulders back (count 1-5)',
        'Stretch your neck side to side (count 1-5 each)',
        'Take 3 deep breaths to finish',
      ],
    ),
    'tapping': MovementExercise(
      name: 'Bilateral Tapping',
      description: 'Alternate tapping to reorient your nervous system',
      icon: Icons.touch_app,
      color: Colors.purple,
      duration: 60, // 1 minute
      instructions: [
        'Sit comfortably with feet flat on the floor',
        'Place hands on your thighs',
        'Gently tap your left thigh with your left hand',
        'Then tap your right thigh with your right hand',
        'Continue alternating left-right at a steady rhythm',
        'Focus on the sensation of each tap',
        'Breathe naturally throughout',
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    exerciseTimer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      isActive = true;
      currentStep = 0;
      countdown = exercises[selectedExercise]!.duration;
    });
    
    _pulseController.repeat(reverse: true);
    _runExercise();
  }

  void _runExercise() {
    final exercise = exercises[selectedExercise]!;
    final stepDuration = exercise.duration ~/ exercise.instructions.length;
    
    exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isActive) {
        timer.cancel();
        return;
      }
      
      setState(() {
        countdown--;
      });
      
      // Move to next step
      final elapsed = exercise.duration - countdown;
      final newStep = elapsed ~/ stepDuration;
      if (newStep != currentStep && newStep < exercise.instructions.length) {
        setState(() {
          currentStep = newStep;
        });
      }
      
      if (countdown <= 0) {
        timer.cancel();
        _completeExercise();
      }
    });
  }

  void _completeExercise() {
    setState(() {
      isActive = false;
    });
    
    _pulseController.stop();
    _pulseController.reset();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Movement Complete! 🌟'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You\'ve completed the ${exercises[selectedExercise]!.name} exercise.'),
            const SizedBox(height: 12),
            const Text('Notice how your body feels now. Do you feel more grounded and present?'),
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
    });
    exerciseTimer?.cancel();
    _pulseController.stop();
    _pulseController.reset();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final exercise = exercises[selectedExercise]!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movement Grounding'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isActive)
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: _resetExercise,
              tooltip: 'Stop',
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                   Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Use gentle movement to reconnect with your body',
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
                // Exercise Selector
                Text(
                  'Choose Your Movement',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...exercises.entries.map((entry) {
                  final key = entry.key;
                  final ex = entry.value;
                  final isSelected = selectedExercise == key;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedExercise = key;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? ex.color.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? ex.color : Colors.grey[300]!,
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
                                  color: ex.color.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  ex.icon,
                                  color: ex.color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ex.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? ex.color : null,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ex.description,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${ex.duration ~/ 60} minute${ex.duration >= 120 ? 's' : ''}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: ex.color,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: ex.color,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                
                const SizedBox(height: 18),
                
                // Preview Instructions
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.list_alt, color: exercise.color),
                          const SizedBox(width: 8),
                          Text(
                            'What you\'ll do:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...exercise.instructions.take(3).map((instruction) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 4,
                                height: 4,
                                margin: const EdgeInsets.only(top: 8, right: 8),
                                decoration: BoxDecoration(
                                  color: exercise.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(child: Text(instruction)),
                            ],
                          ),
                        ),
                      ),
                      if (exercise.instructions.length > 3)
                        Text(
                          '...and ${exercise.instructions.length - 3} more steps',
                          style: TextStyle(
                            color: exercise.color,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 18),
                
                // Start Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: exercise.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start ${exercise.name}',
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
    final exercise = exercises[selectedExercise]!;
    
    return Column(
      children: [
        // Timer and Progress
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    exercise.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatTime(countdown),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: exercise.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: (exercise.duration - countdown) / exercise.duration,
                backgroundColor: exercise.color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(exercise.color),
                minHeight: 8,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Current Instruction
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 300),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: exercise.color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: exercise.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          exercise.icon,
                          size: 48,
                          color: exercise.color,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Step indicator
                Text(
                  'Step ${currentStep + 1} of ${exercise.instructions.length}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: exercise.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Current instruction
                Text(
                  currentStep < exercise.instructions.length 
                    ? exercise.instructions[currentStep]
                    : 'Exercise Complete!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    height: 1.6,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Breathing reminder for certain exercises
                if (selectedExercise == 'walking' || selectedExercise == 'stretch')
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: exercise.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.air,
                          color: exercise.color,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Remember to breathe naturally',
                          style: TextStyle(
                            color: exercise.color,
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
        
        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _resetExercise,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MovementExercise {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final int duration; // in seconds
  final List<String> instructions;

  MovementExercise({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.duration,
    required this.instructions,
  });
}
