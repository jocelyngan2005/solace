import 'package:flutter/material.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  _HabitTrackerState createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  final List<Map<String, dynamic>> _customHabits = [];

  // Default habits as lists so they can be rearranged/deleted
  final List<Map<String, dynamic>> _sleepHabits = [
    {
      'name': 'Sleep Hours',
      'desc': 'Monitor your daily sleep duration.',
      'icon': Icons.bedtime,
      'color': Colors.blue,
    },
    {
      'name': 'Bedtime Patterns',
      'desc': 'Track your bedtime and wake-up routines.',
      'icon': Icons.schedule,
      'color': Colors.green,
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
      'color': Colors.teal,
    },
    {
      'name': 'Water',
      'desc': 'Log your daily water intake.',
      'icon': Icons.local_drink,
      'color': Colors.lightBlue,
    },
    {
      'name': 'Beverage',
      'desc': 'Monitor your beverage consumption.',
      'icon': Icons.coffee,
      'color': Colors.brown,
    },
    {
      'name': 'Fruits',
      'desc': 'Track your daily fruit servings.',
      'icon': Icons.apple,
      'color': Colors.redAccent,
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
      'name': 'Sports/Exercise',
      'desc': 'Log your sports and exercise activities.',
      'icon': Icons.sports_soccer,
      'color': Colors.indigo,
    },
  ];

  void _showAddHabitDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    IconData selectedIcon = Icons.star;
    Color selectedColor = Colors.purple;

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
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.star, color: Colors.purple),
                        onPressed: () {
                          setStateDialog(() {
                            selectedIcon = Icons.star;
                            selectedColor = Colors.purple;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          setStateDialog(() {
                            selectedIcon = Icons.favorite;
                            selectedColor = Colors.red;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () {
                          setStateDialog(() {
                            selectedIcon = Icons.check_circle;
                            selectedColor = Colors.green;
                          });
                        },
                      ),
                    ],
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
                _buildSection(
                  context,
                  title: 'Sleep & Rest Habits',
                  cards: _sleepHabits
                      .map(
                        (habit) => _buildToolCard(
                          context,
                          habit['name'],
                          habit['desc'],
                          habit['icon'],
                          habit['color'],
                          () {},
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Health Habits',
                  cards: _healthHabits
                      .map(
                        (habit) => _buildToolCard(
                          context,
                          habit['name'],
                          habit['desc'],
                          habit['icon'],
                          habit['color'],
                          () {},
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                _buildSection(
                  context,
                  title: 'Movement & Exercise Habits',
                  cards: _movementHabits
                      .map(
                        (habit) => _buildToolCard(
                          context,
                          habit['name'],
                          habit['desc'],
                          habit['icon'],
                          habit['color'],
                          () {},
                        ),
                      )
                      .toList(),
                ),
                if (_customHabits.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Custom Habits',
                    cards: _customHabits
                        .map(
                          (habit) => _buildToolCard(
                            context,
                            habit['name'],
                            habit['desc'],
                            habit['icon'],
                            habit['color'],
                            () {},
                          ),
                        )
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
