import 'package:flutter/material.dart';
import 'journal_entry_screen.dart';

class MoodAnalysisScreen extends StatelessWidget {
  final String selectedMood;
  final String journalText;
  final List<String> moodDescriptions;
  final double stressLevel;
  final VoidCallback? onCompleted;
  final bool fromHomeScreen;

  const MoodAnalysisScreen({
    super.key,
    required this.selectedMood,
    required this.journalText,
    required this.moodDescriptions,
    required this.stressLevel,
    this.onCompleted,
    this.fromHomeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getMoodBackgroundColor(),
      body: Container(
        decoration: BoxDecoration(
          image: _getMoodBackgroundImage(),
        ),
        child: Stack(
          children: [
          Container(
            height: 600,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 300),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.elliptical(450, 150),
                topRight: Radius.elliptical(450, 150),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate back to journal entry screen with current data
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalEntryScreen(
                              onCompleted: onCompleted ?? () {},
                              selectedMood: selectedMood,
                              fromHomeScreen: fromHomeScreen,
                              initialJournalText: journalText,
                              initialMoodDescriptions: moodDescriptions,
                              initialStressLevel: stressLevel,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Theme.of(context).colorScheme.surface,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Mood Analysis',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  child: Column(
                    children: [
                      const Text(
                        'You are most likely...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getAnalyzedMood(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Edit button
                    ],
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A3427),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.white, size: 32),
                    padding: const EdgeInsets.all(12),
                  ),
                ),

                const SizedBox(height: 32),

                // AI-Powered Overview section
                SizedBox(
                  height: 325, // Fixed height for the entire section
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI-Powered Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  _getAIAnalysis(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurface,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    right: 12,
                                    left: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: _getRecommendations()
                                        .map(
                                          (recommendation) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 8,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  recommendation['emoji'] ?? '',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    recommendation['text'] ?? '',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.onSurface,
                                                      height: 1.4,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons
                SizedBox(
                  child: Column(
                    children: [
                      // Wellness tools button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to breathing exercises or meditation
                            Navigator.of(
                              context,
                            ).pushNamed('/breathing-exercises');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getMoodBackgroundColor(),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Try some mindful exercises',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // View journal entries button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to journal entries
                            Navigator.of(context).pushNamed('/journal-entries');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A3427),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'View all journal entries',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  DecorationImage _getMoodBackgroundImage() {
    String imagePath;
    switch (selectedMood) {
      case 'Very Low':
        imagePath = 'assets/background/Very_Low_bg.png';
        break;
      case 'Low':
        imagePath = 'assets/background/Low_bg.png';
        break;
      case 'Neutral':
        imagePath = 'assets/background/Neutral_bg.png';
        break;
      case 'Good':
        imagePath = 'assets/background/Good_bg.png';
        break;
      case 'Excellent':
        imagePath = 'assets/background/Excellent_bg.png';
        break;
      default:
        imagePath = 'assets/background/Neutral_bg.png';
        break;
    }
    return DecorationImage(
      image: AssetImage(imagePath),
      fit: BoxFit.cover,
    );
  }

  Color _getMoodBackgroundColor() {
    switch (selectedMood) {
      case 'Very Low':
        return const Color(0xFFA18FFF);
      case 'Low':
        return const Color(0xFFFE814B);
      case 'Neutral':
        return const Color(0xFFBDA193);
      case 'Good':
        return const Color(0xFFFFCE5D);
      case 'Excellent':
        return const Color(0xFF9BB169);
      default:
        return const Color(0xFFBDA193);
    }
  }

  String _getAnalyzedMood() {
    // For now, return a more descriptive mood based on analysis
    // Later this will be determined by ML model
    switch (selectedMood) {
      case 'Very Low':
        return 'Struggling';
      case 'Low':
        return 'Concerned';
      case 'Neutral':
        return 'Balanced';
      case 'Good':
        return 'Positive';
      case 'Excellent':
        return 'Ecstatic';
      default:
        return 'Thoughtful';
    }
  }

  String _getAIAnalysis() {
    // Generate analysis based on mood and journal content
    // This will be replaced with actual ML analysis
    if (selectedMood == 'Excellent' || selectedMood == 'Good') {
      return "You marked a very positive mood, your journal entry highlighted uplifting experiences (like spending time with friends and celebrating a small win), and your stress check-in showed low tension. These signals together suggest a joyful, energized state. To keep this mood alive, you might try:";
    } else if (selectedMood == 'Very Low' || selectedMood == 'Low') {
      return "Your mood indicators and journal entry suggest you're experiencing some challenges today. This is completely normal and temporary. Your stress levels appear elevated, which may be contributing to these feelings. Consider these gentle approaches:";
    } else {
      return "Your journal entry and mood check-in indicate a balanced emotional state today. You seem to be in a stable place, which is a great foundation for growth. This might be a good time to:";
    }
  }

  List<Map<String, String>> _getRecommendations() {
    // Generate recommendations based on mood analysis
    // This will be enhanced with ML-based suggestions
    if (selectedMood == 'Excellent' || selectedMood == 'Good') {
      return [
        {
          'emoji': '✨',
          'text': 'Savor small wins by pausing to appreciate what went well.',
        },
        {
          'emoji': '🤝',
          'text': 'Share your happiness with a friend or loved one.',
        },
        {
          'emoji': '🎨',
          'text': 'Do something you love—a hobby, music, or creative outlet.',
        },
        {
          'emoji': '🧘',
          'text':
              'Take mindful breaks like a walk or deep breathing to recharge.',
        },
      ];
    } else if (selectedMood == 'Very Low' || selectedMood == 'Low') {
      return [
        {'emoji': '🫂', 'text': 'Reach out to someone you trust for support.'},
        {
          'emoji': '🌱',
          'text':
              'Practice self-compassion and remember this feeling is temporary.',
        },
        {
          'emoji': '🧘‍♀️',
          'text': 'Try gentle breathing exercises or meditation.',
        },
        {
          'emoji': '📝',
          'text': 'Write down three small things you\'re grateful for today.',
        },
      ];
    } else {
      return [
        {'emoji': '🎯', 'text': 'Set small, achievable goals for the day.'},
        {
          'emoji': '🧘',
          'text': 'Practice mindfulness to stay present and centered.',
        },
        {
          'emoji': '📚',
          'text': 'Engage in activities that promote personal growth.',
        },
        {
          'emoji': '💭',
          'text': 'Reflect on what you\'d like to focus on moving forward.',
        },
      ];
    }
  }
}
