import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/journal_entry_service.dart';
import 'mood_analysis_screen.dart';

class JournalEntryScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  final String selectedMood;
  final bool fromHomeScreen;
  final String? initialJournalText;
  final List<String>? initialMoodDescriptions;
  final double? initialStressLevel;

  const JournalEntryScreen({
    super.key,
    required this.onCompleted,
    required this.selectedMood,
    this.fromHomeScreen = false,
    this.initialJournalText,
    this.initialMoodDescriptions,
    this.initialStressLevel,
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

  // Voice recording variables
  bool _isRecording = false;
  bool _speechEnabled = false;
  String _recordedText = '';
  late stt.SpeechToText _speech;

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
    _initSpeech();

    // Initialize with provided values if coming back from mood analysis
    if (widget.initialJournalText != null) {
      _journalController.text = widget.initialJournalText!;
    }
    if (widget.initialMoodDescriptions != null) {
      _selectedMoodDescriptions.addAll(widget.initialMoodDescriptions!);
    }
    if (widget.initialStressLevel != null) {
      _stressLevel = widget.initialStressLevel!;
    }

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

  void _initSpeech() async {
    // _speechEnabled = await _speech.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // New Journal Entry Header
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'New Journal Entry',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
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
                        prefixIcon: Icon(
                          Icons.article_outlined,
                          color: Colors.grey[400],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
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
                            Icon(
                              Icons.timeline,
                              color: Colors.grey[700],
                              size: 20,
                            ),
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
                            activeTrackColor: Theme.of(
                              context,
                            ).colorScheme.onSurface,
                            inactiveTrackColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.4),
                            thumbColor: Theme.of(context).colorScheme.onSurface,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 20,
                            ),
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
                              _isMoodDescriptionExpanded =
                                  !_isMoodDescriptionExpanded;
                            });
                          },
                          borderRadius: BorderRadius.circular(32),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Text(
                                  _isMoodDescriptionExpanded
                                      ? 'Hide mood descriptors'
                                      : 'Add mood descriptors',
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
                                      final isSelected =
                                          _selectedMoodDescriptions.contains(
                                            tag,
                                          );
                                      return FilterChip(
                                        label: Text(tag),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          setState(() {
                                            if (selected) {
                                              _selectedMoodDescriptions.add(
                                                tag,
                                              );
                                            } else {
                                              _selectedMoodDescriptions.remove(
                                                tag,
                                              );
                                            }
                                          });
                                        },
                                        selectedColor: Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.2),
                                        checkmarkColor: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      );
                                    }).toList(),
                                    // Display custom mood tags that were added
                                    ..._selectedMoodDescriptions
                                        .where(
                                          (mood) => !_moodTags.contains(mood),
                                        )
                                        .map((customMood) {
                                          return FilterChip(
                                            label: Text(customMood),
                                            selected: true,
                                            onSelected: (selected) {
                                              setState(() {
                                                if (!selected) {
                                                  _selectedMoodDescriptions
                                                      .remove(customMood);
                                                }
                                              });
                                            },
                                            selectedColor: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.2),
                                            checkmarkColor: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                            onDeleted: () {
                                              setState(() {
                                                _selectedMoodDescriptions
                                                    .remove(customMood);
                                              });
                                            },
                                          );
                                        })
                                        .toList(),
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
                                      selectedColor: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.2),
                                      checkmarkColor: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
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
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: TextField(
                                      controller: _customMoodController,
                                      decoration: InputDecoration(
                                        hintText: 'Describe your mood...',
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(
                                          12,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.add,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
                                          onPressed: () {
                                            final customMood =
                                                _customMoodController.text
                                                    .trim();
                                            if (customMood.isNotEmpty &&
                                                !_selectedMoodDescriptions
                                                    .contains(customMood)) {
                                              setState(() {
                                                _selectedMoodDescriptions.add(
                                                  customMood,
                                                );
                                                _customMoodController.clear();
                                                _showCustomMoodInput =
                                                    false; // Hide input after adding
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        final customMood = value.trim();
                                        if (customMood.isNotEmpty &&
                                            !_selectedMoodDescriptions.contains(
                                              customMood,
                                            )) {
                                          setState(() {
                                            _selectedMoodDescriptions.add(
                                              customMood,
                                            );
                                            _customMoodController.clear();
                                            _showCustomMoodInput =
                                                false; // Hide input after adding
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
                            hintText:
                                'Tell me something interesting about your day!',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: _resetEntry,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
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
                                onTap: _toggleRecording,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _isRecording
                                        ? Colors.red
                                        : Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Icon(
                                    _isRecording ? Icons.stop : Icons.mic,
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

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
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
                  child: Icon(Icons.check, size: 40, color: Colors.white),
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
    await JournalEntryService.markMoodEntryCompleted(
      moodLabel: _selectedMood,
      journalText: _journalController.text.trim().isNotEmpty
          ? _journalController.text.trim()
          : null,
      moodDescriptions: _selectedMoodDescriptions.isNotEmpty
          ? _selectedMoodDescriptions
          : null,
      moodWhy: null, // No reason tags in new design
    );

    // Simulate saving the entry
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Entry Saved! 🎉',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Navigate to mood analysis screen after a brief delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoodAnalysisScreen(
            selectedMood: _selectedMood,
            journalText: _journalController.text.trim(),
            moodDescriptions: _selectedMoodDescriptions,
            stressLevel: _stressLevel,
            onCompleted: widget.onCompleted,
            fromHomeScreen: widget.fromHomeScreen,
          ),
        ),
      ).then((_) {
        // Call onCompleted after returning from mood analysis
        widget.onCompleted();
      });
    });
  }

  void _resetEntry() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Text'),
        content: const Text(
          'Are you sure you want to clear the journal text? This action cannot be undone.',
        ),
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
                SnackBar(
                  content: Text('Journal text cleared'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRecording() async {
    if (_isRecording) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() async {
    // For demo purposes, we'll simulate voice recording
    setState(() {
      _isRecording = true;
    });

    // Show recording dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.mic, color: Theme.of(context).colorScheme.tertiary),
            SizedBox(width: 8),
            Text('Recording...'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Icon(
                Icons.mic,
                size: 48,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
            const Text('Speak now...'),
            const SizedBox(height: 16),
            const LinearProgressIndicator(),
          ],
        ),
        actions: [
          TextButton(onPressed: _stopListening, child: const Text('Stop')),
        ],
      ),
    );

    // Simulate recording for 3 seconds then auto-stop
    Future.delayed(const Duration(seconds: 3), () {
      if (_isRecording) {
        _stopListening();
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isRecording = false;
    });

    // Close dialog if open
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Simulate transcribed text (in real implementation, this would come from speech recognition)
    const simulatedTranscription =
        "This is a sample transcription of what you said. In a real implementation, this would be the actual speech-to-text result.";

    // Add transcribed text to journal
    final currentText = _journalController.text;
    final newText = currentText.isEmpty
        ? simulatedTranscription
        : '$currentText\n\n$simulatedTranscription';

    _journalController.text = newText;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice recording added to journal'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
