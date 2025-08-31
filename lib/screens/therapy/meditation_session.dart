import 'package:flutter/material.dart';
import 'dart:async';

class MeditationSessionPage extends StatefulWidget {
  final MeditationSession session;
  
  const MeditationSessionPage({super.key, required this.session});

  @override
  State<MeditationSessionPage> createState() => _MeditationSessionPageState();
}

class _MeditationSessionPageState extends State<MeditationSessionPage>
    with TickerProviderStateMixin {
  
  // Audio/Video Player State
  bool isPlaying = false;
  bool isLoading = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = const Duration(minutes: 5); // Default duration
  bool isFavorite = false; // Add favorite state
  
  // Timer for progress simulation
  Timer? _progressTimer;
  
  // Animation Controllers
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  // Playlist
  int currentTrackIndex = 0;
  List<MeditationTrack> playlist = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    // Initialize playlist based on session
    _initializePlaylist();
    
    // Set duration based on session
    _parseDuration(widget.session.duration);
  }

  void _initializePlaylist() {
    // Create playlist based on session category
    switch (widget.session.category) {
      case 'Stress Relief':
        playlist = [
          MeditationTrack(
            title: 'Breathing Foundation',
            duration: const Duration(minutes: 1),
            description: 'Focus on your breath',
          ),
          MeditationTrack(
            title: 'Body Scan',
            duration: const Duration(minutes: 2),
            description: 'Release tension from head to toe',
          ),
          MeditationTrack(
            title: 'Peaceful Visualization',
            duration: const Duration(minutes: 2),
            description: 'Imagine a calm, peaceful place',
          ),
        ];
        break;
      case 'Exam Anxiety':
        playlist = [
          MeditationTrack(
            title: 'Confidence Building',
            duration: const Duration(minutes: 1),
            description: 'Affirmations for success',
          ),
          MeditationTrack(
            title: 'Mental Clarity',
            duration: const Duration(minutes: 2),
            description: 'Clear your mind for focus',
          ),
        ];
        break;
      case 'Sleep Aid':
        playlist = [
          MeditationTrack(
            title: 'Progressive Relaxation',
            duration: const Duration(minutes: 3),
            description: 'Relax each muscle group',
          ),
          MeditationTrack(
            title: 'Sleep Stories',
            duration: const Duration(minutes: 4),
            description: 'Gentle stories for sleep',
          ),
          MeditationTrack(
            title: 'Dream Preparation',
            duration: const Duration(minutes: 3),
            description: 'Prepare for restful sleep',
          ),
        ];
        break;
      default:
        playlist = [
          MeditationTrack(
            title: widget.session.title,
            duration: totalDuration,
            description: widget.session.description,
          ),
        ];
    }
  }

  void _parseDuration(String duration) {
    final minutes = int.tryParse(duration.replaceAll(RegExp(r'[^\d]'), '')) ?? 5;
    totalDuration = Duration(minutes: minutes);
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _pauseSession();
      } else {
        _playSession();
      }
    });
  }

  void _playSession() {
    isPlaying = true;
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
    
    // Simulate progress
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentPosition = Duration(seconds: currentPosition.inSeconds + 1);
        
        // Check if current track is finished
        if (currentPosition >= playlist[currentTrackIndex].duration) {
          _nextTrack();
        }
      });
    });
  }

  void _pauseSession() {
    isPlaying = false;
    _pulseController.stop();
    _rotationController.stop();
    _progressTimer?.cancel();
  }

  void _nextTrack() {
    if (currentTrackIndex < playlist.length - 1) {
      setState(() {
        currentTrackIndex++;
        currentPosition = Duration.zero;
      });
    } else {
      // Session completed
      _completeSession();
    }
  }

  void _previousTrack() {
    if (currentTrackIndex > 0) {
      setState(() {
        currentTrackIndex--;
        currentPosition = Duration.zero;
      });
    }
  }

  void _completeSession() {
    _pauseSession();
    setState(() {
      currentPosition = totalDuration;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete! 🧘‍♀️'),
        content: const Text('Congratulations! You\'ve completed your meditation session. Take a moment to notice how you feel.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Finish'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _restartSession();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.session.color,
              foregroundColor: Colors.white,
            ),
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _restartSession() {
    setState(() {
      currentTrackIndex = 0;
      currentPosition = Duration.zero;
      isPlaying = false;
    });
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite 
            ? 'Added to favorites!' 
            : 'Removed from favorites',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: widget.session.color,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds % 60);
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final currentTrack = playlist[currentTrackIndex];
    final progress = currentPosition.inSeconds / currentTrack.duration.inSeconds;
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.session.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Meditation Visual
              Expanded(
                flex: 2,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value * 2 * 3.14159,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      widget.session.color.withOpacity(0.8),
                                      widget.session.color.withOpacity(0.4),
                                      widget.session.color.withOpacity(0.1),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.session.color.withOpacity(0.3),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.music_note,
                                    size: 60,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Track Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      currentTrack.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentTrack.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Progress Bar
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(widget.session.color),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(currentPosition),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDuration(currentTrack.duration),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Playlist Button
                  IconButton(
                    onPressed: _showPlaylist,
                    icon: const Icon(
                      Icons.playlist_play,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Previous Track
                  IconButton(
                    onPressed: currentTrackIndex > 0 ? _previousTrack : null,
                    icon: Icon(
                      Icons.skip_previous,
                      color: currentTrackIndex > 0 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.3),
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Play/Pause Button
                  GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.session.color,
                        boxShadow: [
                          BoxShadow(
                            color: widget.session.color.withOpacity(0.3),
                            blurRadius: 18,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Next Track
                  IconButton(
                    onPressed: currentTrackIndex < playlist.length - 1 ? _nextTrack : null,
                    icon: Icon(
                      Icons.skip_next,
                      color: currentTrackIndex < playlist.length - 1 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.3),
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Favorite Button
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite 
                        ? Colors.red.shade300 
                        : Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Playlist Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Track ${currentTrackIndex + 1} of ${playlist.length}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaylist() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.queue_music,
                    color: widget.session.color,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Meditation Playlist',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: playlist.length,
                itemBuilder: (context, index) {
                  final track = playlist[index];
                  final isCurrentTrack = index == currentTrackIndex;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isCurrentTrack 
                        ? widget.session.color.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: isCurrentTrack 
                        ? Border.all(color: widget.session.color, width: 1)
                        : null,
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCurrentTrack 
                            ? widget.session.color 
                            : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCurrentTrack && isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      title: Text(
                        track.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isCurrentTrack ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(
                        track.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      trailing: Text(
                        _formatDuration(track.duration),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          currentTrackIndex = index;
                          currentPosition = Duration.zero;
                        });
                        Navigator.pop(context);
                        if (!isPlaying) _togglePlayPause();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MeditationTrack {
  final String title;
  final Duration duration;
  final String description;

  MeditationTrack({
    required this.title,
    required this.duration,
    required this.description,
  });
}

// Import this in meditation_screen.dart
class MeditationSession {
  final String title;
  final String duration;
  final String category;
  final String description;
  final Color color;

  MeditationSession({
    required this.title,
    required this.duration,
    required this.category,
    required this.description,
    required this.color,
  });
}
