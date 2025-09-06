import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/journal_entry_service.dart';
import 'journal_detail_screen.dart';

class JournalLibraryScreen extends StatefulWidget {
  const JournalLibraryScreen({super.key});

  @override
  State<JournalLibraryScreen> createState() => _JournalLibraryScreenState();
}

class _JournalLibraryScreenState extends State<JournalLibraryScreen> {
  bool _isCalendarView = true;
  DateTime _currentDate = DateTime.now();
  PageController _pageController = PageController();

  // Sample data - in a real app, this would come from your data service
  List<JournalEntry> _journalEntries = [];

  // Mood colors mapping - matching journal entry screen
  final Map<String, Color> _moodColors = {
    'Very Low': const Color(0xFFA18FFF), // Purple
    'Low': const Color(0xFFFE814B), // Orange
    'Neutral': const Color(0xFFBDA193), // Beige
    'Good': const Color(0xFFFFCE5D), // Yellow
    'Excellent': const Color(0xFF9BB169), // Green
  };

  // Mood images mapping
  final Map<String, String> _moodImages = {
    'Very Low': 'assets/moods/very_low.png',
    'Low': 'assets/moods/low.png',
    'Neutral': 'assets/moods/neutral.png',
    'Good': 'assets/moods/good.png',
    'Excellent': 'assets/moods/excellent.png',
  };

  List<JournalEntry> _generateSampleData() {
    final List<JournalEntry> entries = [];
    final random = DateTime.now().millisecondsSinceEpoch;
    final moods = ['Very Low', 'Low', 'Neutral', 'Good', 'Excellent'];

    // Add today's entry from JournalEntryService if it exists
    final todayMood = JournalEntryService.getTodayMoodLabel();
    final todayTitle = JournalEntryService.getTodayTitle();
    final todayContent = JournalEntryService.getTodayJournalText();
    final todayPoints = JournalEntryService.getTodayPoints();
    
    if (todayMood != null && todayTitle != null && todayContent != null) {
      entries.add(
        JournalEntry(
          date: DateTime.now(),
          mood: todayMood,
          title: todayTitle,
          content: todayContent,
          points: todayPoints ?? 0, // Use calculated points or 0 as fallback
        ),
      );
    }

    // Generate entries for the past 30 days (skip today if already added)
    for (int i = todayMood != null ? 1 : 0; i < 35; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final moodIndex = (random + i) % moods.length;
      entries.add(
        JournalEntry(
          date: date,
          mood: moods[moodIndex],
          title: "I love my friends!",
          content: "Today was a great day with friends...",
          points: 120,
        ),
      );
    }

    return entries;
  }

  @override
  void initState() {
    super.initState();
    _journalEntries = _generateSampleData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _refreshEntries() {
    setState(() {
      _journalEntries = _generateSampleData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh entries when returning to this screen
    _refreshEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, bottom: 10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFE7DCD8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 18,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Journal Library',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _buildViewToggle(),
          _buildMoodCount(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _isCalendarView = index == 0;
                });
              },
              children: [
                _buildCalendarView(),
                _buildListView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7DCD8),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isCalendarView = true);
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isCalendarView ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: _isCalendarView
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'Calendar View',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isCalendarView
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isCalendarView = false);
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isCalendarView ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: !_isCalendarView
                      ? [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  'List View',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !_isCalendarView
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodCount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Moods (${_journalEntries.length})',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Icon(
            Icons.filter_list,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const SizedBox(height: 20),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentDate = DateTime(
                _currentDate.year,
                _currentDate.month - 1,
              );
            });
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(_currentDate),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              _currentDate = DateTime(
                _currentDate.year,
                _currentDate.month + 1,
              );
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        // Days of week header
        Row(
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
              .map(
                (day) => Expanded(
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 15),
        // Calendar days grid
        ..._buildCalendarWeeks(),
      ],
    );
  }

  List<Widget> _buildCalendarWeeks() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth = DateTime(
      _currentDate.year,
      _currentDate.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday;

    List<Widget> weeks = [];
    List<Widget> currentWeek = [];

    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstDayWeekday; i++) {
      currentWeek.add(const Expanded(child: SizedBox()));
    }

    // Add days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      final date = DateTime(_currentDate.year, _currentDate.month, day);
      final entry = _getEntryForDate(date);

      currentWeek.add(
        Expanded(
          child: GestureDetector(
            onTap: () => _showDayDetails(date, entry),
            child: Container(
              margin: const EdgeInsets.all(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mood circle
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: entry != null
                          ? _moodColors[entry.mood] ?? Colors.grey[300]
                          : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: entry != null
                        ? ClipOval(
                            child: Image.asset(
                              _moodImages[entry.mood] ??
                                  'assets/moods/neutral.png',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 4),
                  // Day number below the circle
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: entry != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // If we've filled a week (7 days), add it to weeks and start a new one
      if (currentWeek.length == 7) {
        weeks.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: currentWeek),
          ),
        );
        currentWeek = [];
      }
    }

    // Fill the last week with empty cells if needed
    while (currentWeek.length < 7) {
      currentWeek.add(const Expanded(child: SizedBox()));
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: currentWeek),
        ),
      );
    }

    return weeks;
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _journalEntries.length,
      itemBuilder: (context, index) {
        final entry = _journalEntries[index];
        
        // Check if this is today's entry to get actual time
        final today = DateTime.now();
        final isToday = entry.date.year == today.year && 
                       entry.date.month == today.month && 
                       entry.date.day == today.day;
        
        // Get the actual entry time for today's entry
        DateTime? entryTime;
        if (isToday) {
          entryTime = JournalEntryService.getTodayEntryTime();
        }
        
        return GestureDetector(
          onTap: () => _showDayDetails(entry.date, entry),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Date section
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(entry.date).toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        entry.date.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Content section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entryTime != null 
                              ? DateFormat('h:mm a').format(entryTime)
                              : '8:00 PM',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.trending_up,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${entry.points} pts',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Mood indicator
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _moodColors[entry.mood] ?? Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      _moodImages[entry.mood] ?? 'assets/moods/neutral.png',
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  JournalEntry? _getEntryForDate(DateTime date) {
    try {
      return _journalEntries.firstWhere(
        (entry) =>
            entry.date.year == date.year &&
            entry.date.month == date.month &&
            entry.date.day == date.day,
      );
    } catch (e) {
      return null;
    }
  }

  void _showDayDetails(DateTime date, JournalEntry? entry) {
    if (entry == null) return;

    // Use actual mood descriptions for today's entry if available, otherwise generate sample ones
    List<String> moodTags = [];
    final today = DateTime.now();
    final isToday = date.year == today.year && 
                   date.month == today.month && 
                   date.day == today.day;
    
    if (isToday) {
      // Try to get actual mood descriptions from the service
      final actualMoodDescriptions = JournalEntryService.getTodayMoodDescriptions();
      if (actualMoodDescriptions != null && actualMoodDescriptions.isNotEmpty) {
        moodTags = actualMoodDescriptions;
      } else {
        // If no mood descriptions were selected, leave empty
        moodTags = [];
      }
    } else {
      // For other days, generate sample mood tags based on the mood
      moodTags = _generateMoodTags(entry.mood);
    }
    
    // Get entry time for today's entry
    DateTime? entryTime;
    if (isToday) {
      entryTime = JournalEntryService.getTodayEntryTime();
    }
    
    // Find current entry index for navigation
    int currentIndex = _journalEntries.indexWhere((e) => 
        e.date.year == entry.date.year &&
        e.date.month == entry.date.month &&
        e.date.day == entry.date.day);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailScreen(
          date: entry.date,
          mood: entry.mood,
          title: entry.title,
          content: _getExpandedContent(entry),
          points: entry.points,
          moodTags: moodTags,
          moodColor: _moodColors[entry.mood] ?? Colors.grey,
          entryTime: entryTime,
          onNextDay: currentIndex > 0 ? () {
            Navigator.pop(context);
            _showDayDetails(_journalEntries[currentIndex - 1].date, _journalEntries[currentIndex - 1]);
          } : null,
          onPreviousDay: currentIndex < _journalEntries.length - 1 ? () {
            Navigator.pop(context);
            _showDayDetails(_journalEntries[currentIndex + 1].date, _journalEntries[currentIndex + 1]);
          } : null,
        ),
      ),
    );
  }

  List<String> _generateMoodTags(String mood) {
    switch (mood) {
      case 'Very Low':
        return ['frustrated', 'disappointed', 'angry', 'reflective'];
      case 'Low':
        return ['sad', 'tired', 'stressed', 'worried'];
      case 'Neutral':
        return ['calm', 'balanced', 'thoughtful'];
      case 'Good':
        return ['happy', 'content', 'positive', 'grateful'];
      case 'Excellent':
        return ['joyful', 'excited', 'energetic', 'amazing'];
      default:
        return ['reflective'];
    }
  }

  String _getExpandedContent(JournalEntry entry) {
    // If this is today's entry from the journal service, return the actual content
    final today = DateTime.now();
    if (entry.date.year == today.year && 
        entry.date.month == today.month && 
        entry.date.day == today.day) {
      final serviceContent = JournalEntryService.getTodayJournalText();
      if (serviceContent != null) {
        return serviceContent;
      }
    }
    
    // Return more detailed content based on mood for sample entries
    switch (entry.mood) {
      case 'Very Low':
        return "Today was so frustrating. I came home late after hanging out with friends, and my parents immediately grounded me for the whole weekend. I feel upset because I only wanted a little break after such a stressful week at school. At the same time, I know they just worry about me, but it still feels unfair. I'm torn between feeling angry and understanding their point of view. Hopefully, I can use this time to cool off and maybe catch up on things I've been putting aside.";
      case 'Low':
        return "Today was challenging. I felt overwhelmed with everything going on and couldn't seem to catch a break. The stress from school and other responsibilities is really getting to me. I'm trying to stay positive but it's difficult when everything feels like an uphill battle.";
      case 'Good':
        return "Today was a good day! I spent time with friends and felt genuinely happy. It's nice to have these moments of joy and connection. I'm grateful for the positive experiences and the people in my life who make me smile.";
      case 'Excellent':
        return "What an amazing day! Everything seemed to go right and I felt incredibly energetic and positive. I love my friends and the wonderful experiences we shared today. This is the kind of day that reminds me how beautiful life can be.";
      default:
        return entry.content;
    }
  }
}

class JournalEntry {
  final DateTime date;
  final String mood;
  final String title;
  final String content;
  final int points;

  JournalEntry({
    required this.date,
    required this.mood,
    required this.title,
    required this.content,
    required this.points,
  });
}
