import 'package:flutter/material.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  _HabitTrackerState createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
      ),
      body: Center(
        child: const Text('Track your habits here!'),
      ),
    );
  }
}