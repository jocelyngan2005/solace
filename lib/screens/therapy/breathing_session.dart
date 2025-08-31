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
  late Animation<double> _scaleAnimation;
  Timer? _breathingTimer;
  Timer? _countdownTimer;
  
  String currentPhase = 'Tap to Start';
  int currentCycle = 0;
  bool isActive = false;
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: widget.technique.inhale),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
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
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Great job! You completed the breathing exercise.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),  
      appBar: AppBar(
        title: Text(widget.technique.name),
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
            children: [
              // Technique Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.technique.color.withOpacity(0.1),
                      widget.technique.color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          Text(
                            widget.technique.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${widget.totalCycles} cycles planned',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.technique.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                            color: widget.technique.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      
                      const SizedBox(height: 36),
                      
                      // Breathing circle
                      GestureDetector(
                        onTap: _startBreathingExercise,
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Container(
                              width: 180 * _scaleAnimation.value,
                              height: 180 * _scaleAnimation.value,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    widget.technique.color.withOpacity(0.4),
                                    widget.technique.color.withOpacity(0.2),
                                    widget.technique.color.withOpacity(0.1),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.technique.color.withOpacity(0.3),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.technique.color.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Countdown timer in center
                                      if (isActive && remainingSeconds > 0)
                                        Text(
                                          '$remainingSeconds',
                                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: widget.technique.color,
                                            fontSize: 36,
                                          ),
                                        )
                                      else
                                        Icon(
                                          isActive ? Icons.pause : Icons.play_arrow,
                                          size: 60,
                                          color: widget.technique.color,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 36),
                      
                      // Phase indicator
                      Text(
                        currentPhase,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: widget.technique.color,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Instructions
                      if (!isActive)
                        Text(
                          'Tap the circle to begin your breathing session',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        )
                      else
                        Text(
                          'Follow the circle\'s rhythm • Tap to stop',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
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
                      backgroundColor: Colors.red[400],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
