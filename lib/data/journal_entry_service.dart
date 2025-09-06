import 'package:flutter/foundation.dart';

class JournalEntryService {
  static final JournalEntryService _instance = JournalEntryService._internal();
  factory JournalEntryService() => _instance;
  JournalEntryService._internal();
  
  String? _lastMoodEntryDate;
  String? _todayMoodEmoji;
  String? _todayMoodLabel;
  String? _todayTitle;
  String? _todayJournalText;
  double? _todayStressLevel;
  double? _todayAnxietyLevel;
  String? _todayStressReason;
  String? _todayAnxietyReason;
  List<String>? _todayMoodDescriptions;
  String? _todayMoodWhy;
  
  // ValueNotifier to notify listeners when mood entry status changes
  final ValueNotifier<bool> moodEntryStatusNotifier = ValueNotifier<bool>(false);
  
  static final Map<String, String> _moodEmojis = {
    'Very Low': '😢',
    'Low': '😔',
    'Neutral': '😐',
    'Good': '😊',
    'Excellent': '😄',
  };
  
  static Future<void> markMoodEntryCompleted({
    String? moodLabel,
    String? title,
    String? journalText,
    double? stressLevel,
    double? anxietyLevel,
    String? stressReason,
    String? anxietyReason,
    List<String>? moodDescriptions,
    String? moodWhy,
  }) async {
    final instance = JournalEntryService();
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    instance._lastMoodEntryDate = today;
    
    if (moodLabel != null) {
      instance._todayMoodLabel = moodLabel;
      instance._todayMoodEmoji = _moodEmojis[moodLabel];
    }
    
    if (title != null) {
      instance._todayTitle = title;
    }
    
    if (journalText != null) {
      instance._todayJournalText = journalText;
    }
    
    if (stressLevel != null) {
      instance._todayStressLevel = stressLevel;
    }
    
    if (anxietyLevel != null) {
      instance._todayAnxietyLevel = anxietyLevel;
    }
    
    if (stressReason != null) {
      instance._todayStressReason = stressReason;
    }
    
    if (anxietyReason != null) {
      instance._todayAnxietyReason = anxietyReason;
    }
    
    if (moodDescriptions != null) {
      instance._todayMoodDescriptions = List<String>.from(moodDescriptions);
    }
    
    if (moodWhy != null) {
      instance._todayMoodWhy = moodWhy;
    }
    
    // Notify listeners that mood entry status has changed
    instance.moodEntryStatusNotifier.value = true;
    
    print('Mood entry marked as completed for: $today with mood: $moodLabel, journal: ${journalText?.substring(0, journalText.length > 50 ? 50 : journalText.length)}...');
  }
  
  static Future<bool> hasMoodEntryForToday() async {
    final instance = JournalEntryService();
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD format
    
    final hasEntry = instance._lastMoodEntryDate == today;
    
    // Update the notifier value to match the current status
    instance.moodEntryStatusNotifier.value = hasEntry;
    
    print('Checking mood entry for today ($today): $hasEntry');
    return hasEntry;
  }
  
  static Future<void> clearMoodEntryStatus() async {
    final instance = JournalEntryService();
    instance._lastMoodEntryDate = null;
    instance._todayMoodEmoji = null;
    instance._todayMoodLabel = null;
    instance._todayJournalText = null;
    instance._todayStressLevel = null;
    instance._todayAnxietyLevel = null;
    instance._todayStressReason = null;
    instance._todayAnxietyReason = null;
    instance._todayMoodDescriptions = null;
    instance._todayMoodWhy = null;
    
    // Notify listeners that mood entry status has changed
    instance.moodEntryStatusNotifier.value = false;
    
    print('Mood entry status cleared');
  }
  
  static String? getTodayMoodEmoji() {
    final instance = JournalEntryService();
    return instance._todayMoodEmoji;
  }
  
  static String? getTodayMoodLabel() {
    final instance = JournalEntryService();
    return instance._todayMoodLabel;
  }
  
  static String? getTodayTitle() {
    final instance = JournalEntryService();
    return instance._todayTitle;
  }
  
  static String? getTodayJournalText() {
    final instance = JournalEntryService();
    return instance._todayJournalText;
  }
  
  static double? getTodayStressLevel() {
    final instance = JournalEntryService();
    return instance._todayStressLevel;
  }
  
  static double? getTodayAnxietyLevel() {
    final instance = JournalEntryService();
    return instance._todayAnxietyLevel;
  }
  
  static String? getTodayStressReason() {
    final instance = JournalEntryService();
    return instance._todayStressReason;
  }
  
  static String? getTodayAnxietyReason() {
    final instance = JournalEntryService();
    return instance._todayAnxietyReason;
  }
  
  static List<String>? getTodayMoodDescriptions() {
    final instance = JournalEntryService();
    return instance._todayMoodDescriptions != null 
        ? List<String>.from(instance._todayMoodDescriptions!)
        : null;
  }
  
  static String? getTodayMoodWhy() {
    final instance = JournalEntryService();
    return instance._todayMoodWhy;
  }
  
  static ValueNotifier<bool> get moodEntryNotifier {
    final instance = JournalEntryService();
    return instance.moodEntryStatusNotifier;
  }
  
  // Debug method to check current status
  static String getDebugInfo() {
    final instance = JournalEntryService();
    final today = DateTime.now().toIso8601String().split('T')[0];
    return 'Today: $today, Last entry: ${instance._lastMoodEntryDate}, '
        'Mood: ${instance._todayMoodLabel} ${instance._todayMoodEmoji}, '
        'Journal: ${instance._todayJournalText?.substring(0, instance._todayJournalText!.length > 20 ? 20 : instance._todayJournalText!.length) ?? 'N/A'}..., '
        'Stress: ${instance._todayStressLevel ?? 'N/A'}, '
        'Anxiety: ${instance._todayAnxietyLevel ?? 'N/A'}';
  }
}
