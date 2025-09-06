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
  List<String> _meals = [];
  int _waterIntake = 0;
  int _fruitServings = 0;

  // Movement & Exercise trackers
  int _steps = 0;
  List<Map<String, dynamic>> _exercises = [];

  // Goals for each tracker
  double _sleepGoal = 8.0;
  TimeOfDay? _bedTimeGoal;
  TimeOfDay? _wakeTimeGoal;
  int _napGoal = 1;
  int _mealGoal = 3;
  int _waterGoal = 8;
  int _fruitGoal = 2;
  int _stepsGoal = 10000;
  int _exerciseGoal = 30;

  final List<Map<String, dynamic>> _sleepHabits = [
    {
      'name': 'Sleep Hours',
      'desc': 'Monitor your daily sleep duration.',
      'icon': Icons.bedtime,
      'color': Colors.indigo,
    },
    {
      'name': 'Bedtime Patterns',
      'desc': 'Track your bedtime and wake-up routines.',
      'icon': Icons.schedule,
      'color': Colors.deepPurple,
    },
    {
      'name': 'Nap Breaks',
      'desc': 'Log and review your nap times.',
      'icon': Icons.snooze,
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> _healthHabits = [
    {
      'name': 'Meals',
      'desc': 'Track your meal times and nutrition.',
      'icon': Icons.restaurant,
      'color': Colors.redAccent,
    },
    {
      'name': 'Water',
      'desc': 'Log your daily water intake.',
      'icon': Icons.local_drink,
      'color': Colors.blue,
    },
    {
      'name': 'Fruits',
      'desc': 'Track your daily fruit servings.',
      'icon': Icons.apple,
      'color': Colors.green,
    },
  ];

  final List<Map<String, dynamic>> _movementHabits = [
    {
      'name': 'Steps',
      'desc': 'Track your daily step count.',
      'icon': Icons.directions_walk,
      'color': Colors.deepPurple,
    },
    {
      'name': 'Exercise',
      'desc': 'Log your sports and exercise activities.',
      'icon': Icons.sports_soccer,
      'color': Colors.indigo,
    },
  ];

  void _showAddHabitDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController goalController = TextEditingController();
    IconData selectedIcon = Icons.star;
    Color selectedColor = Colors.purple;

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
                        icon: Icon(
                          option['icon'] as IconData,
                          color: option['color'] as Color,
                        ),
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
                    decoration: const InputDecoration(
                      labelText: 'Tracker Type',
                    ),
                    items: trackerTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
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
                    decoration: const InputDecoration(
                      labelText: 'Goal (optional)',
                    ),
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

  Widget _buildEditableList(
    String title,
    List<Map<String, dynamic>> habits,
    void Function(void Function()) setStateDialog,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
  Widget _buildSleepHoursTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target sleep: ${_sleepGoal.toStringAsFixed(1)} hrs',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                    final controller = TextEditingController(
                      text: _sleepGoal.toString(),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Sleep Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Goal (hours)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _sleepGoal =
                                    double.tryParse(controller.text) ??
                                    _sleepGoal;
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
                  setState(() {
                    _sleepHours = value;
                  });
                },
              ),
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
  Widget _buildBedtimePatternsTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
    String targetBed = _bedTimeGoal != null
        ? _bedTimeGoal!.format(context)
        : '23:00';
    String targetWake = _wakeTimeGoal != null
        ? _wakeTimeGoal!.format(context)
        : '07:00';

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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Target bedtime: $targetBed',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: habit['color'],
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              'Target wake-up: $targetWake',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: habit['color'],
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.start,
                            ),
                          ],
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
                      initialTime:
                          _bedTimeGoal ?? TimeOfDay(hour: 23, minute: 0),
                    );
                    if (pickedBed != null) {
                      final pickedWake = await showTimePicker(
                        context: context,
                        initialTime:
                            _wakeTimeGoal ?? TimeOfDay(hour: 7, minute: 0),
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
  Widget _buildNapBreaksTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target naps: $_napGoal',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                    final controller = TextEditingController(
                      text: _napGoal.toString(),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Nap Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Goal (naps)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _napGoal =
                                    int.tryParse(controller.text) ?? _napGoal;
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
              style: ElevatedButton.styleFrom(
                backgroundColor: habit['color'],
                foregroundColor: Colors.white,
              ),
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
                  const Text(
                    'Logged Naps:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._naps.map(
                    (nap) => ListTile(
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
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Meals tracker card
  Widget _buildMealsTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target meals: $_mealGoal',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                    final controller = TextEditingController(
                      text: _mealGoal.toString(),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Meal Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Goal (meals)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _mealGoal =
                                    int.tryParse(controller.text) ?? _mealGoal;
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
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: mealOptions.map((meal) {
                final logged = _meals.contains(meal);
                return FilterChip(
                  label: Text(meal),
                  selected: logged,
                  selectedColor: chipColor.withOpacity(0.2),
                  checkmarkColor: chipColor,
                  backgroundColor: Colors.white,
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
  Widget _buildWaterTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target water: $_waterGoal glasses',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                    final controller = TextEditingController(
                      text: _waterGoal.toString(),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Water Intake Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Goal (glasses)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _waterGoal =
                                    int.tryParse(controller.text) ?? _waterGoal;
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
  Widget _buildFruitsTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target fruits: $_fruitGoal servings',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                    final controller = TextEditingController(
                      text: _fruitGoal.toString(),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Fruit Servings Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Goal (servings)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _fruitGoal =
                                    int.tryParse(controller.text) ?? _fruitGoal;
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
  Widget _buildStepsTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          habit['desc'],
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Target steps: $_stepsGoal',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
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
                      final controller = TextEditingController(
                        text: _stepsGoal.toString(),
                      );
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Set Steps Goal'),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Goal (steps)',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _stepsGoal =
                                      int.tryParse(controller.text) ??
                                      _stepsGoal;
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
                    activeColor: habit['color'],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _linkedToPhone
                        ? 'Linked to phone (auto sync)'
                        : 'Manual entry',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (_linkedToPhone)
                    TextButton(
                      onPressed: () {
                        setStateCard(() {
                          setState(() {
                            _linkedToPhone = false;
                          });
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor:
                            habit['color'], // Sync manual entry button color
                      ),
                      child: const Text('Manual Entry'),
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
  Widget _buildExerciseTrackerCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit['desc'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Target: $_exerciseGoal min exercise',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
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
                    final controller = TextEditingController(
                      text: _exerciseGoal.toString(),
                    );
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Set Exercise Goal'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Goal (minutes)',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _exerciseGoal =
                                    int.tryParse(controller.text) ??
                                    _exerciseGoal;
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
                    decoration: const InputDecoration(labelText: 'Minutes'),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        habit['color'], // Sync add button color with icon
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_exercises.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Logged Activities:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._exercises.map(
                    (ex) => ListTile(
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
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHabitCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      if (goal != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Goal: $goal',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
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
                          habit['trackerValue'] =
                              (habit['trackerValue'] ?? 0) - 1;
                        }
                      });
                    },
                  ),
                  Text('${habit['trackerValue'] ?? 0}'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        habit['trackerValue'] =
                            (habit['trackerValue'] ?? 0) + 1;
                      });
                    },
                  ),
                ],
              )
            else if (trackerType == 'Timer')
              Row(
                children: [
                  Text(
                    'Time: ${_formatDuration(habit['trackerValue'] ?? Duration.zero)}',
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                          hour:
                              (habit['trackerValue'] as Duration?)?.inHours ??
                              0,
                          minute:
                              (habit['trackerValue'] as Duration?)?.inMinutes
                                  .remainder(60) ??
                              0,
                        ),
                      );
                      if (picked != null) {
                        setState(() {
                          habit['trackerValue'] = Duration(
                            hours: picked.hour,
                            minutes: picked.minute,
                          );
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
                controller: TextEditingController(
                  text: habit['trackerValue'] ?? '',
                ),
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
                        color: (habit['trackerValue'] ?? 0) >= i
                            ? Colors.amber
                            : Colors.grey,
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
                  Text(
                    'Progress: ${((habit['trackerValue'] ?? 0.0) * 100).toInt()}%',
                  ),
                ],
              )
            else if (trackerType == 'Dropdown')
              DropdownButton<String>(
                value: habit['trackerValue'] == ''
                    ? null
                    : habit['trackerValue'],
                hint: const Text('Select option'),
                items: ['Option 1', 'Option 2', 'Option 3']
                    .map(
                      (opt) => DropdownMenuItem(value: opt, child: Text(opt)),
                    )
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

  Widget _buildDynamicHabitCard(
    BuildContext context,
    Map<String, dynamic> habit,
  ) {
    final habitName = habit['name'];
    switch (habitName) {
      case 'Sleep Hours':
        return _buildSleepHoursTrackerCard(context, habit);
      case 'Bedtime Patterns':
        return _buildBedtimePatternsTrackerCard(context, habit);
      case 'Nap Breaks':
        return _buildNapBreaksTrackerCard(context, habit);
      case 'Meals':
        return _buildMealsTrackerCard(context, habit);
      case 'Water':
        return _buildWaterTrackerCard(context, habit);
      case 'Fruits':
        return _buildFruitsTrackerCard(context, habit);
      case 'Steps':
        return _buildStepsTrackerCard(context, habit);
      case 'Exercise':
        return _buildExerciseTrackerCard(context, habit);
      default:
        return _buildCustomHabitCard(context, habit);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}';
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Focus Areas & Goals',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                      label: Text(area, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
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
                  color: const Color(0xFF8FA2FF),
                  onTap: () => _showTrackingDialog(context, _sleepHabits[0]),
                ),

                const SizedBox(height: 12),

                // Bedtime Patterns
                _buildMinimalHabitCard(
                  context,
                  icon: Icons.schedule_outlined,
                  title: 'Bedtime Patterns',
                  description: 'Track your bedtime and wake-up routines',
                  points: '10 pts',
                  color: const Color(0xFFA18FFF),
                  onTap: () => _showTrackingDialog(context, _sleepHabits[1]),
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
                  color: const Color(0xFFFFCE5D),
                  onTap: () => _showTrackingDialog(context, _healthHabits[0]),
                ),

                const SizedBox(height: 12),

                // Water Intake
                _buildMinimalHabitCard(
                  context,
                  icon: Icons.local_drink_outlined,
                  title: 'Water Intake',
                  description: 'Log your daily water consumption',
                  points: '5 pts',
                  color: const Color(0xFF8FA2FF),
                  onTap: () => _showTrackingDialog(context, _healthHabits[1]),
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
                  color: const Color(0xFF95A663),
                  onTap: () => _showTrackingDialog(context, _movementHabits[0]),
                ),

                const SizedBox(height: 12),

                // Exercise
                _buildMinimalHabitCard(
                  context,
                  icon: Icons.sports_soccer_outlined,
                  title: 'Exercise',
                  description: 'Log your sports and exercise activities',
                  points: '25 pts',
                  color: const Color(0xFFA18FFF),
                  onTap: () => _showTrackingDialog(context, _movementHabits[1]),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTrackingDialog(BuildContext context, Map<String, dynamic> habit) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: habit['color'].withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(habit['icon'], color: habit['color'], size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        habit['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: habit['color'],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Content
              Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildDynamicHabitCard(context, habit),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalHabitCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String points,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87, size: 24),
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
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Text(
                        points,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF9B9B9B),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9B9B9B),
                      letterSpacing: 0.1,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Arrow
            Icon(Icons.chevron_right, color: Colors.black87, size: 20),
          ],
        ),
      ),
    );
  }
}
