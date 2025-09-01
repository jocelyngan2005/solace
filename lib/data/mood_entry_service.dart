import 'package:flutter/foundation.dart';

class MoodEntryService {
  static final MoodEntryService _instance = MoodEntryService._internal();
  factory MoodEntryService() => _instance;
  MoodEntryService._internal();
  
  String? _lastMoodEntryDate;
  String? _todayMoodEmoji;
  String? _todayMoodLabel;
  
  // ValueNotifier to notify listeners when mood entry status changes
  final ValueNotifier<bool> moodEntryStatusNotifier = ValueNotifier<bool>(false);
  
  static final Map<String, String> _moodEmojis = {
    'Very Low': '😢',
    'Low': '😔',
    'Neutral': '😐',
    'Good': '😊',
    'Excellent': '😄',
  };
  
  static Future<void> markMoodEntryCompleted({String? moodLabel}) async {
    final instance = MoodEntryService();
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    instance._lastMoodEntryDate = today;
    
    if (moodLabel != null) {
      instance._todayMoodLabel = moodLabel;
      instance._todayMoodEmoji = _moodEmojis[moodLabel];
    }
    
    // Notify listeners that mood entry status has changed
    instance.moodEntryStatusNotifier.value = true;
    
    print('Mood entry marked as completed for: $today with mood: $moodLabel');
  }
  
  static Future<bool> hasMoodEntryForToday() async {
    final instance = MoodEntryService();
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    
    final hasEntry = instance._lastMoodEntryDate == today;
    
    // Update the notifier value to match the current status
    instance.moodEntryStatusNotifier.value = hasEntry;
    
    print('Checking mood entry for today ($today): $hasEntry');
    return hasEntry;
  }
  
  static Future<void> clearMoodEntryStatus() async {
    final instance = MoodEntryService();
    instance._lastMoodEntryDate = null;
    instance._todayMoodEmoji = null;
    instance._todayMoodLabel = null;
    
    // Notify listeners that mood entry status has changed
    instance.moodEntryStatusNotifier.value = false;
    
    print('Mood entry status cleared');
  }
  
  static String? getTodayMoodEmoji() {
    final instance = MoodEntryService();
    return instance._todayMoodEmoji;
  }
  
  static String? getTodayMoodLabel() {
    final instance = MoodEntryService();
    return instance._todayMoodLabel;
  }
  
  static ValueNotifier<bool> get moodEntryNotifier {
    final instance = MoodEntryService();
    return instance.moodEntryStatusNotifier;
  }
  
  // Debug method to check current status
  static String getDebugInfo() {
    final instance = MoodEntryService();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return 'Today: $today, Last entry: ${instance._lastMoodEntryDate}, Mood: ${instance._todayMoodLabel} ${instance._todayMoodEmoji}';
  }
}
