import 'package:flutter/material.dart';
import 'dart:async';

class BreathingSessionPage extends StatefulWidget {
  final BreathingTechnique technique;
  final int totalCycles;

  const BreathingSessionPage({
    super.key,
    required this.technique,
    required this.totalCycles,
  });

  @override
  State<BreathingSessionPage> createState() => _BreathingSessionPageState();
}

class _BreathingSessionPageState extends State<BreathingSessionPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _colorController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  Timer? _breathingTimer;
  Timer? _countdownTimer;
  
  String currentPhase = 'Tap to Start';
  int currentCycle = 0;
  bool isActive = false;
  int remainingSeconds = 0;
  
  // Colors for different phases
  late final List<Color> phaseColors;

  @override
  void initState() {
    super.initState();
    
    // Initialize phase colors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        phaseColors = [
          Theme.of(context).colorScheme.primary,    // Inhale - Purple
          Theme.of(context).colorScheme.tertiary,  // Hold - Orange
          Theme.of(context).colorScheme.secondary,   // Exhale - Green
          Theme.of(context).colorScheme.tertiary,  // Hold - Oranges
        ];
      });
    });
    
    _animationController = AnimationController(
      duration: Duration(seconds: widget.technique.inhale),
      vsync: this,
    );
    
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _colorAnimation = ColorTween(
      begin: widget.technique.color,
      end: widget.technique.color,
    ).animate(_colorController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _colorController.dispose();
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _updatePhaseColor(int phaseIndex) {
    if (phaseColors.isNotEmpty) {
      _colorAnimation = ColorTween(
        begin: _colorAnimation.value,
        end: phaseColors[phaseIndex % phaseColors.length],
      ).animate(_colorController);
      
      _colorController.reset();
      _colorController.forward();
    }
  }

  void _startCountdown(int seconds) {
    setState(() {
      remainingSeconds = seconds;
    });
    
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isActive) {
        timer.cancel();
        return;
      }
      
      setState(() {
        remainingSeconds--;
      });
      
      if (remainingSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  void _startBreathingExercise() {
    if (isActive) {
      _stopBreathingExercise();
      return;
    }

    setState(() {
      isActive = true;
      currentCycle = 0;
      currentPhase = 'Get Ready...';
    });

    // Update animation duration for inhale phase
    _animationController.duration = Duration(seconds: widget.technique.inhale);
    
    // Start with a 2-second preparation
    Timer(const Duration(seconds: 2), () {
      if (mounted) _runBreathingCycle();
    });
  }

  void _runBreathingCycle() {
    if (!isActive || currentCycle >= widget.totalCycles) {
      _completeExercise();
      return;
    }

    setState(() {
      currentCycle++;
    });

    // Inhale phase
    setState(() {
      currentPhase = 'Breathe In';
    });
    _updatePhaseColor(0); // Purple for inhale
    _animationController.duration = Duration(seconds: widget.technique.inhale);
    _animationController.forward();
    _startCountdown(widget.technique.inhale);
    
    Timer(Duration(seconds: widget.technique.inhale), () {
      if (!isActive || !mounted) return;
      
      // Hold phase 1
      if (widget.technique.hold1 > 0) {
        setState(() {
          currentPhase = 'Hold';
        });
        _updatePhaseColor(1); // Green for hold
        _startCountdown(widget.technique.hold1);
        
        Timer(Duration(seconds: widget.technique.hold1), () {
          if (!isActive || !mounted) return;
          _exhalePhase();
        });
      } else {
        _exhalePhase();
      }
    });
  }

  void _exhalePhase() {
    // Exhale phase
    setState(() {
      currentPhase = 'Breathe Out';
    });
    _updatePhaseColor(2); // Orange for exhale
    _animationController.duration = Duration(seconds: widget.technique.exhale);
    _animationController.reverse();
    _startCountdown(widget.technique.exhale);
    
    Timer(Duration(seconds: widget.technique.exhale), () {
      if (!isActive || !mounted) return;
      
      // Hold phase 2
      if (widget.technique.hold2 > 0) {
        setState(() {
          currentPhase = 'Hold';
        });
        _updatePhaseColor(3); // Green for hold
        _startCountdown(widget.technique.hold2);
        
        Timer(Duration(seconds: widget.technique.hold2), () {
          if (!isActive || !mounted) return;
          _runBreathingCycle();
        });
      } else {
        _runBreathingCycle();
      }
    });
  }

  void _stopBreathingExercise() {
    setState(() {
      isActive = false;
      currentPhase = 'Tap to Start';
      currentCycle = 0;
      remainingSeconds = 0;
    });
    _animationController.reset();
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    
    // Reset to initial color
    _updatePhaseColor(0);
  }

  void _completeExercise() {
    setState(() {
      isActive = false;
      currentPhase = 'Complete!';
    });
    _animationController.reset();
    
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentPhase = 'Tap to Start';
          currentCycle = 0;
        });
        _updatePhaseColor(0);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Great job! You completed the breathing exercise.')),
    );
  }

  String _getTechniquePattern() {
    List<String> pattern = [];
    pattern.add('${widget.technique.inhale}s in');
    if (widget.technique.hold1 > 0) pattern.add('${widget.technique.hold1}s hold');
    pattern.add('${widget.technique.exhale}s out');
    if (widget.technique.hold2 > 0) pattern.add('${widget.technique.hold2}s hold');
    return pattern.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _colorAnimation.value ?? (phaseColors.isNotEmpty ? phaseColors[0] : widget.technique.color);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.technique.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: _colorAnimation.value ?? (phaseColors.isNotEmpty ? phaseColors[0] : widget.technique.color),
        ),
        child: SafeArea(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
                Center(
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                    Icons.multitrack_audio_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                    child: Text(
                      'SOUND OF BIRDS CHIRPING',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        ),
                    ),
                    ),
                  ],
                  ),
                ),
                ),
              
              const SizedBox(height: 18),
              
              // Breathing Animation
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        // Progress indicator
                        if (isActive)
                          Text(
                            'Cycle $currentCycle of ${widget.totalCycles}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),                      
                        const SizedBox(height: 36),
                      
                        // Breathing circle with concentric circles
                        GestureDetector(
                          onTap: _startBreathingExercise,
                          child: AnimatedBuilder(
                            animation: Listenable.merge([_scaleAnimation, _colorAnimation]),
                            builder: (context, child) {
                              return SizedBox(
                                width: 300,
                                height: 300,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // Outer circle (largest) - slight delay
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 100),
                                      width: 240 * (_scaleAnimation.value * 0.95),
                                      height: 240 * (_scaleAnimation.value * 0.95),
                                      decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.25),
                                        blurRadius: 32,
                                        spreadRadius: 8,
                                        offset: Offset(0, 0),
                                        ),
                                      ],
                                      ),
                                    ),
                                    
                                    
                                    // Second circle
                                    Container(
                                      width: 200 * (_scaleAnimation.value * 0.97),
                                      height: 200 * (_scaleAnimation.value * 0.97),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    
                                    // Third circle
                                    Container(
                                      width: 160 * (_scaleAnimation.value * 0.99),
                                      height: 160 * (_scaleAnimation.value * 0.99),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.25),
                                          width: 2.5,
                                        ),
                                      ),
                                    ),
                                    
                                    // Fourth circle - main rhythm
                                    Container(
                                      width: 120 * _scaleAnimation.value,
                                      height: 120 * _scaleAnimation.value,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                                          width: 2.7,
                                        ),
                                      ),
                                    ),
                                    
                                    // Inner filled circle (center) - most responsive
                                    Container(
                                      width: 80 * (_scaleAnimation.value * 1.05),
                                      height: 80 * (_scaleAnimation.value * 1.05),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
                                        
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // Countdown timer in center
                                            if (isActive && remainingSeconds > 0)
                                              Text(
                                                '$remainingSeconds',
                                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).colorScheme.onPrimary,
                                                  fontSize: 36,
                                                ),
                                              )
                                            else
                                              Icon(
                                                isActive ? Icons.pause : Icons.play_arrow,
                                                size: 36,
                                                color: Theme.of(context).colorScheme.onPrimary,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Phase indicator
                        Text(
                          currentPhase,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Instructions
                        if (!isActive)
                          Text(
                            'Tap the circle to begin your breathing session',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          )
                        else
                          Text(
                            'Follow the circle\'s rhythm • Tap to stop',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                            textAlign: TextAlign.center,
                          ),
                    ],
                  ),
                ),
              ),
              
              // Control Button
              if (isActive)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: _stopBreathingExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onSurface,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Stop Session',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    )
    );

  }
}

class BreathingTechnique {
  final String name;
  final int inhale;
  final int hold1;
  final int exhale;
  final int hold2;
  final String description;
  final Color color;

  BreathingTechnique({
    required this.name,
    required this.inhale,
    required this.hold1,
    required this.exhale,
    required this.hold2,
    required this.description,
    required this.color,
  });
}
