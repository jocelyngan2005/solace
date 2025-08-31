import 'package:flutter/material.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  _HabitTrackerState createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  final List<Map<String, dynamic>> _customHabits = [];

  // Sleep Hours tracker
  double _sleepHours = 7.0;

  // Bedtime Patterns tracker
  TimeOfDay? _bedTime;
  TimeOfDay? _wakeTime;

  // Nap Breaks tracker
  List<Map<String, TimeOfDay>> _naps = [];

  // Health Habits trackers
  List<String> _meals = []; // Stores meal names/times
  int _waterIntake = 0; // Number of glasses
  int _fruitServings = 0; // Number of fruit servings

  // Movement & Exercise trackers
  int _steps = 0;
  List<Map<String, dynamic>> _exercises = []; // Each: {'type': String, 'duration': int (minutes)}

  // Goals for each tracker
  double _sleepGoal = 8.0;
  TimeOfDay? _bedTimeGoal;
  TimeOfDay? _wakeTimeGoal;
  int _napGoal = 1;
  int _mealGoal = 3;
  int _waterGoal = 8;
  int _fruitGoal = 2;
  int _stepsGoal = 10000;
  int _exerciseGoal = 30; // minutes

  // Default habits as lists so they can be rearranged/deleted
  final List<Map<String, dynamic>> _sleepHabits = [
    {
      'name': 'Sleep Hours',
      'desc': 'Monitor your daily sleep duration.',
      'icon': Icons.bedtime,
      'color': Colors.indigo, // Updated to match icon's theme
    },
    {
      'name': 'Bedtime Patterns',
      'desc': 'Track your bedtime and wake-up routines.',
      'icon': Icons.schedule,
      'color': Colors.deepPurple, // Updated to match icon's theme
    },
    {
      'name': 'Nap Breaks',
      'desc': 'Log and review your nap times.',
      'icon': Icons.snooze,
      'color': Colors.orange, // Matches icon
    },
  ];

  final List<Map<String, dynamic>> _healthHabits = [
    {
      'name': 'Meals',
      'desc': 'Track your meal times and nutrition.',
      'icon': Icons.restaurant,
      'color': Colors.redAccent, // Updated to match icon's theme
    },
    {
      'name': 'Water',
      'desc': 'Log your daily water intake.',
      'icon': Icons.local_drink,
      'color': Colors.blue, // Updated to match icon's theme
    },
    {
      'name': 'Fruits',
      'desc': 'Track your daily fruit servings.',
      'icon': Icons.apple,
      'color': Colors.green, // Updated to match icon's theme
    },
  ];

  final List<Map<String, dynamic>> _movementHabits = [
    {
      'name': 'Steps',
      'desc': 'Track your daily step count.',
      'icon': Icons.directions_walk,
      'color': Colors.deepPurple, // Matches icon
    },
    {
      'name': 'Exercise',
      'desc': 'Log your sports and exercise activities.',
      'icon': Icons.sports_soccer,
      'color': Colors.indigo, // Matches icon
    },
  ];

  void _showAddHabitDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController goalController = TextEditingController();
    IconData selectedIcon = Icons.star;
    Color selectedColor = Colors.purple;

    // Add more tracker types here
    final trackerTypes = [
      'Checkbox',
      'Counter',
      'Timer',
      'Text Log',
      'Rating',
      'Progress',
      'Dropdown',
      'Date Picker',
      'Time Picker',
      'Switch',
    ];
    String selectedTrackerType = trackerTypes[0];

    // Add more icons here
    final iconOptions = [
      {'icon': Icons.star, 'color': Colors.purple},
      {'icon': Icons.favorite, 'color': Colors.red},
      {'icon': Icons.check_circle, 'color': Colors.green},
      {'icon': Icons.flag, 'color': Colors.orange},
      {'icon': Icons.book, 'color': Colors.blue},
      {'icon': Icons.fitness_center, 'color': Colors.indigo},
      {'icon': Icons.local_florist, 'color': Colors.teal},
      {'icon': Icons.wb_sunny, 'color': Colors.amber},
      {'icon': Icons.nightlight_round, 'color': Colors.deepPurple},
      {'icon': Icons.water_drop, 'color': Colors.lightBlue},
      {'icon': Icons.coffee, 'color': Colors.brown},
      {'icon': Icons.apple, 'color': Colors.redAccent},
      {'icon': Icons.sports_soccer, 'color': Colors.indigo},
      {'icon': Icons.directions_walk, 'color': Colors.deepPurple},
      {'icon': Icons.snooze, 'color': Colors.orange},
      {'icon': Icons.restaurant, 'color': Colors.teal},
      {'icon': Icons.schedule, 'color': Colors.green},
      {'icon': Icons.emoji_events, 'color': Colors.yellow},
      {'icon': Icons.music_note, 'color': Colors.pink},
      {'icon': Icons.work, 'color': Colors.grey},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Add Custom Habit'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Habit Name'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: iconOptions.map((option) {
                      return IconButton(
                        icon: Icon(option['icon'] as IconData, color: option['color'] as Color),
                        onPressed: () {
                          setStateDialog(() {
                            selectedIcon = option['icon'] as IconData;
                            selectedColor = option['color'] as Color;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedTrackerType,
                    decoration: const InputDecoration(labelText: 'Tracker Type'),
                    items: trackerTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedTrackerType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: goalController,
                    decoration: const InputDecoration(labelText: 'Goal (optional)'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      _customHabits.add({
                        'name': nameController.text,
                        'desc': descController.text,
                        'icon': selectedIcon,
                        'color': selectedColor,
                        'trackerType': selectedTrackerType,
                        'trackerValue': selectedTrackerType == 'Checkbox'
                            ? false
                            : selectedTrackerType == 'Counter'
                                ? 0
                                : selectedTrackerType == 'Timer'
                                    ? Duration.zero
                                    : selectedTrackerType == 'Text Log'
                                        ? ''
                                        : selectedTrackerType == 'Rating'
                                            ? 0
                                            : selectedTrackerType == 'Progress'
                                                ? 0.0
                                                : selectedTrackerType == 'Dropdown'
                                                    ? ''
                                                    : selectedTrackerType == 'Date Picker'
                                                        ? null
                                                        : selectedTrackerType == 'Time Picker'
                                                            ? null
                                                            : selectedTrackerType == 'Switch'
                                                                ? false
                                                                : null,
                        'goal': goalController.text.isNotEmpty
                            ? num.tryParse(goalController.text)
                            : null,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditHabitsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Edit Habits'),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildEditableList(
                      'Sleep & Rest Habits',
                      _sleepHabits,
                      setStateDialog,
                    ),
                    const SizedBox(height: 16),
                    _buildEditableList(
                      'Health Habits',
                      _healthHabits,
                      setStateDialog,
                    ),
                    const SizedBox(height: 16),
                    _buildEditableList(
                      'Movement & Exercise Habits',
                      _movementHabits,
                      setStateDialog,
                    ),
                    if (_customHabits.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildEditableList(
                        'Custom Habits',
                        _customHabits,
                        setStateDialog,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditableList(String title, List<Map<String, dynamic>> habits, void Function(void Function()) setStateDialog) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: habits.length * 70.0,
          child: ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setStateDialog(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = habits.removeAt(oldIndex);
                habits.insert(newIndex, item);
              });
              setState(() {});
            },
            children: [
              for (int i = 0; i < habits.length; i++)
                ListTile(
                  key: ValueKey(habits[i]['name']),
                  leading: Icon(habits[i]['icon'], color: habits[i]['color']),
                  title: Text(habits[i]['name']),
                  subtitle: Text(habits[i]['desc']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setStateDialog(() {
                        habits.removeAt(i);
                      });
                      setState(() {});
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Sleep Hours tracker card
  Widget _buildSleepHoursTrackerCard(BuildContext context) {
    final habit = _sleepHabits[0];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target sleep: ${_sleepGoal.toStringAsFixed(1)} hrs',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Goal',
                  onPressed: () async {
                    final controller = TextEditingController(text: _sleepGoal.toString());
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Sleep Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Goal (hours)'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _sleepGoal = double.tryParse(controller.text) ?? _sleepGoal;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'How many hours did you sleep last night?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _sleepHours,
              min: 0,
              max: 12,
              divisions: 24,
              label: '${_sleepHours.toStringAsFixed(1)} hrs',
              onChanged: (value) {
                setState(() {
                  _sleepHours = value;
                });
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_sleepHours.toStringAsFixed(1)} hours / Target: ${_sleepGoal.toStringAsFixed(1)} hrs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bedtime Patterns tracker card
  Widget _buildBedtimePatternsTrackerCard(BuildContext context) {
    final habit = _sleepHabits[1];
    String targetBed = _bedTimeGoal != null ? _bedTimeGoal!.format(context) : '23:00';
    String targetWake = _wakeTimeGoal != null ? _wakeTimeGoal!.format(context) : '07:00';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target bedtime: $targetBed and wake time: $targetWake',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Target Bedtime',
                  onPressed: () async {
                    final pickedBed = await showTimePicker(
                      context: context,
                      initialTime: _bedTimeGoal ?? TimeOfDay(hour: 23, minute: 0),
                    );
                    if (pickedBed != null) {
                      final pickedWake = await showTimePicker(
                        context: context,
                        initialTime: _wakeTimeGoal ?? TimeOfDay(hour: 7, minute: 0),
                      );
                      setState(() {
                        _bedTimeGoal = pickedBed;
                        if (pickedWake != null) {
                          _wakeTimeGoal = pickedWake;
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      _bedTime == null
                          ? 'Set Bedtime'
                          : 'Bedtime: ${_bedTime!.format(context)}',
                    ),
                    trailing: Icon(Icons.bedtime),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _bedTime ?? TimeOfDay(hour: 22, minute: 0),
                      );
                      if (picked != null) {
                        setState(() {
                          _bedTime = picked;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      _wakeTime == null
                          ? 'Set Wake-up'
                          : 'Wake-up: ${_wakeTime!.format(context)}',
                    ),
                    trailing: Icon(Icons.wb_sunny),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _wakeTime ?? TimeOfDay(hour: 7, minute: 0),
                      );
                      if (picked != null) {
                        setState(() {
                          _wakeTime = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            if (_bedTime != null && _wakeTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Sleep window: ${_bedTime!.format(context)} - ${_wakeTime!.format(context)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Nap Breaks tracker card
  Widget _buildNapBreaksTrackerCard(BuildContext context) {
    final habit = _sleepHabits[2];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target naps: $_napGoal',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Nap Goal',
                  onPressed: () async {
                    final controller = TextEditingController(text: _napGoal.toString());
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Nap Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Goal (naps)'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _napGoal = int.tryParse(controller.text) ?? _napGoal;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Log Nap'),
              onPressed: () async {
                final start = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (start != null) {
                  final end = await showTimePicker(
                    context: context,
                    initialTime: start.replacing(hour: start.hour + 1),
                  );
                  if (end != null) {
                    setState(() {
                      _naps.add({'start': start, 'end': end});
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 8),
            if (_naps.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Logged Naps:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._naps.map((nap) => ListTile(
                        title: Text(
                          '${nap['start']!.format(context)} - ${nap['end']!.format(context)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _naps.remove(nap);
                            });
                          },
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Meals tracker card
  Widget _buildMealsTrackerCard(BuildContext context) {
    final habit = _healthHabits[0];
    final mealOptions = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    final Color chipColor = habit['color'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target meals: $_mealGoal',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Goal',
                  onPressed: () async {
                    final controller = TextEditingController(text: _mealGoal.toString());
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Meal Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Goal (meals)'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _mealGoal = int.tryParse(controller.text) ?? _mealGoal;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: mealOptions.map((meal) {
                final logged = _meals.contains(meal);
                return FilterChip(
                  label: Text(meal),
                  selected: logged,
                  selectedColor: chipColor.withOpacity(0.2),
                  checkmarkColor: chipColor,
                  backgroundColor: Colors.white, // <-- updated from grey to white
                  labelStyle: TextStyle(
                    color: logged ? chipColor : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _meals.add(meal);
                      } else {
                        _meals.remove(meal);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            if (_meals.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Logged meals: ${_meals.join(', ')} / Target: $_mealGoal',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Water tracker card
  Widget _buildWaterTrackerCard(BuildContext context) {
    final habit = _healthHabits[1];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target water: $_waterGoal glasses',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Goal',
                  onPressed: () async {
                    final controller = TextEditingController(text: _waterGoal.toString());
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Water Intake Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Goal (glasses)'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _waterGoal = int.tryParse(controller.text) ?? _waterGoal;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 8),
                Text('Glasses: $_waterIntake'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_waterIntake > 0) _waterIntake--;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _waterIntake++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fruits tracker card
  Widget _buildFruitsTrackerCard(BuildContext context) {
    final habit = _healthHabits[2];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target fruits: $_fruitGoal servings',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Goal',
                  onPressed: () async {
                    final controller = TextEditingController(text: _fruitGoal.toString());
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Fruit Servings Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Goal (servings)'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fruitGoal = int.tryParse(controller.text) ?? _fruitGoal;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 8),
                Text('Servings: $_fruitServings'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_fruitServings > 0) _fruitServings--;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _fruitServings++;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Steps tracker card
  Widget _buildStepsTrackerCard(BuildContext context) {
    final habit = _movementHabits[0];
    bool _linkedToPhone = false;

    return StatefulBuilder(
      builder: (context, setStateCard) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: habit['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(habit['icon'], color: habit['color'], size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          habit['desc'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Target steps: $_stepsGoal',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: habit['color'],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flag, size: 20),
                    tooltip: 'Set Target Steps',
                    onPressed: () async {
                      final controller = TextEditingController(text: _stepsGoal.toString());
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Set Steps Goal'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Goal (steps)'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _stepsGoal = int.tryParse(controller.text) ?? _stepsGoal;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Text('Steps: $_steps'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _linkedToPhone
                        ? null
                        : () {
                            setState(() {
                              if (_steps >= 100) _steps -= 100;
                            });
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _linkedToPhone
                        ? null
                        : () {
                            setState(() {
                              _steps += 100;
                            });
                          },
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Add or subtract steps in increments of 100.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Switch(
                    value: _linkedToPhone,
                    onChanged: (value) {
                      setStateCard(() {
                        _linkedToPhone = value;
                        // Here you would trigger phone pedometer integration.
                        // For demo, we'll just simulate a value.
                        if (_linkedToPhone) {
                          setState(() {
                            _steps = 4321; // Example value
                          });
                        }
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _linkedToPhone
                        ? 'Linked to phone (auto sync)'
                        : 'Manual entry',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Current: $_steps / Target: $_stepsGoal',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
      );
  }

  // Exercise tracker card
  Widget _buildExerciseTrackerCard(BuildContext context) {
    final habit = _movementHabits[1];
    final TextEditingController typeController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: habit['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(habit['icon'], color: habit['color'], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target: $_exerciseGoal min exercise',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: habit['color'],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.flag, size: 20),
                  tooltip: 'Set Exercise Goal',
                  onPressed: () async {
                    final controller = TextEditingController(text: _exerciseGoal.toString());
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Exercise Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Goal (minutes)'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _exerciseGoal = int.tryParse(controller.text) ?? _exerciseGoal;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      labelText: 'Activity (e.g. Running)',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutes',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (typeController.text.isNotEmpty &&
                        int.tryParse(durationController.text) != null) {
                      setState(() {
                        _exercises.add({
                          'type': typeController.text,
                          'duration': int.parse(durationController.text),
                        });
                      });
                      typeController.clear();
                      durationController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_exercises.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Logged Activities:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ..._exercises.map((ex) => ListTile(
                        title: Text('${ex['type']}'),
                        subtitle: Text('${ex['duration']} min'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _exercises.remove(ex);
                            });
                          },
                        ),
                      )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHabitCard(BuildContext context, Map<String, dynamic> habit) {
    final trackerType = habit['trackerType'];
    final color = habit['color'];
    final icon = habit['icon'];
    final name = habit['name'];
    final desc = habit['desc'];
    final goal = habit['goal'];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey[600]),
                      ),
                      if (goal != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Goal: $goal',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (trackerType == 'Checkbox')
              Row(
                children: [
                  Checkbox(
                    value: habit['trackerValue'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        habit['trackerValue'] = value;
                      });
                    },
                  ),
                  const Text('Completed'),
                ],
              )
            else if (trackerType == 'Counter')
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if ((habit['trackerValue'] ?? 0) > 0) {
                          habit['trackerValue'] = (habit['trackerValue'] ?? 0) - 1;
                        }
                      });
                    },
                  ),
                  Text('${habit['trackerValue'] ?? 0}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        habit['trackerValue'] = (habit['trackerValue'] ?? 0) + 1;
                      });
                    },
                  ),
                ],
              )
            else if (trackerType == 'Timer')
              Row(
                children: [
                  Text('Time: ${_formatDuration(habit['trackerValue'] ?? Duration.zero)}'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour: (habit['trackerValue'] as Duration?)?.inHours ?? 0,
                          minute: (habit['trackerValue'] as Duration?)?.inMinutes.remainder(60) ?? 0,
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          habit['trackerValue'] =
                              Duration(hours: picked.hour, minutes: picked.minute);
                        });
                      }
                    },
                    child: const Text('Set Time'),
                  ),
                ],
              )
            else if (trackerType == 'Text Log')
              TextField(
                decoration: const InputDecoration(labelText: 'Log'),
                controller: TextEditingController(text: habit['trackerValue'] ?? ''),
                onChanged: (value) {
                  setState(() {
                    habit['trackerValue'] = value;
                  });
                },
              )
            else if (trackerType == 'Rating')
              Row(
                children: [
                  for (int i = 1; i <= 5; i++)
                    IconButton(
                      icon: Icon(
                        Icons.star,
                        color: (habit['trackerValue'] ?? 0) >= i ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          habit['trackerValue'] = i;
                        });
                      },
                    ),
                  Text('${habit['trackerValue'] ?? 0}/5'),
                ],
              )
            else if (trackerType == 'Progress')
              Column(
                children: [
                  Slider(
                    value: (habit['trackerValue'] ?? 0.0) as double,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: '${((habit['trackerValue'] ?? 0.0) * 100).toInt()}%',
                    onChanged: (value) {
                      setState(() {
                        habit['trackerValue'] = value;
                      });
                    },
                  ),
                  Text('Progress: ${((habit['trackerValue'] ?? 0.0) * 100).toInt()}%'),
                ],
              )
            else if (trackerType == 'Dropdown')
              DropdownButton<String>(
                value: habit['trackerValue'] == '' ? null : habit['trackerValue'],
                hint: const Text('Select option'),
                items: ['Option 1', 'Option 2', 'Option 3']
                    .map((opt) => DropdownMenuItem(
                          value: opt,
                          child: Text(opt),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    habit['trackerValue'] = value;
                  });
                },
              )
            else if (trackerType == 'Date Picker')
              Row(
                children: [
                  Text(
                    habit['trackerValue'] == null
                        ? 'No date selected'
                        : 'Date: ${habit['trackerValue'].toString().split(' ')[0]}',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: habit['trackerValue'] ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          habit['trackerValue'] = picked;
                        });
                      }
                    },
                    child: const Text('Pick Date'),
                  ),
                ],
              )
            else if (trackerType == 'Time Picker')
              Row(
                children: [
                  Text(
                    habit['trackerValue'] == null
                        ? 'No time selected'
                        : 'Time: ${(habit['trackerValue'] as TimeOfDay).format(context)}',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: habit['trackerValue'] ?? TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          habit['trackerValue'] = picked;
                        });
                      }
                    },
                    child: const Text('Pick Time'),
                  ),
                ],
              )
            else if (trackerType == 'Switch')
              Row(
                children: [
                  Switch(
                    value: habit['trackerValue'] ?? false,
                    onChanged: (value) {
                      setState(() {
                        habit['trackerValue'] = value;
                      });
                    },
                  ),
                  Text((habit['trackerValue'] ?? false) ? 'On' : 'Off'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Custom Habit',
            onPressed: _showAddHabitDialog,
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            tooltip: 'Edit Habits',
            onPressed: _showEditHabitsDialog,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sleep & Rest Habits section
                _buildSection(
                  context,
                  title: 'Sleep & Rest Habits',
                  cards: [
                    _buildSleepHoursTrackerCard(context),
                    _buildBedtimePatternsTrackerCard(context),
                    _buildNapBreaksTrackerCard(context),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Health Habits',
                  cards: [
                    _buildMealsTrackerCard(context),
                    _buildWaterTrackerCard(context),
                    _buildFruitsTrackerCard(context),
                  ],
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Movement & Exercise Habits',
                  cards: [
                    _buildStepsTrackerCard(context),
                    _buildExerciseTrackerCard(context),
                  ],
                ),
                if (_customHabits.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Custom Habits',
                    cards: _customHabits
                        .map((habit) => _buildCustomHabitCard(context, habit))
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> cards,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              cards[i],
              if (i < cards.length - 1) const SizedBox(height: 16),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
