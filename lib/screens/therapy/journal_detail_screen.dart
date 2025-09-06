import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalDetailScreen extends StatelessWidget {
  final DateTime date;
  final String mood;
  final String title;
  final String content;
  final int points;
  final List<String> moodTags;
  final Color moodColor;
  final DateTime? entryTime;
  final VoidCallback? onNextDay;
  final VoidCallback? onPreviousDay;

  const JournalDetailScreen({
    super.key,
    required this.date,
    required this.mood,
    required this.title,
    required this.content,
    required this.points,
    required this.moodTags,
    required this.moodColor,
    this.entryTime,
    this.onNextDay,
    this.onPreviousDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: onPreviousDay ?? () => Navigator.pop(context),
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: 18,
            ),
          ),
        ),
        title: Text(
          DateFormat('dd MMMM yyyy').format(date),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: onNextDay,
            child: Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: onNextDay != null
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey[400]!,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: onNextDay != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Colors.grey[400],
                size: 18,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 40),
                        padding: const EdgeInsets.only(
                          top: 55,
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Time and points info
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    entryTime != null 
                                        ? DateFormat('h:mm a').format(entryTime!)
                                        : '8:00 PM',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Icon(
                                    Icons.trending_up,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$points pts',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '80%',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Journal title
                            Center(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Journal content
                            Text(
                              content,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Mood tags
                            if (moodTags.isNotEmpty) ...[
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 8,
                                runSpacing: 8,
                                children: moodTags
                                    .map(
                                      (tag) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: moodColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          tag,
                                          style: TextStyle(
                                            color: moodColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Mood indicator
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: moodColor,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              _getMoodImage(mood),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // AI-Powered Advice section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.psychology,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'AI-Powered Advice',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _getAIAdvice(mood),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 8,
                            right: 12,
                            left: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: _getAdviceList(mood)
                                .map(
                                  (advice) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          advice['emoji']!,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            advice['text']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  String _getMoodImage(String mood) {
    switch (mood) {
      case 'Very Low':
        return 'assets/moods/very_low.png';
      case 'Low':
        return 'assets/moods/low.png';
      case 'Neutral':
        return 'assets/moods/neutral.png';
      case 'Good':
        return 'assets/moods/good.png';
      case 'Excellent':
        return 'assets/moods/excellent.png';
      default:
        return 'assets/moods/neutral.png';
    }
  }

  String _getAIAdvice(String mood) {
    switch (mood) {
      case 'Very Low':
      case 'Low':
        return "You're likely feeling frustrated and disappointed today because your journal entry reflects being grounded after a long week, with emotions of anger and unfairness, but also some reflection about your parents' perspective. These signals together suggest a mix of tension and self-awareness. To help process these feelings, you might try:";
      case 'Good':
      case 'Excellent':
        return "Your positive mood and journal entry suggest you're in a great emotional state today. Your experiences reflect joy and contentment. To maintain this positive momentum, you might try:";
      default:
        return "Your journal entry reflects a balanced emotional state. This is a good foundation for personal growth. Consider these approaches:";
    }
  }

  List<Map<String, String>> _getAdviceList(String mood) {
    switch (mood) {
      case 'Very Low':
      case 'Low':
        return [
          {
            'emoji': '⚡',
            'text':
                'Write out your thoughts in more detail to release built-up frustration.',
          },
          {
            'emoji': '🧘‍♀️',
            'text':
                'Practice a short breathing exercise to ease tension and calm your mind.',
          },
          {
            'emoji': '💙',
            'text':
                'Engage in a relaxing activity (music, reading, or drawing) while grounded.',
          },
          {
            'emoji': '💬',
            'text': 'Talk it out calmly with your parents when you feel ready.',
          },
        ];
      case 'Good':
      case 'Excellent':
        return [
          {
            'emoji': '✨',
            'text':
                'Savor this positive moment and reflect on what made today special.',
          },
          {
            'emoji': '🤝',
            'text': 'Share your happiness with friends or family.',
          },
          {
            'emoji': '🎨',
            'text': 'Channel this positive energy into a creative activity.',
          },
          {
            'emoji': '📝',
            'text':
                'Write down what you\'re grateful for to remember this feeling.',
          },
        ];
      default:
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
