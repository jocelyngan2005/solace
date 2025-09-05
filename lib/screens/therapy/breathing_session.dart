import 'package:flutter/material.dart';
import 'dart:async';
import 'soundtrack_library.dart';

class BreathingSessionPage extends StatefulWidget {
  final BreathingTechnique technique;
  final int totalCycles;
  final String? selectedSoundtrack;

  const BreathingSessionPage({
    super.key,
    required this.technique,
    required this.totalCycles,
    this.selectedSoundtrack,
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
  Timer? _sessionTimer;
  
  String currentPhase = 'Tap to Start';
  int currentCycle = 0;
  bool isActive = false;
  bool isPaused = false;
  int remainingSeconds = 0;
  int totalSessionSeconds = 0;
  int elapsedSessionSeconds = 0;
  String? selectedSoundtrack;
  Set<String> favoriteSoundtracks = {};
  
  // Colors for different phases
  List<Color> phaseColors = [
    Colors.purple,
    Colors.orange, 
    Colors.green,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    
    selectedSoundtrack = widget.selectedSoundtrack;
    
    // Calculate total session time
    int cycleTime = widget.technique.inhale + widget.technique.hold1 + 
                   widget.technique.exhale + widget.technique.hold2;
    totalSessionSeconds = cycleTime * widget.totalCycles;
    
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
      end: 1.30,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // Initialize with a default color, will be updated after build
    _colorAnimation = ColorTween(
      begin: Colors.orange,
      end: Colors.orange,
    ).animate(_colorController);
    
    // Initialize phase colors after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          phaseColors = [
            Theme.of(context).colorScheme.primary,    // Inhale - Purple
            Theme.of(context).colorScheme.tertiary,   // Hold - Orange
            Theme.of(context).colorScheme.secondary,  // Exhale - Green
            Theme.of(context).colorScheme.tertiary,   // Hold - Orange
          ];
          
          // Update the color animation with theme colors
          _colorAnimation = ColorTween(
            begin: Theme.of(context).colorScheme.tertiary,
            end: Theme.of(context).colorScheme.tertiary,
          ).animate(_colorController);
        });
      }
    });
  }

  String _getSoundtrackName() {
    switch (selectedSoundtrack) {
      case 'mountain_stream':
        return 'Mountain Stream';
      case 'zen_garden':
        return 'Zen Garden';
      case 'chirping_birds':
        return 'Chirping Birds';
      case 'starry_night':
        return 'Starry Night';
      case 'ocean':
        return 'Ocean Waves';
      case 'rain':
        return 'Rain Drops';
      case 'forest':
        return 'Forest Ambience';
      case 'wind':
        return 'Gentle Wind';
      case 'fireplace':
        return 'Fireplace';
      case 'none':
        return 'No Sound';
      default:
        return 'No Sound';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _colorController.dispose();
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isActive || isPaused) {
        return;
      }
      
      setState(() {
        elapsedSessionSeconds++;
      });
      
      if (elapsedSessionSeconds >= totalSessionSeconds) {
        timer.cancel();
      }
    });
  }

  void _pauseSession() {
    setState(() {
      isPaused = !isPaused;
    });
    
    if (isPaused) {
      _animationController.stop();
      _countdownTimer?.cancel();
    } else {
      // Resume animation and timer
      if (currentPhase == 'Breathe In') {
        _animationController.forward();
      } else if (currentPhase == 'Breathe Out') {
        _animationController.reverse();
      }
    }
  }

  void _restartSession() {
    setState(() {
      isActive = false;
      isPaused = false;
      currentPhase = 'Tap to Start';
      currentCycle = 0;
      remainingSeconds = 0;
      elapsedSessionSeconds = 0;
    });
    _animationController.reset();
    _breathingTimer?.cancel();
    _countdownTimer?.cancel();
    _sessionTimer?.cancel();
    
    // Reset to initial color
    _updatePhaseColor(0);
  }

  void _toggleFavorite() {
    if (selectedSoundtrack != null && selectedSoundtrack != 'none') {
      setState(() {
        if (favoriteSoundtracks.contains(selectedSoundtrack)) {
          favoriteSoundtracks.remove(selectedSoundtrack);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getSoundtrackName()} removed from favorites'),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          favoriteSoundtracks.add(selectedSoundtrack!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getSoundtrackName()} added to favorites'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    }
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
      if (!isActive || isPaused) {
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
      _pauseSession();
      return;
    }

    setState(() {
      isActive = true;
      isPaused = false;
      currentCycle = 0;
      currentPhase = 'Get Ready...';
      elapsedSessionSeconds = 0;
    });

    // Start session timer
    _startSessionTimer();

    // Update animation duration for inhale phase
    _animationController.duration = Duration(seconds: widget.technique.inhale);
    
    // Start with a 2-second preparation
    Timer(const Duration(seconds: 2), () {
      if (mounted && isActive && !isPaused) _runBreathingCycle();
    });
  }

  void _runBreathingCycle() {
    if (!isActive || isPaused || currentCycle >= widget.totalCycles) {
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
      if (!isActive || !mounted || isPaused) return;
      
      // Hold phase 1
      if (widget.technique.hold1 > 0) {
        setState(() {
          currentPhase = 'Hold';
        });
        _updatePhaseColor(1); // Green for hold
        _startCountdown(widget.technique.hold1);
        
        Timer(Duration(seconds: widget.technique.hold1), () {
          if (!isActive || !mounted || isPaused) return;
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
      if (!isActive || !mounted || isPaused) return;
      
      // Hold phase 2
      if (widget.technique.hold2 > 0) {
        setState(() {
          currentPhase = 'Hold';
        });
        _updatePhaseColor(3); // Green for hold
        _startCountdown(widget.technique.hold2);
        
        Timer(Duration(seconds: widget.technique.hold2), () {
          if (!isActive || !mounted || isPaused) return;
          _runBreathingCycle();
        });
      } else {
        _runBreathingCycle();
      }
    });
  }

  void _completeExercise() {
    setState(() {
      isActive = false;
      isPaused = false;
      currentPhase = 'Complete!';
    });
    _animationController.reset();
    _sessionTimer?.cancel();
    
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          currentPhase = 'Tap to Start';
          currentCycle = 0;
          elapsedSessionSeconds = 0;
        });
        _updatePhaseColor(0);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Great job! You completed the breathing exercise.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = _colorAnimation.value ?? (phaseColors.isNotEmpty ? phaseColors[0] : Theme.of(context).colorScheme.tertiary);
    
    // Calculate progress percentage
    double progress = totalSessionSeconds > 0 ? elapsedSessionSeconds / totalSessionSeconds : 0.0;
    progress = progress.clamp(0.0, 1.0);
    
    // Format time
    String formatTime(int seconds) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    
    return Scaffold(
      backgroundColor: currentColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Top section with sound and heart icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sound selector
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SoundtrackLibrary(
                            selectedSoundtrack: selectedSoundtrack,
                            favoriteSoundtracks: favoriteSoundtracks,
                            onSoundtrackSelected: (soundtrack) {
                              Navigator.pop(context, soundtrack);
                            },
                            onFavoritesUpdated: (favorites) {
                              setState(() {
                                favoriteSoundtracks = favorites;
                              });
                            },
                          ),
                        ),
                      );
                      
                      if (result != null) {
                        setState(() {
                          selectedSoundtrack = result;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.volume_up,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'SOUND: ${_getSoundtrackName().toUpperCase()}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Heart/favorite icon
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        selectedSoundtrack != null && 
                        selectedSoundtrack != 'none' && 
                        favoriteSoundtracks.contains(selectedSoundtrack)
                          ? Icons.favorite
                          : Icons.favorite_border,
                        color: selectedSoundtrack != null && 
                               selectedSoundtrack != 'none' && 
                               favoriteSoundtracks.contains(selectedSoundtrack)
                          ? Colors.red
                          : Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              
              // Main breathing circle
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _startBreathingExercise,
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_scaleAnimation, _colorAnimation]),
                      builder: (context, child) {
                        return SizedBox(
                          width: 340,
                          height: 340,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer circle
                              Container(
                                width: 340 * (_scaleAnimation.value * 0.93),
                                height: 340 * (_scaleAnimation.value * 0.93),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                                ),
                              ),
                              
                              Container(
                                width: 280 * (_scaleAnimation.value * 0.95),
                                height: 280 * (_scaleAnimation.value * 0.95),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.15),
                                ),
                              ),

                              // Middle circle
                              Container(
                                width: 220 * (_scaleAnimation.value * 0.97),
                                height: 220 * (_scaleAnimation.value * 0.97),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                                ),
                              ),
                              
                              // Inner circle
                              Container(
                                width: 160 * _scaleAnimation.value,
                                height: 160 * _scaleAnimation.value,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.25),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        currentPhase,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
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
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Progress bar section
              Column(
                children: [
                  // Time display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTime(elapsedSessionSeconds),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatTime(totalSessionSeconds),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Progress bar
                  Container(
                    height: 4,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width * 0.85 * progress,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Control panel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Restart button
                  GestureDetector(
                    onTap: _restartSession,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 32,
                      ),
                    ),
                  ),
                  
                  // Play/pause button (larger)
                  GestureDetector(
                    onTap: _startBreathingExercise,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isActive && !isPaused ? Icons.pause : Icons.play_arrow,
                        color: currentColor,
                        size: 36,
                      ),
                    ),
                  ),
                  
                  // Cycle counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      '$currentCycle/${widget.totalCycles}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}class BreathingTechnique {
  final String name;
  final int inhale;
  final int hold1;
  final int exhale;
  final int hold2;
  final String description;

  BreathingTechnique({
    required this.name,
    required this.inhale,
    required this.hold1,
    required this.exhale,
    required this.hold2,
    required this.description,
  });
}
