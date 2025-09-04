import 'package:flutter/material.dart';
import '../../data/mood_entry_service.dart';

class JournalEntryScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  final String selectedMood;
  final bool fromHomeScreen;

  const JournalEntryScreen({
    super.key,
    required this.onCompleted,
    required this.selectedMood,
    this.fromHomeScreen = false,
  });

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  double _moodRating = 3.0;
  late String _selectedMood;
  final TextEditingController _journalController = TextEditingController();
  final List<String> _selectedMoodDescriptions = [];
  double _stressLevel = 5.0;
  bool _isMoodDescriptionExpanded = false;
  final TextEditingController _customMoodController = TextEditingController();
  bool _showCustomMoodInput = false;

  final Map<String, Map<String, dynamic>> _moodData = {
    'Very Low': {
      'color': const Color(0xFFA18FFF),
      'darkColor': const Color(0xFF1D006F),
    },
    'Low': {
      'color': const Color(0xFFFE814B),
      'darkColor': const Color(0xFFA23900),
    },
    'Neutral': {
      'color': const Color(0xFFBDA193),
      'darkColor': const Color(0xFF4B3426),
    },
    'Good': {
      'color': const Color(0xFFFFCE5D),
      'darkColor': const Color(0xFFA27A00),
    },
    'Excellent': {
      'color': const Color(0xFF9BB169),
      'darkColor': const Color(0xFF5A6B37),
    },
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New Journal Entry',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Journal Title Section
            const Text(
              'Journal Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter title...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.article_outlined, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // How are you feeling today Section
            const Text(
              'How are you feeling today?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Mood Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodIcon('Very Low', 1.0),
                _buildMoodIcon('Low', 2.0),
                _buildMoodIcon('Neutral', 3.0),
                _buildMoodIcon('Good', 4.0),
                _buildMoodIcon('Excellent', 5.0),
              ],
            ),

            const SizedBox(height: 24),

            // Stress levels section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.timeline, color: Colors.grey[700], size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Stress levels',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Theme.of(context).colorScheme.onSurface,
                      inactiveTrackColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                      thumbColor: Theme.of(context).colorScheme.onSurface,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
                      trackHeight: 6,
                    ),
                    child: Slider(
                      value: _stressLevel,
                      min: 0.0,
                      max: 10.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _stressLevel = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Low',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'High',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Mood Tags Section Header
            const Text(
              'What describes your mood?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Mood Tags Section (Collapsible)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey[300]!),
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
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isMoodDescriptionExpanded = !_isMoodDescriptionExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(32),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            _isMoodDescriptionExpanded ? 'Hide mood descriptors' : 'Add mood descriptors',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            _isMoodDescriptionExpanded 
                                ? Icons.keyboard_arrow_up 
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isMoodDescriptionExpanded) ...[
                    Divider(height: 1, color: Colors.grey[200]),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ..._moodTags.map((tag) {
                                final isSelected = _selectedMoodDescriptions.contains(tag);
                                return FilterChip(
                                  label: Text(tag),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedMoodDescriptions.add(tag);
                                      } else {
                                        _selectedMoodDescriptions.remove(tag);
                                      }
                                    });
                                  },
                                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  checkmarkColor: Theme.of(context).colorScheme.primary,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.grey[300]!),
                                );
                              }).toList(),
                              // Display custom mood tags that were added
                              ..._selectedMoodDescriptions.where((mood) => !_moodTags.contains(mood)).map((customMood) {
                                return FilterChip(
                                  label: Text(customMood),
                                  selected: true,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (!selected) {
                                        _selectedMoodDescriptions.remove(customMood);
                                      }
                                    });
                                  },
                                  selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                                  checkmarkColor: Theme.of(context).colorScheme.secondary,
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: () {
                                    setState(() {
                                      _selectedMoodDescriptions.remove(customMood);
                                    });
                                  },
                                );
                              }).toList(),
                              // Others chip
                              FilterChip(
                                label: const Text('Others'),
                                selected: _showCustomMoodInput,
                                onSelected: (selected) {
                                  setState(() {
                                    _showCustomMoodInput = selected;
                                    if (!selected) {
                                      _customMoodController.clear();
                                    }
                                  });
                                },
                                selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                checkmarkColor: Theme.of(context).colorScheme.primary,
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                            ],
                          ),
                          
                          // Custom mood input field
                          if (_showCustomMoodInput) ...[
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: TextField(
                                controller: _customMoodController,
                                decoration: InputDecoration(
                                  hintText: 'Describe your mood...',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(12),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.add, color: Theme.of(context).colorScheme.secondary),
                                    onPressed: () {
                                      final customMood = _customMoodController.text.trim();
                                      if (customMood.isNotEmpty && !_selectedMoodDescriptions.contains(customMood)) {
                                        setState(() {
                                          _selectedMoodDescriptions.add(customMood);
                                          _customMoodController.clear();
                                          _showCustomMoodInput = false; // Hide input after adding
                                        });
                                      }
                                    },
                                  ),
                                ),
                                onSubmitted: (value) {
                                  final customMood = value.trim();
                                  if (customMood.isNotEmpty && !_selectedMoodDescriptions.contains(customMood)) {
                                    setState(() {
                                      _selectedMoodDescriptions.add(customMood);
                                      _customMoodController.clear();
                                      _showCustomMoodInput = false; // Hide input after adding
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Write your Entry Section
            const Text(
              'Write your Entry',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.grey[300]!),
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
                  TextField(
                    controller: _journalController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Tell me something interesting about your day!',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: _resetEntry,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _startVoiceInput,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.mic,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _completeEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFCE5D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodIcon(String mood, double value) {
    final isSelected = _selectedMood == mood;
    final moodData = _moodData[mood]!;
    
    // Map mood names to their individual PNG files
    final Map<String, String> moodToPng = {
      'Very Low': 'very_low.png',
      'Low': 'low.png',
      'Neutral': 'neutral.png',
      'Good': 'good.png',
      'Excellent': 'excellent.png',
    };
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMood = mood;
          _moodRating = value;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/moods/${moodToPng[mood]}'),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              // Handle image loading error
            },
          ),
        ),
        child: isSelected 
            ? Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              )
            : moodToPng[mood] == null 
                ? Center(
                    child: Icon(
                      Icons.sentiment_neutral,
                      size: 30,
                      color: moodData['darkColor'].withOpacity(0.5),
                    ),
                  )
                : null,
      ),
    );
  }

  void _completeEntry() async {
    // Save mood entry completion status with all details
    await MoodEntryService.markMoodEntryCompleted(
      moodLabel: _selectedMood,
      journalText: _journalController.text.trim().isNotEmpty ? _journalController.text.trim() : null,
      moodDescriptions: _selectedMoodDescriptions.isNotEmpty ? _selectedMoodDescriptions : null,
      moodWhy: null, // No reason tags in new design
    );
    
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
              'Your journal entry has been saved successfully!',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFCE5D).withOpacity(0.3),
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
              widget.fromHomeScreen ? 'Done' : 'Continue',
            ),
          ),
        ],
      ),
    );
  }

  void _resetEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Text'),
        content: const Text('Are you sure you want to clear the journal text? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _journalController.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Journal text cleared'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _startVoiceInput() {
    // Show a placeholder dialog for voice input functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.mic, color: Colors.orange),
            SizedBox(width: 8),
            Text('Voice Input'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mic, size: 48, color: Colors.orange),
            SizedBox(height: 16),
            Text('Voice input feature coming soon!'),
            SizedBox(height: 8),
            Text(
              'This will allow you to dictate your journal entry using speech-to-text.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
