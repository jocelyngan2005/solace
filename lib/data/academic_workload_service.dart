import 'package:flutter/material.dart';

class AcademicWorkloadService {
  static final Map<String, Color> _workloadColors = {
    'High': Colors.red,
    'Med': Colors.orange,
    'Low': Colors.green,
  };

  static final Map<String, String> _workloadLabels = {
    'High': 'High',
    'Med': 'Medium',
    'Low': 'Low',
  };

  // Get workload for a specific date
  static String getWorkloadForDate(DateTime date) {
    final today = DateTime.now();
    final daysDifference = date.difference(today).inDays;
    
    // Current week pattern (as shown in academic_screen.dart)
    final currentWeekPattern = ['High', 'Med', 'High', 'Low', 'Med', 'Low', 'Low'];
    
    // For current week
    if (daysDifference >= 0 && daysDifference < 7) {
      final dayOfWeek = date.weekday - 1; // Convert to 0-6 (Monday = 0)
      return currentWeekPattern[dayOfWeek];
    }
    
    // For past and future weeks, generate based on date patterns
    final weekNumber = (daysDifference / 7).floor();
    final dayOfWeek = date.weekday - 1;
    
    // Create varied patterns for different weeks
    final patterns = [
      ['High', 'Med', 'High', 'Low', 'Med', 'Low', 'Low'], // Current week
      ['Med', 'High', 'Low', 'Med', 'High', 'Low', 'Med'], // Week +1/-1
      ['Low', 'Med', 'Med', 'High', 'Low', 'Med', 'Low'], // Week +2/-2
      ['High', 'Low', 'High', 'Med', 'Low', 'High', 'Med'], // Week +3/-3
    ];
    
    final patternIndex = weekNumber.abs() % patterns.length;
    return patterns[patternIndex][dayOfWeek];
  }

  // Get color for workload level
  static Color getWorkloadColor(String workload) {
    return _workloadColors[workload] ?? Colors.grey;
  }

  // Get full label for workload level
  static String getWorkloadLabel(String workload) {
    return _workloadLabels[workload] ?? workload;
  }

  // Get current week overview (for academic screen)
  static List<Map<String, dynamic>> getCurrentWeekOverview() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final workloads = ['High', 'Med', 'High', 'Low', 'Med', 'Low', 'Low'];
    
    return List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return {
        'day': days[index],
        'workload': workloads[index],
        'color': getWorkloadColor(workloads[index]),
        'date': date,
      };
    });
  }
}
