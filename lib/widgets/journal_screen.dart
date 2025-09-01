import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalEntry {
  final String date;
  final String text;
  final String mood;
  final String stressLevel;
  final String anxietyLevel;
  final String stressReason;
  final String anxietyReason;
  final List<String> moodDescriptions;
  final String moodWhy;

  JournalEntry({
    required this.date,
    required this.text,
    required this.mood,
    required this.stressLevel,
    required this.anxietyLevel,
    required this.stressReason,
    required this.anxietyReason,
    required this.moodDescriptions,
    required this.moodWhy,
  });
}

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  // Example data
  late JournalEntry todaysEntry = JournalEntry(
    date: "Today",
    text: "I felt productive and happy!",
    mood: "Good 😊",
    stressLevel: "Low",
    anxietyLevel: "Low",
    stressReason: "Upcoming project deadline",
    anxietyReason: "Presentation tomorrow",
    moodDescriptions: ["Happy", "Motivated"],
    moodWhy: "I completed my tasks and got enough rest.",
  );

  List<JournalEntry> pastEntries = [
    JournalEntry(
      date: "Yesterday",
      text: "Felt a bit tired but managed to finish my tasks.",
      mood: "Neutral 😐",
      stressLevel: "Medium",
      anxietyLevel: "Low",
      stressReason: "Homework load",
      anxietyReason: "None",
      moodDescriptions: ["Tired", "Indifferent"],
      moodWhy: "Stayed up late studying for exams.",
    ),
    JournalEntry(
      date: "2 days ago",
      text: "Had a great time with friends.",
      mood: "Excellent 😄",
      stressLevel: "Low",
      anxietyLevel: "Low",
      stressReason: "None",
      anxietyReason: "None",
      moodDescriptions: ["Joyful", "Excited"],
      moodWhy: "Spent the day outside with friends.",
    ),
    JournalEntry(
      date: "3 days ago",
      text: "Was stressed about exams.",
      mood: "Low 😔",
      stressLevel: "High",
      anxietyLevel: "High",
      stressReason: "Exam preparation",
      anxietyReason: "Fear of failing",
      moodDescriptions: ["Stressed", "Hopeless"],
      moodWhy: "Worried about upcoming exams.",
    ),
  ];

  Widget _buildJournalDetails(JournalEntry entry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(entry.text, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Text(
          "Mood: ${entry.mood}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (entry.moodDescriptions.isNotEmpty)
          Text(
            "What describes your mood: ${entry.moodDescriptions.join(', ')}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (entry.moodWhy.isNotEmpty)
          Text(
            "What made you feel this way: ${entry.moodWhy}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        Text(
          "Stress Level: ${entry.stressLevel}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "Reason for Stress: ${entry.stressReason}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          "Anxiety Level: ${entry.anxietyLevel}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "Reason for Anxiety: ${entry.anxietyReason}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _editEntry(JournalEntry entry, int? index) async {
    String text = entry.text;
    double moodRating = _moodToRating(entry.mood);
    String selectedMood = entry.mood;
    double stressSlider = _levelToSlider(entry.stressLevel);
    double anxietySlider = _levelToSlider(entry.anxietyLevel);
    String stressReason = entry.stressReason;
    String anxietyReason = entry.anxietyReason;
    List<String> moodDescriptions = List<String>.from(entry.moodDescriptions);
    String moodWhy = entry.moodWhy;
    List<String> moodWhyTags =
        []; // <-- Add this for "What made you feel this way?"

    final List<String> moodTags = [
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

    final List<String> reasonTags = [
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
      'Money',
    ];

    final result = await showDialog<JournalEntry>(
      context: context,
      builder: (context) {
        final textController = TextEditingController(text: text);
        final stressReasonController = TextEditingController(
          text: stressReason,
        );
        final anxietyReasonController = TextEditingController(
          text: anxietyReason,
        );
        final moodWhyController = TextEditingController(text: moodWhy);

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Edit Journal Entry'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(labelText: 'Entry'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mood',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            _moodEmoji(selectedMood),
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            selectedMood,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Slider(
                            value: moodRating,
                            min: 1.0,
                            max: 5.0,
                            divisions: 4,
                            onChanged: (value) {
                              setState(() {
                                moodRating = value;
                                selectedMood = _ratingToMood(value);
                              });
                            },
                          ),
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
                    const SizedBox(height: 16),
                    Text(
                      'What describes your mood?',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: moodTags.map((tag) {
                        final isSelected = moodDescriptions.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                moodDescriptions.add(tag);
                              } else {
                                moodDescriptions.remove(tag);
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
                    const SizedBox(height: 16),
                    Text(
                      'What made you feel this way?',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reasonTags.map((tag) {
                        final isSelected = moodWhyTags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                moodWhyTags.add(tag);
                              } else {
                                moodWhyTags.remove(tag);
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
                    const SizedBox(height: 16),
                    Text(
                      'Stress Level',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Column(
                      children: [
                        Text(
                          _stressEmoji(stressSlider),
                          style: const TextStyle(fontSize: 32),
                        ),
                        Slider(
                          value: stressSlider,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: stressSlider.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              stressSlider = value;
                            });
                          },
                        ),
                        Text(
                          _stressLabel(stressSlider),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextField(
                          controller: stressReasonController,
                          decoration: const InputDecoration(
                            labelText: 'Reason for Stress',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Anxiety Level',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Column(
                      children: [
                        Text(
                          _anxietyEmoji(anxietySlider),
                          style: const TextStyle(fontSize: 32),
                        ),
                        Slider(
                          value: anxietySlider,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: anxietySlider.toInt().toString(),
                          onChanged: (value) {
                            setState(() {
                              anxietySlider = value;
                            });
                          },
                        ),
                        Text(
                          _anxietyLabel(anxietySlider),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextField(
                          controller: anxietyReasonController,
                          decoration: const InputDecoration(
                            labelText: 'Reason for Anxiety',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    JournalEntry(
                      date: entry.date,
                      text: textController.text,
                      mood: selectedMood,
                      stressLevel: _sliderToLevel(stressSlider),
                      anxietyLevel: _sliderToLevel(anxietySlider),
                      stressReason: stressReasonController.text,
                      anxietyReason: anxietyReasonController.text,
                      moodDescriptions: moodDescriptions,
                      moodWhy: [
                        ...moodWhyTags,
                        if (moodWhyController.text.trim().isNotEmpty)
                          moodWhyController.text.trim(),
                      ].join(', '),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        if (index == null) {
          todaysEntry = result;
        } else {
          pastEntries[index] = result;
        }
      });
    }
  }

  // Helper functions for mapping
  double _moodToRating(String mood) {
    switch (mood) {
      case 'Very Low':
        return 1.0;
      case 'Low':
        return 2.0;
      case 'Neutral':
        return 3.0;
      case 'Good':
        return 4.0;
      case 'Excellent':
        return 5.0;
      default:
        return 3.0;
    }
  }

  String _ratingToMood(double rating) {
    if (rating <= 1.0) return 'Very Low';
    if (rating <= 2.0) return 'Low';
    if (rating <= 3.0) return 'Neutral';
    if (rating <= 4.0) return 'Good';
    return 'Excellent';
  }

  String _moodEmoji(String mood) {
    switch (mood) {
      case 'Very Low':
        return '😢';
      case 'Low':
        return '😔';
      case 'Neutral':
        return '😐';
      case 'Good':
        return '😊';
      case 'Excellent':
        return '😄';
      default:
        return '😐';
    }
  }

  double _levelToSlider(String level) {
    switch (level) {
      case 'Low':
        return 2;
      case 'Medium':
        return 5;
      case 'High':
        return 8;
      default:
        return 5;
    }
  }

  String _sliderToLevel(double slider) {
    if (slider <= 3) return 'Low';
    if (slider <= 7) return 'Medium';
    return 'High';
  }

  String _stressEmoji(double slider) {
    if (slider <= 2) return '😌';
    if (slider <= 4) return '😐';
    if (slider <= 6) return '😰';
    if (slider <= 8) return '😵';
    return '🚨';
  }

  String _stressLabel(double slider) {
    if (slider <= 2) return 'Calm and relaxed';
    if (slider <= 4) return 'Slightly tense';
    if (slider <= 6) return 'Moderately stressed';
    if (slider <= 8) return 'Very stressed';
    return 'Overwhelmed';
  }

  String _anxietyEmoji(double slider) {
    if (slider <= 2) return '😌';
    if (slider <= 4) return '😐';
    if (slider <= 6) return '😰';
    if (slider <= 8) return '😵';
    return '🚨';
  }

  String _anxietyLabel(double slider) {
    if (slider <= 2) return 'Calm and relaxed';
    if (slider <= 4) return 'Slightly tense';
    if (slider <= 6) return 'Moderately anxious';
    if (slider <= 8) return 'Very anxious';
    return 'Overwhelmed';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        backgroundColor: colorScheme.background,
        elevation: 0,
        foregroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      body: Container(
        color: colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Journal Entry
              Text(
                "Today's Journal",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _editEntry(todaysEntry, null),
                child: Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _buildJournalDetails(todaysEntry),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Past Journal Entries
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Past Journals",
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: colorScheme.primary),
                    tooltip: 'Add Journal Entry',
                    onPressed: () async {
                      // Collect all dates with journal entries
                      final Set<DateTime> loggedDates = {
                        DateTime.now(), // Today's entry
                        ...pastEntries
                            .where(
                              (e) => RegExp(
                                r'^\d{1,2}/\d{1,2}/\d{4}$',
                              ).hasMatch(e.date),
                            )
                            .map((e) {
                              final parts = e.date.split('/');
                              return DateTime(
                                int.parse(parts[2]), // year
                                int.parse(parts[1]), // month
                                int.parse(parts[0]), // day
                              );
                            }),
                      };

                      DateTime? selectedDay;

                      await showDialog(
                        context: context,
                        builder: (context) {
                          DateTime focusedDay = DateTime.now();
                          return AlertDialog(
                            title: const Text('Select a date to add journal'),
                            content: SizedBox(
                              width: 400,
                              height:
                                  420, // <-- Adjust height for calendar view
                              child: TableCalendar(
                                firstDay: DateTime(DateTime.now().year, 1, 1),
                                lastDay: DateTime(DateTime.now().year, 12, 31),
                                focusedDay: focusedDay,
                                selectedDayPredicate: (day) =>
                                    selectedDay != null &&
                                    isSameDay(day, selectedDay),
                                availableCalendarFormats: const {
                                  CalendarFormat.month: 'Month',
                                },
                                calendarBuilders: CalendarBuilders(
                                  defaultBuilder: (context, day, focusedDay) {
                                    final isLogged = loggedDates.any(
                                      (d) => isSameDay(d, day),
                                    );
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: isLogged
                                            ? Colors.grey[300]
                                            : null,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: isLogged
                                              ? Colors.grey
                                              : Colors.black,
                                          fontWeight: isLogged
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    );
                                  },
                                  todayBuilder: (context, day, focusedDay) {
                                    final isLogged = loggedDates.any(
                                      (d) => isSameDay(d, day),
                                    );
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: isLogged
                                            ? Colors.grey[300]
                                            : Colors.blue[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${day.day}',
                                        style: TextStyle(
                                          color: isLogged
                                              ? Colors.grey
                                              : Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                onDaySelected: (day, focusedDay) {
                                  final isLogged = loggedDates.any(
                                    (d) => isSameDay(d, day),
                                  );
                                  if (!isLogged) {
                                    selectedDay = day;
                                    Navigator.pop(context);
                                  }
                                },
                                enabledDayPredicate: (day) {
                                  // Only enable days without a journal entry
                                  return !loggedDates.any(
                                    (d) => isSameDay(d, day),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );

                      if (selectedDay != null) {
                        final newDate =
                            "${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}";
                        // Show the add journal dialog for the selected date
                        final result = await showDialog<JournalEntry>(
                          context: context,
                          builder: (context) {
                            String selectedMood = 'Neutral';
                            double moodRating = 3.0;
                            double stressSlider = 5.0;
                            double anxietySlider = 5.0;
                            List<String> moodDescriptions = [];
                            List<String> moodWhyTags = [];
                            String moodWhy = "";
                            final textController = TextEditingController();
                            final stressReasonController =
                                TextEditingController();
                            final anxietyReasonController =
                                TextEditingController();

                            final List<String> moodTags = [
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

                            final List<String> reasonTags = [
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
                              'Money',
                            ];

                            return StatefulBuilder(
                              builder: (context, setState) => AlertDialog(
                                title: Text('Add Journal Entry (${newDate})'),
                                content: SizedBox(
                                  width: 400,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: textController,
                                          decoration: const InputDecoration(
                                            labelText: 'Entry',
                                          ),
                                          maxLines: 3,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Mood',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                _moodEmoji(selectedMood),
                                                style: const TextStyle(
                                                  fontSize: 40,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                selectedMood,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                              ),
                                              Slider(
                                                value: moodRating,
                                                min: 1.0,
                                                max: 5.0,
                                                divisions: 4,
                                                onChanged: (value) {
                                                  setState(() {
                                                    moodRating = value;
                                                    selectedMood =
                                                        _ratingToMood(value);
                                                  });
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Very Low',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                                  ),
                                                  Text(
                                                    'Excellent',
                                                    style: Theme.of(
                                                      context,
                                                    ).textTheme.bodySmall,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'What describes your mood?',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: moodTags.map((tag) {
                                            final isSelected = moodDescriptions
                                                .contains(tag);
                                            return FilterChip(
                                              label: Text(tag),
                                              selected: isSelected,
                                              onSelected: (selected) {
                                                setState(() {
                                                  if (selected) {
                                                    moodDescriptions.add(tag);
                                                  } else {
                                                    moodDescriptions.remove(
                                                      tag,
                                                    );
                                                  }
                                                });
                                              },
                                              selectedColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.2),
                                              checkmarkColor: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'What made you feel this way?',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: reasonTags.map((tag) {
                                            final isSelected = moodWhyTags
                                                .contains(tag);
                                            return FilterChip(
                                              label: Text(tag),
                                              selected: isSelected,
                                              onSelected: (selected) {
                                                setState(() {
                                                  if (selected) {
                                                    moodWhyTags.add(tag);
                                                  } else {
                                                    moodWhyTags.remove(tag);
                                                  }
                                                });
                                              },
                                              selectedColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.2),
                                              checkmarkColor: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Stress Level',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              _stressEmoji(stressSlider),
                                              style: const TextStyle(
                                                fontSize: 32,
                                              ),
                                            ),
                                            Slider(
                                              value: stressSlider,
                                              min: 1,
                                              max: 10,
                                              divisions: 9,
                                              label: stressSlider
                                                  .toInt()
                                                  .toString(),
                                              onChanged: (value) {
                                                setState(() {
                                                  stressSlider = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              _stressLabel(stressSlider),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            TextField(
                                              controller:
                                                  stressReasonController,
                                              decoration: const InputDecoration(
                                                labelText: 'Reason for Stress',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Anxiety Level',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelMedium,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              _anxietyEmoji(anxietySlider),
                                              style: const TextStyle(
                                                fontSize: 32,
                                              ),
                                            ),
                                            Slider(
                                              value: anxietySlider,
                                              min: 1,
                                              max: 10,
                                              divisions: 9,
                                              label: anxietySlider
                                                  .toInt()
                                                  .toString(),
                                              onChanged: (value) {
                                                setState(() {
                                                  anxietySlider = value;
                                                });
                                              },
                                            ),
                                            Text(
                                              _anxietyLabel(anxietySlider),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            TextField(
                                              controller:
                                                  anxietyReasonController,
                                              decoration: const InputDecoration(
                                                labelText: 'Reason for Anxiety',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        JournalEntry(
                                          date: newDate,
                                          text: textController.text,
                                          mood: selectedMood,
                                          stressLevel: _sliderToLevel(
                                            stressSlider,
                                          ),
                                          anxietyLevel: _sliderToLevel(
                                            anxietySlider,
                                          ),
                                          stressReason:
                                              stressReasonController.text,
                                          anxietyReason:
                                              anxietyReasonController.text,
                                          moodDescriptions: moodDescriptions,
                                          moodWhy: moodWhyTags.join(', '),
                                        ),
                                      );
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        if (result != null) {
                          setState(() {
                            pastEntries.insert(0, result);
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: pastEntries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = pastEntries[index];
                    return GestureDetector(
                      onTap: () => _editEntry(entry, index),
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          color: colorScheme.surfaceVariant,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.date,
                                  style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _buildJournalDetails(entry),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
