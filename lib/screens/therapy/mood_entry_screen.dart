import 'package:flutter/material.dart';
import '../../data/mood_entry_service.dart';

class MoodEntryScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  final String selectedMood;
  final bool fromHomeScreen;

  const MoodEntryScreen({
    super.key,
    required this.onCompleted,
    required this.selectedMood,
    this.fromHomeScreen = false,
  });

  @override
  State<MoodEntryScreen> createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends State<MoodEntryScreen> {
  double _moodRating = 3.0;
  late String _selectedMood;
  final TextEditingController _journalController = TextEditingController();
  final List<String> _selectedTags = [];
  bool _isVoiceMode = false;

  final Map<String, String> _moodEmojis = {
    'Very Low': '😢',
    'Low': '😔',
    'Neutral': '😐',
    'Good': '😊',
    'Excellent': '😄',
  };

  final List<String> _moodTags = [
    'Joyful',
    'Hopeful',
    'Amazed',
    'Relieved',
    'Confident',
    'Content',
    'Satisfied',
    'Happy',
    'Passionate',
    'Enthusiastic',
    'Excited',
    'Brave',
    'Proud',
    'Calm',
    'Curious',
    'Grateful',
    'Peaceful',
    'Relaxed',
    'Overwhelmed',
    'Motivated',
    'Inspired',
    'Indifferent',
    'Sad',
    'Angry',
    'Annoyed',
    'Anxious',
    'Scared',
    'Disgusted',
    'Jealous',
    'Guilty',
    'Embarrassed',
    'Disappointed',
    'Stressed',
    'Frustrated',
    'Hopeless',
    'Lonely',
    'Tired',
    'Depressed',
  ];

  final List<String> _reasonTags = [
    'Work',
    'Home',
    'School',
    'Outdoors',
    'Travel',
    'Weather',
    'Identity',
    'Partner',
    'Friends',
    'Pet',
    'Family',
    'Colleagues',
    'Dating',
    'Health',
    'Sleep',
    'Exercise',
    'Food',
    'Hobby',
    'Money'
  ];

  @override
  void initState() {
    super.initState();
    _selectedMood = widget.selectedMood;
    // Sync slider value with selectedMood
    switch (_selectedMood) {
      case 'Very Low':
        _moodRating = 1.0;
        break;
      case 'Low':
        _moodRating = 2.0;
        break;
      case 'Neutral':
        _moodRating = 3.0;
        break;
      case 'Good':
        _moodRating = 4.0;
        break;
      case 'Excellent':
        _moodRating = 5.0;
        break;
      default:
        _moodRating = 3.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mood Rating Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How are you feeling today?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),

                    // Mood emoji display
                    Center(
                      child: Column(
                        children: [
                          Text(
                            _moodEmojis[_selectedMood] ?? '😐',
                            style: const TextStyle(fontSize: 60),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _selectedMood,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Mood slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Theme.of(context).colorScheme.primary,
                        thumbColor: Theme.of(context).colorScheme.primary,
                        overlayColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: _moodRating,
                        min: 1.0,
                        max: 5.0,
                        divisions: 4,
                        onChanged: (value) {
                          setState(() {
                            _moodRating = value;
                            _updateSelectedMood();
                          });
                        },
                      ),
                    ),

                    // Mood scale labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Very Low',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          'Excellent',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Mood Tags Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What describes your mood?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _moodTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Reason Tags Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What made you feel this way?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _reasonTags.map((tag) {
                        final isSelected = _selectedTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Note Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Anything else to add?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _isVoiceMode = !_isVoiceMode;
                            });
                          },
                          icon: Icon(
                            _isVoiceMode ? Icons.keyboard : Icons.mic,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (_isVoiceMode)
                      _buildVoiceRecording()
                    else
                      TextField(
                        controller: _journalController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText:
                              'What\'s on your mind today? Add a note to help you remember this feeling or moment.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Complete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeEntry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Complete Check-in'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceRecording() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Voice recording (simulated)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to start recording your thoughts',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedMood() {
    if (_moodRating <= 1.5) {
      _selectedMood = 'Very Low';
    } else if (_moodRating <= 2.5) {
      _selectedMood = 'Low';
    } else if (_moodRating <= 3.5) {
      _selectedMood = 'Neutral';
    } else if (_moodRating <= 4.5) {
      _selectedMood = 'Good';
    } else {
      _selectedMood = 'Excellent';
    }
  }

  void _completeEntry() async {
    // Save mood entry completion status
    await MoodEntryService.markMoodEntryCompleted(moodLabel: _selectedMood);
    
    // Simulate saving the entry
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Entry Saved! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your daily check-in has been completed. Here\'s your AI insight:',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getAIInsight(),
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.fromHomeScreen) {
                Navigator.pop(context);
              } else {
                widget.onCompleted();
              }
            },
            child: Text(
              widget.fromHomeScreen ? 'Done' : 'Continue to Wellness Tools',
            ),
          ),
        ],
      ),
    );
  }

  String _getAIInsight() {
    if (_moodRating <= 2) {
      return "I notice you're having a tough day. Remember, it's okay to feel this way. Consider trying the breathing exercises or reaching out to a friend.";
    } else if (_moodRating >= 4) {
      return "It's wonderful to see you feeling so positive! This is a great time to practice gratitude and maybe help others feel better too.";
    } else {
      return "You seem to be in a balanced state today. This might be a good time to focus on your goals and practice some mindfulness.";
    }
  }
}
