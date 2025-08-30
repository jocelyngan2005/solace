import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExercise extends StatefulWidget {
  const BreathingExercise({super.key});

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _colorController;
  late Animation<double> _breathingAnimation;
  late Animation<Color?> _colorAnimation;
  
  Timer? _timer;
  int _currentPhase = 0; // 0: Breathe In, 1: Hold, 2: Breathe Out, 3: Hold
  int _countdown = 4;
  bool _isActive = false;
  int _completedCycles = 0;
  
  final List<String> _phaseNames = ['Breathe In', 'Hold', 'Breathe Out', 'Hold'];
  final List<int> _phaseDurations = [4, 4, 6, 2]; // 4-4-6-2 breathing pattern
  final List<Color> _phaseColors = [
    const Color(0xFF81C784), // Light Green
    const Color(0xFF64B5F6), // Light Blue  
    const Color(0xFFBA68C8), // Light Purple
    const Color(0xFFFFB74D), // Light Orange
  ];

  @override
  void initState() {
    super.initState();
    
    _breathingController = AnimationController(
      duration: const Duration(seconds: 16), // Full cycle
      vsync: this,
    );
    
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: _phaseColors[0],
      end: _phaseColors[0],
    ).animate(_colorController);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _colorController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
      _currentPhase = 0;
      _countdown = _phaseDurations[0];
    });
    
    _updateColorAnimation();
    _breathingController.repeat();
    _startCountdown();
  }

  void _stopBreathing() {
    setState(() {
      _isActive = false;
    });
    _breathingController.stop();
    _timer?.cancel();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      
      if (_countdown == 0) {
        _nextPhase();
      }
    });
  }

  void _nextPhase() {
    setState(() {
      _currentPhase = (_currentPhase + 1) % 4;
      _countdown = _phaseDurations[_currentPhase];
      
      if (_currentPhase == 0) {
        _completedCycles++;
      }
    });
    
    _updateColorAnimation();
  }

  void _updateColorAnimation() {
    _colorAnimation = ColorTween(
      begin: _colorAnimation.value,
      end: _phaseColors[_currentPhase],
    ).animate(_colorController);
    
    _colorController.reset();
    _colorController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Exercise'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              (_colorAnimation.value ?? _phaseColors[0]).withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Breathing Circle
                  AnimatedBuilder(
                    animation: Listenable.merge([_breathingAnimation, _colorAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isActive ? _breathingAnimation.value : 1.0,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                (_colorAnimation.value ?? _phaseColors[0]).withOpacity(0.8),
                                (_colorAnimation.value ?? _phaseColors[0]).withOpacity(0.3),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (_colorAnimation.value ?? _phaseColors[0]).withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _isActive ? '$_countdown' : 'Ready',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Phase Instruction
                  Text(
                    _isActive ? _phaseNames[_currentPhase] : 'Tap to begin',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _colorAnimation.value ?? _phaseColors[0],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Instructions
                  if (!_isActive) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '4-4-6-2 Breathing Pattern',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Text('1. Breathe in for 4 seconds')),
                              Text('🟢'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Expanded(child: Text('2. Hold for 4 seconds')),
                              Text('🔵'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Expanded(child: Text('3. Breathe out for 6 seconds')),
                              Text('🟣'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Expanded(child: Text('4. Hold for 2 seconds')),
                              Text('🟠'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  if (_isActive) ...[
                    Text(
                      'Cycles completed: $_completedCycles',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Control Button
            Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isActive ? _stopBreathing : _startBreathing,
                  icon: Icon(_isActive ? Icons.stop : Icons.play_arrow),
                  label: Text(_isActive ? 'Stop Exercise' : 'Start Breathing'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: _isActive 
                      ? Colors.red[400]
                      : Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Tips
            if (!_isActive)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text(
                  'Find a comfortable position and focus on the circle. Let your breath match the rhythm.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
