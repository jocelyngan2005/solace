import 'package:flutter/material.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  _HabitTrackerState createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {

  // Habit logging system
  final Map<String, List<Map<String, dynamic>>> _habitLogs = {};
  
  // Sleep Hours tracker
  double _sleepHours = 7.0;

  // Bedtime Patterns tracker
  TimeOfDay? _bedTime;
  TimeOfDay? _wakeTime;

  // Health Habits trackers
  List<String> _meals = [];
  int _waterIntake = 0;

  // Movement & Exercise trackers
  int _steps = 0;
  List<Map<String, dynamic>> _exercises = [];

  // Goals for each tracker
  double _sleepGoal = 8.0;
  TimeOfDay? _bedTimeGoal;
  TimeOfDay? _wakeTimeGoal;
  int _mealGoal = 3;
  int _waterGoal = 8;
  int _stepsGoal = 10000;
  int _exerciseGoal = 30;

  final List<Map<String, dynamic>> _sleepHabits = [
    {
      'name': 'Sleep Hours',
      'desc': 'Monitor your daily sleep duration.',
      'icon': Icons.bedtime,
      'color': Color(0xFFA596F5),
    },
    {
      'name': 'Bedtime Patterns',
      'desc': 'Track your bedtime and wake-up routines.',
      'icon': Icons.schedule,
      'color': Color(0xFFA596F5),
    },
  ];

  final List<Map<String, dynamic>> _healthHabits = [
    {
      'name': 'Meals',
      'desc': 'Track your meal times and nutrition.',
      'icon': Icons.restaurant,
      'color': Color(0xFF95A663),
    },
    {
      'name': 'Water',
      'desc': 'Log your daily water intake.',
      'icon': Icons.local_drink,
      'color': Color(0xFF95A663),
    },
  ];

  final List<Map<String, dynamic>> _movementHabits = [
    {
      'name': 'Steps',
      'desc': 'Track your daily step count.',
      'icon': Icons.directions_walk,
      'color': Color(0xFFFD904E),
    },
    {
      'name': 'Exercise',
      'desc': 'Log your sports and exercise activities.',
      'icon': Icons.sports_soccer,
      'color': Color(0xFFFD904E),
    },
  ];

  // Habit logging methods
  void _logHabit(String habitName, dynamic value, {Map<String, dynamic>? additionalData}) {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    if (_habitLogs[habitName] == null) {
      _habitLogs[habitName] = [];
    }
    
    // Check if there's already an entry for today
    final existingEntryIndex = _habitLogs[habitName]!.indexWhere(
      (log) => log['date'] == dateKey,
    );
    
    final logEntry = {
      'date': dateKey,
      'timestamp': today.toIso8601String(),
      'value': value,
      'completed': true,
      ...?additionalData,
    };
    
    if (existingEntryIndex != -1) {
      // Update existing entry
      _habitLogs[habitName]![existingEntryIndex] = logEntry;
    } else {
      // Add new entry
      _habitLogs[habitName]!.add(logEntry);
    }
    
    // Sort by date (most recent first)
    _habitLogs[habitName]!.sort((a, b) => b['date'].compareTo(a['date']));
    
    // Keep only last 30 days
    if (_habitLogs[habitName]!.length > 30) {
      _habitLogs[habitName] = _habitLogs[habitName]!.take(30).toList();
    }
  }
  
  Map<String, dynamic>? _getTodaysLog(String habitName) {
    final today = DateTime.now();
    final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    if (_habitLogs[habitName] == null) return null;
    
    try {
      return _habitLogs[habitName]!.firstWhere(
        (log) => log['date'] == dateKey,
      );
    } catch (e) {
      return null;
    }
  }
  
  List<Map<String, dynamic>> _getHabitHistory(String habitName, {int days = 7}) {
    if (_habitLogs[habitName] == null) return [];
    
    return _habitLogs[habitName]!.take(days).toList();
  }
  
  bool _isHabitCompletedToday(String habitName) {
    final todaysLog = _getTodaysLog(habitName);
    return todaysLog != null && (todaysLog['completed'] == true);
  }

  void _logHabitData(Map<String, dynamic> habit) {
    final habitName = habit['name'];
    
    switch (habitName) {
      case 'Sleep Hours':
        _logHabit(habitName, _sleepHours, additionalData: {
          'unit': 'hours',
          'goal': _sleepGoal,
          'goalMet': _sleepHours >= _sleepGoal,
        });
        break;
        
      case 'Bedtime Patterns':
        if (_bedTime != null && _wakeTime != null) {
          _logHabit(habitName, {
            'bedtime': '${_bedTime!.hour}:${_bedTime!.minute.toString().padLeft(2, '0')}',
            'waketime': '${_wakeTime!.hour}:${_wakeTime!.minute.toString().padLeft(2, '0')}',
          }, additionalData: {
            'goalBedtime': _bedTimeGoal != null ? '${_bedTimeGoal!.hour}:${_bedTimeGoal!.minute.toString().padLeft(2, '0')}' : null,
            'goalWaketime': _wakeTimeGoal != null ? '${_wakeTimeGoal!.hour}:${_wakeTimeGoal!.minute.toString().padLeft(2, '0')}' : null,
          });
        }
        break;
        
      case 'Meals':
        _logHabit(habitName, _meals.length, additionalData: {
          'meals': _meals,
          'goal': _mealGoal,
          'goalMet': _meals.length >= _mealGoal,
        });
        break;
        
      case 'Water':
        _logHabit(habitName, _waterIntake, additionalData: {
          'unit': 'glasses',
          'goal': _waterGoal,
          'goalMet': _waterIntake >= _waterGoal,
        });
        break;
        
      case 'Steps':
        _logHabit(habitName, _steps, additionalData: {
          'unit': 'steps',
          'goal': _stepsGoal,
          'goalMet': _steps >= _stepsGoal,
        });
        break;
        
      case 'Exercise':
        final totalMinutes = _exercises.fold<int>(0, (sum, ex) => sum + (ex['duration'] as int? ?? 0));
        _logHabit(habitName, totalMinutes, additionalData: {
          'unit': 'minutes',
          'exercises': _exercises,
          'goal': _exerciseGoal,
          'goalMet': totalMinutes >= _exerciseGoal,
        });
        break;
    }
  }

  // Helper methods
  String _calculateSleepDuration() {
    if (_bedTime == null || _wakeTime == null) return '0 hrs 0 min';
    
    int bedMinutes = _bedTime!.hour * 60 + _bedTime!.minute;
    int wakeMinutes = _wakeTime!.hour * 60 + _wakeTime!.minute;
    
    int sleepMinutes;
    if (wakeMinutes >= bedMinutes) {
      // Same day wake up (unusual but possible)
      sleepMinutes = wakeMinutes - bedMinutes;
    } else {
      // Next day wake up (normal)
      sleepMinutes = (24 * 60) - bedMinutes + wakeMinutes;
    }
    
    int hours = sleepMinutes ~/ 60;
    int minutes = sleepMinutes % 60;
    
    return '${hours}hrs ${minutes}min';
  }

  IconData _getHabitIcon(String habitName) {
    switch (habitName) {
      case 'Sleep Hours':
        return Icons.bedtime_outlined;
      case 'Bedtime Patterns':
        return Icons.schedule_outlined;
      case 'Meals':
        return Icons.restaurant_outlined;
      case 'Water':
        return Icons.local_drink_outlined;
      case 'Steps':
        return Icons.directions_walk_outlined;
      case 'Exercise':
        return Icons.sports_soccer_outlined;
      default:
        return Icons.star_outline;
    }
  }

  void _showHabitLogsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F6F4),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.history_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Habit Logs',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Your progress over time',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: IconButton(
                        icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface),
                        onPressed: () => Navigator.pop(context),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _habitLogs.isEmpty
                    ? Container(
                        padding: const EdgeInsets.all(32),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F6F4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.timeline_outlined,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No habits logged yet',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start tracking your habits\nto see your progress here!',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _habitLogs.keys.length,
                        itemBuilder: (context, index) {
                          final habitName = _habitLogs.keys.elementAt(index);
                          final logs = _habitLogs[habitName]!;
                          final latestLog = logs.isNotEmpty ? logs.first : null;
                          
                          // Get habit color
                          Color habitColor = const Color(0xFF8FA2FF);
                          if (habitName == 'Sleep Hours' || habitName == 'Bedtime Patterns') {
                            habitColor = const Color(0xFFA596F5);
                          } else if (habitName == 'Meals' || habitName == 'Water') {
                            habitColor = const Color(0xFF95A663);
                          } else if (habitName == 'Steps' || habitName == 'Exercise') {
                            habitColor = const Color(0xFFFD904E);
                          }
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: habitColor.withOpacity(0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                dividerColor: Colors.transparent,
                              ),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                childrenPadding: const EdgeInsets.only(bottom: 16),
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: habitColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    _getHabitIcon(habitName),
                                    color: habitColor,
                                    size: 20,
                                  ),
                                ),
                                title: Text(
                                  habitName,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: latestLog != null
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Last: ${latestLog['date']}',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: habitColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                '${logs.length} entries',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: habitColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        'No entries yet',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                trailing: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: habitColor,
                                ),
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8F6F4),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recent Activities',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ...logs.take(5).map((log) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: log['goalMet'] == true ? habitColor : Colors.grey[400],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        log['date'],
                                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      Text(
                                                        _formatLogValue(habitName, log),
                                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (log['goalMet'] == true)
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: habitColor.withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      'Goal met',
                                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                        color: habitColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
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

  String _formatLogValue(String habitName, Map<String, dynamic> log) {
    final value = log['value'];
    final unit = log['unit'] ?? '';
    
    switch (habitName) {
      case 'Sleep Hours':
        return '$value $unit';
      case 'Bedtime Patterns':
        if (value is Map) {
          return 'Bed: ${value['bedtime']} • Wake: ${value['waketime']}';
        }
        return 'Times set';
      case 'Meals':
        final meals = log['meals'] as List<dynamic>?;
        return meals != null ? meals.join(', ') : '$value meals';
      case 'Exercise':
        final exercises = log['exercises'] as List<dynamic>?;
        if (exercises != null && exercises.isNotEmpty) {
          return '${exercises.length} activities • $value $unit total';
        }
        return '$value $unit';
      default:
        return '$value $unit';
    }
  }

  final List<String> _focusAreas = [];
  final List<String> _allFocusAreas = [
    'Sleep',
    'Anxiety',
    'Productivity',
    'Social',
    'Academic',
    'Self-esteem',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showHabitLogsDialog(context),
        backgroundColor: Color(0xFFE7DCD8),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        child: Icon(Icons.history, color: Theme.of(context).colorScheme.onSurface),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                ),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Focus Areas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Focus Areas
                      const Text(
                        'Select areas you want to focus on for better personalized content.',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _allFocusAreas.map((area) {
                          final isSelected = _focusAreas.contains(area);
                          return FilterChip(
                            label: Text(
                              area,
                              style: const TextStyle(fontSize: 12),
                            ),
                            selected: isSelected,
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            checkmarkColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            backgroundColor: Colors.grey.shade100,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _focusAreas.add(area);
                                } else {
                                  _focusAreas.remove(area);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Habit Tracking',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Sleep & Wellness',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sleep Hours
                      _buildMinimalHabitCard(
                        context,
                        icon: Icons.bedtime_outlined,
                        title: 'Sleep Hours',
                        description: 'Monitor your daily sleep duration',
                        points: '15 pts',
                        color: Color(0xFFA596F5),
                        habitName: 'Sleep Hours',
                        onTap: () =>
                            _showTrackingDialog(context, _sleepHabits[0]),
                      ),

                      const SizedBox(height: 12),

                      // Bedtime Patterns
                      _buildMinimalHabitCard(
                        context,
                        icon: Icons.schedule_outlined,
                        title: 'Bedtime Patterns',
                        description: 'Track your bedtime and wake-up routines',
                        points: '10 pts',
                        color: Color(0xFFA596F5),
                        habitName: 'Bedtime Patterns',
                        onTap: () =>
                            _showTrackingDialog(context, _sleepHabits[1]),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Health & Nutrition',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Meals
                      _buildMinimalHabitCard(
                        context,
                        icon: Icons.restaurant_outlined,
                        title: 'Meals',
                        description: 'Track your meal times and nutrition',
                        points: '10 pts',
                        color: Color(0xFF95A663),
                        habitName: 'Meals',
                        onTap: () =>
                            _showTrackingDialog(context, _healthHabits[0]),
                      ),

                      const SizedBox(height: 12),

                      // Water
                      _buildMinimalHabitCard(
                        context,
                        icon: Icons.local_drink_outlined,
                        title: 'Water',
                        description: 'Log your daily water consumption',
                        points: '5 pts',
                        color: Color(0xFF95A663),
                        habitName: 'Water',
                        onTap: () =>
                            _showTrackingDialog(context, _healthHabits[1]),
                      ),

                      const SizedBox(height: 32),

                      Text(
                        'Movement & Exercise',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Steps
                      _buildMinimalHabitCard(
                        context,
                        icon: Icons.directions_walk_outlined,
                        title: 'Daily Steps',
                        description: 'Track your daily step count and movement',
                        points: '15 pts',
                        color: Color(0xFFFD904E),
                        habitName: 'Steps',
                        onTap: () =>
                            _showTrackingDialog(context, _movementHabits[0]),
                      ),

                      const SizedBox(height: 12),

                      // Exercise
                      _buildMinimalHabitCard(
                        context,
                        icon: Icons.sports_soccer_outlined,
                        title: 'Exercise',
                        description: 'Log your sports and exercise activities',
                        points: '25 pts',
                        color: Color(0xFFFD904E),
                        habitName: 'Exercise',
                        onTap: () =>
                            _showTrackingDialog(context, _movementHabits[1]),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTrackingDialog(BuildContext context, Map<String, dynamic> habit) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with habit details
                _buildDialogHeader(context, habit),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildTrackingContent(context, habit, setDialogState),
                  ),
                ),
                // Action buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: habit['color'],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Log the habit based on type
                            _logHabitData(habit);
                            
                            // Update the UI immediately to show completion status
                            setState(() {});
                            
                            Navigator.pop(context);
                            // Show success feedback
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${habit['name']} logged successfully!',
                                ),
                                backgroundColor: habit['color'],
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: habit['color'],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Widget _buildDialogHeader(BuildContext context, Map<String, dynamic> habit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: habit['color'].withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: habit['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  habit['icon'],
                  color: habit['color'],
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['name'],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: habit['color'],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit['desc'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, size: 20),
                color: habit['color'],
                tooltip: 'Edit Target',
                onPressed: () => _showTargetEditDialog(context, habit),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTargetDisplay(context, habit),
        ],
      ),
    );
  }

  Widget _buildTargetDisplay(BuildContext context, Map<String, dynamic> habit) {
    final habitName = habit['name'];
    String targetText;
    String currentText;

    switch (habitName) {
      case 'Sleep Hours':
        targetText = 'Target: ${_sleepGoal.toStringAsFixed(1)} hours';
        currentText = 'Current: ${_sleepHours.toStringAsFixed(1)} hours';
        break;
      case 'Water':
        targetText = 'Target: $_waterGoal glasses';
        currentText = 'Current: $_waterIntake glasses';
        break;
      case 'Meals':
        targetText = 'Target: $_mealGoal meals';
        currentText = 'Current: ${_meals.length} meals';
        break;
      case 'Steps':
        targetText = 'Target: $_stepsGoal steps';
        currentText = 'Current: $_steps steps';
        break;
      case 'Exercise':
        targetText = 'Target: $_exerciseGoal minutes';
        final totalMinutes = _exercises.fold<int>(0, (sum, ex) => sum + (ex['duration'] as int? ?? 0));
        currentText = 'Current: $totalMinutes minutes';
        break;
      case 'Bedtime Patterns':
        final targetBed = _bedTimeGoal?.format(context) ?? '23:00';
        final targetWake = _wakeTimeGoal?.format(context) ?? '07:00';
        targetText = 'Target: $targetBed - $targetWake';
        final currentBed = _bedTime?.format(context) ?? 'Not set';
        final currentWake = _wakeTime?.format(context) ?? 'Not set';
        currentText = 'Current: $currentBed - $currentWake';
        break;
      default:
        targetText = 'Target: Not set';
        currentText = 'Current: Not tracked';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: habit['color'].withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  targetText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: habit['color'],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildProgressIndicator(context, habit),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, Map<String, dynamic> habit) {
    final habitName = habit['name'];
    double progress = 0.0;

    switch (habitName) {
      case 'Sleep Hours':
        progress = _sleepGoal > 0 ? (_sleepHours / _sleepGoal).clamp(0.0, 1.0) : 0.0;
        break;
      case 'Water':
        progress = _waterGoal > 0 ? (_waterIntake / _waterGoal).clamp(0.0, 1.0) : 0.0;
        break;
      case 'Meals':
        progress = _mealGoal > 0 ? (_meals.length / _mealGoal).clamp(0.0, 1.0) : 0.0;
        break;
      case 'Steps':
        progress = _stepsGoal > 0 ? (_steps / _stepsGoal).clamp(0.0, 1.0) : 0.0;
        break;
      case 'Exercise':
        final totalMinutes = _exercises.fold<int>(0, (sum, ex) => sum + (ex['duration'] as int? ?? 0));
        progress = _exerciseGoal > 0 ? (totalMinutes / _exerciseGoal).clamp(0.0, 1.0) : 0.0;
        break;
      default:
        progress = 0.0;
    }

    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        value: progress,
        backgroundColor: habit['color'].withOpacity(0.2),
        valueColor: AlwaysStoppedAnimation<Color>(habit['color']),
        strokeWidth: 4,
      ),
    );
  }

  void _showTargetEditDialog(BuildContext context, Map<String, dynamic> habit) {
    final habitName = habit['name'];
    final TextEditingController controller = TextEditingController();

    switch (habitName) {
      case 'Sleep Hours':
        controller.text = _sleepGoal.toString();
        break;
      case 'Water':
        controller.text = _waterGoal.toString();
        break;
      case 'Meals':
        controller.text = _mealGoal.toString();
        break;
      case 'Steps':
        controller.text = _stepsGoal.toString();
        break;
      case 'Exercise':
        controller.text = _exerciseGoal.toString();
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${habit['name']} Target'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (habitName == 'Bedtime Patterns') ...[
              Text('Set your target bedtime and wake-up time'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _bedTimeGoal ?? const TimeOfDay(hour: 23, minute: 0),
                        );
                        if (time != null) {
                          setState(() {
                            _bedTimeGoal = time;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text(_bedTimeGoal?.format(context) ?? 'Set Bedtime'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _wakeTimeGoal ?? const TimeOfDay(hour: 7, minute: 0),
                        );
                        if (time != null) {
                          setState(() {
                            _wakeTimeGoal = time;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text(_wakeTimeGoal?.format(context) ?? 'Set Wake Time'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _getTargetLabel(habitName),
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (habitName != 'Bedtime Patterns' && controller.text.isNotEmpty) {
                final value = double.tryParse(controller.text);
                if (value != null && value > 0) {
                  setState(() {
                    switch (habitName) {
                      case 'Sleep Hours':
                        _sleepGoal = value;
                        break;
                      case 'Water':
                        _waterGoal = value.toInt();
                        break;
                      case 'Meals':
                        _mealGoal = value.toInt();
                        break;
                      case 'Steps':
                        _stepsGoal = value.toInt();
                        break;
                      case 'Exercise':
                        _exerciseGoal = value.toInt();
                        break;
                    }
                  });
                }
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: habit['color'],
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  String _getTargetLabel(String habitName) {
    switch (habitName) {
      case 'Sleep Hours':
        return 'Target hours (e.g., 8.0)';
      case 'Water':
        return 'Target glasses per day';
      case 'Meals':
        return 'Target meals per day';
      case 'Steps':
        return 'Target steps per day';
      case 'Exercise':
        return 'Target minutes per day';
      default:
        return 'Target value';
    }
  }

  Widget _buildTrackingContent(BuildContext context, Map<String, dynamic> habit, [StateSetter? setDialogState]) {
    final habitName = habit['name'];
    switch (habitName) {
      case 'Sleep Hours':
        return _buildSleepHoursContent(context, habit, setDialogState);
      case 'Bedtime Patterns':
        return _buildBedtimePatternsContent(context, habit, setDialogState);
      case 'Meals':
        return _buildMealsContent(context, habit, setDialogState);
      case 'Water':
        return _buildWaterContent(context, habit, setDialogState);
      case 'Steps':
        return _buildStepsContent(context, habit, setDialogState);
      case 'Exercise':
        return _buildExerciseContent(context, habit);
      default:
        return _buildCustomHabitContent(context, habit);
    }
  }

  Widget _buildSleepHoursContent(BuildContext context, Map<String, dynamic> habit, [StateSetter? setDialogState]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'How many hours did you sleep last night?',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: habit['color'],
            thumbColor: habit['color'],
            valueIndicatorColor: habit['color'],
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Slider(
            value: _sleepHours,
            min: 0,
            max: 12,
            divisions: 24,
            label: '${_sleepHours.toStringAsFixed(1)} hrs',
            onChanged: (value) {
              _sleepHours = value;
              setState(() {});
              if (setDialogState != null) {
                setDialogState(() {});
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '${_sleepHours.toStringAsFixed(1)} hours',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: habit['color'],
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWaterContent(BuildContext context, Map<String, dynamic> habit, [StateSetter? setDialogState]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Track your daily water intake',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 40,
              color: habit['color'],
              onPressed: () {
                if (_waterIntake > 0) {
                  _waterIntake--;
                  setState(() {});
                  if (setDialogState != null) {
                    setDialogState(() {});
                  }
                }
              },
            ),
            const SizedBox(width: 24),
            Column(
              children: [
                Text(
                  '$_waterIntake',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: habit['color'],
                  ),
                ),
                const Text(
                  'glasses',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 40,
              color: habit['color'],
              onPressed: () {
                _waterIntake++;
                setState(() {});
                if (setDialogState != null) {
                  setDialogState(() {});
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildMealsContent(BuildContext context, Map<String, dynamic> habit, [StateSetter? setDialogState]) {
    final mealOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    final Color chipColor = habit['color'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Track your meals today',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: mealOptions.map((meal) {
            final logged = _meals.contains(meal);
            return FilterChip(
              label: Text(meal),
              selected: logged,
              selectedColor: chipColor.withOpacity(0.2),
              checkmarkColor: chipColor,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                color: logged ? chipColor : Colors.black,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (selected) {
                if (selected) {
                  _meals.add(meal);
                } else {
                  _meals.remove(meal);
                }
                setState(() {});
                if (setDialogState != null) {
                  setDialogState(() {});
                }
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (_meals.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: chipColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Logged meals: ${_meals.join(', ')}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  // Placeholder methods for other habits - these can be expanded later
  Widget _buildBedtimePatternsContent(BuildContext context, Map<String, dynamic> habit, [StateSetter? setDialogState]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Set your bedtime and wake-up time',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        
        // Bedtime picker
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: habit['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.bedtime, color: habit['color']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bedtime',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _bedTime?.format(context) ?? 'Not set',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: habit['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _bedTime ?? const TimeOfDay(hour: 23, minute: 0),
                  );
                  if (time != null) {
                    setState(() {
                      _bedTime = time;
                    });
                    if (setDialogState != null) {
                      setDialogState(() {});
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: habit['color'],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Set'),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Wake time picker
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: habit['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.wb_sunny, color: habit['color']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wake-up time',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _wakeTime?.format(context) ?? 'Not set',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: habit['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _wakeTime ?? const TimeOfDay(hour: 7, minute: 0),
                  );
                  if (time != null) {
                    setState(() {
                      _wakeTime = time;
                    });
                    if (setDialogState != null) {
                      setDialogState(() {});
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: habit['color'],
                  foregroundColor: Colors.white,
                ),
                child: const Text('Set'),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Sleep duration calculation
        if (_bedTime != null && _wakeTime != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: habit['color']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sleep Duration',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _calculateSleepDuration(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: habit['color'],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStepsContent(BuildContext context, Map<String, dynamic> habit, [StateSetter? setDialogState]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Track your daily steps',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        
        // Steps counter
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 40,
              color: habit['color'],
              onPressed: () {
                setState(() {
                  if (_steps >= 100) _steps -= 100;
                });
                if (setDialogState != null) {
                  setDialogState(() {});
                }
              },
            ),
            const SizedBox(width: 24),
            Column(
              children: [
                Text(
                  _steps.toString(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: habit['color'],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'steps',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 40,
              color: habit['color'],
              onPressed: () {
                setState(() {
                  _steps += 100;
                });
                if (setDialogState != null) {
                  setDialogState(() {});
                }
              },
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Progress bar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: habit['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${((_steps / _stepsGoal) * 100).clamp(0, 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: habit['color'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (_steps / _stepsGoal).clamp(0.0, 1.0),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(habit['color']),
              ),
              const SizedBox(height: 8),
              Text(
                '${_steps} / ${_stepsGoal} steps',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Quick add buttons
        Text(
          'Quick Add',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [500, 1000, 2500, 5000].map((steps) {
            return ElevatedButton(
              onPressed: () {
                setState(() {
                  _steps += steps;
                });
                if (setDialogState != null) {
                  setDialogState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: habit['color'].withOpacity(0.1),
                foregroundColor: habit['color'],
                elevation: 0,
              ),
              child: Text('+$steps'),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExerciseContent(BuildContext context, Map<String, dynamic> habit) {
    final TextEditingController typeController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    
    return StatefulBuilder(
      builder: (context, setExerciseState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Track your exercise activities',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          
          // Add new exercise
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: habit['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Exercise',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: typeController,
                        decoration: const InputDecoration(
                          labelText: 'Exercise Type',
                          hintText: 'e.g., Running, Yoga',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: durationController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Minutes',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (typeController.text.isNotEmpty && durationController.text.isNotEmpty) {
                          final duration = int.tryParse(durationController.text);
                          if (duration != null && duration > 0) {
                            setState(() {
                              _exercises.add({
                                'type': typeController.text,
                                'duration': duration,
                                'timestamp': DateTime.now().toIso8601String(),
                              });
                            });
                            setExerciseState(() {});
                            typeController.clear();
                            durationController.clear();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: habit['color'],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Exercise summary
          if (_exercises.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Summary',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Time',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${_exercises.fold<int>(0, (sum, ex) => sum + (ex['duration'] as int? ?? 0))} min',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Activities',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${_exercises.length}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Goal Progress',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${(((_exercises.fold<int>(0, (sum, ex) => sum + (ex['duration'] as int? ?? 0)) / _exerciseGoal) * 100).clamp(0, 100).toInt())}%',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Exercise list
            Text(
              'Today\'s Activities',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ..._exercises.map((exercise) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: habit['color'].withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.fitness_center, color: habit['color'], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        exercise['type'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '${exercise['duration']} min',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: habit['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: Colors.grey,
                      onPressed: () {
                        setState(() {
                          _exercises.remove(exercise);
                        });
                        setExerciseState(() {});
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No exercises logged today',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add your first exercise above!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCustomHabitContent(BuildContext context, Map<String, dynamic> habit) {
    return Text('Custom habit tracking content goes here');
  }

  Widget _buildMinimalHabitCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String points,
    required Color color,
    String? habitName,
    VoidCallback? onTap,
  }) {
    final isCompleted = habitName != null ? _isHabitCompletedToday(habitName) : false;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isCompleted ? Border.all(color: color.withOpacity(0.3), width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isCompleted ? color.withOpacity(0.1) : Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isCompleted ? color : Theme.of(context).colorScheme.onSurface,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '✓ Done',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: color,
                            ),
                          ),
                        )
                      else
                        Text(
                          points,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.outline,
                            letterSpacing: 0.2,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.outline,
                      letterSpacing: 0.1,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Arrow or checkmark
            Icon(
              isCompleted ? Icons.check_circle : Icons.chevron_right,
              color: isCompleted ? color : Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
