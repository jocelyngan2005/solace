import 'package:flutter/material.dart';
import 'dart:math';

class PositiveAffirmationPage extends StatefulWidget {
  const PositiveAffirmationPage({super.key});

  @override
  State<PositiveAffirmationPage> createState() => _PositiveAffirmationPageState();
}

class _PositiveAffirmationPageState extends State<PositiveAffirmationPage> {
  String currentAffirmation = '';
  String selectedMood = 'stressed';
  List<String> favoriteAffirmations = [];
  
  final Map<String, AffirmationCategory> affirmationCategories = {
    'stressed': AffirmationCategory(
      name: 'Stressed',
      color: const Color(0xFF1D006F),
      icon: Icons.sentiment_neutral,
      affirmations: [
        'You are capable of handling challenges, one step at a time.',
        'This feeling is temporary. You have overcome difficulties before.',
        'You are stronger than you think and braver than you feel.',
        'It\'s okay to take breaks. Rest is part of progress.',
        'You don\'t have to be perfect. You just have to be you.',
        'Every deep breath brings you closer to peace.',
        'You are doing the best you can with what you have.',
        'This too shall pass. You will get through this.',
      ],
    ),
    'anxious': AffirmationCategory(
      name: 'Anxious',
      color:  const Color(0xFFA23900),
      icon: Icons.sentiment_dissatisfied,
      affirmations: [
        'You are safe in this moment. Ground yourself in the present.',
        'Your thoughts are not facts. You can observe them without believing them.',
        'You have survived 100% of your difficult days so far.',
        'Anxiety is temporary. Your strength is permanent.',
        'You are not your anxiety. You are the observer of your thoughts.',
        'Each breath you take calms your mind and body.',
        'You are in control of your response to this feeling.',
        'This feeling will pass. You are bigger than your anxiety.',
      ],
    ),
    'overwhelmed': AffirmationCategory(
      name: 'Overwhelmed',
      color: const Color(0xFF4B3426),
      icon: Icons.sentiment_very_dissatisfied,
      affirmations: [
        'You don\'t have to do everything at once. Focus on one thing.',
        'It\'s okay to ask for help. You don\'t have to do this alone.',
        'Break it down into smaller steps. You can handle each piece.',
        'Progress is progress, no matter how small.',
        'You are allowed to say no to things that drain you.',
        'Take it one breath, one moment, one step at a time.',
        'You are more organized and capable than you realize.',
        'Prioritize what matters most. The rest can wait.',
      ],
    ),
    'sad': AffirmationCategory(
      name: 'Sad',
      color: const Color(0xFFA27A00),
      icon: Icons.sentiment_very_dissatisfied,
      affirmations: [
        'It\'s okay to feel sad. Your emotions are valid.',
        'This pain you feel is not permanent. Healing takes time.',
        'You are worthy of love and kindness, especially from yourself.',
        'Tomorrow is a new day with new possibilities.',
        'You have people who care about you, even when you feel alone.',
        'Your sensitivity is a strength, not a weakness.',
        'You are allowed to grieve and take time to heal.',
        'Even in darkness, there is always a light waiting to shine.',
      ],
    ),
    'unconfident': AffirmationCategory(
      name: 'Unconfident',
      color: const Color(0xFF5A6B37),
      icon: Icons.sentiment_satisfied,
      affirmations: [
        'You are enough, exactly as you are right now.',
        'You have unique gifts and talents that the world needs.',
        'You are worthy of success and happiness.',
        'Your voice matters. Your opinions are valuable.',
        'You have overcome challenges before. You can do it again.',
        'You are braver than you believe and stronger than you seem.',
        'Trust yourself. You know more than you think you do.',
        'You belong here. You have every right to take up space.',
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _generateNewAffirmation();
  }

  void _generateNewAffirmation() {
    final category = affirmationCategories[selectedMood]!;
    final random = Random();
    String newAffirmation;
    
    do {
      newAffirmation = category.affirmations[random.nextInt(category.affirmations.length)];
    } while (newAffirmation == currentAffirmation && category.affirmations.length > 1);
    
    setState(() {
      currentAffirmation = newAffirmation;
    });
  }

  void _toggleFavorite() {
    setState(() {
      if (favoriteAffirmations.contains(currentAffirmation)) {
        favoriteAffirmations.remove(currentAffirmation);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites')),
        );
      } else {
        favoriteAffirmations.add(currentAffirmation);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites')),
        );
      }
    });
  }

  void _shareAffirmation() {
    // In a real app, this would use share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affirmation copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = affirmationCategories[selectedMood]!;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => _showFavorites(),
            tooltip: 'View Favorites',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
            'Positive Affirmations',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalized positive thoughts for you',
            style: Theme.of(context).textTheme.bodyMedium
          ),
              
              const SizedBox(height: 16),

              // Daily Reminder Toggle
              Flexible(
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Daily Reminders',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Get positive affirmations throughout the day',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: false,
                        onChanged: (value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notification settings would open here')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ),
              
              const SizedBox(height: 16),
              
              // Mood Selector
              Text(
                'How are you feeling?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: affirmationCategories.length,
                  itemBuilder: (context, index) {
                    final entry = affirmationCategories.entries.elementAt(index);
                    final moodKey = entry.key;
                    final moodCategory = entry.value;
                    final isSelected = selectedMood == moodKey;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedMood = moodKey;
                          });
                          _generateNewAffirmation();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? moodCategory.color.withOpacity(0.15) : Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isSelected ? moodCategory.color : Colors.grey[300]!,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                moodCategory.icon,
                                color: isSelected ? moodCategory.color : Colors.grey[600],
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                moodCategory.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? moodCategory.color : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
                const SizedBox(height: 18),
                
                // Affirmation Card
                SizedBox(
                height: 240, // Fixed height for the card
                child: Card(
                  elevation: 8, // Increased elevation for more shadow
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                      blurRadius: 18,
                      offset: const Offset(0, 0),
                    ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Icon(
                      Icons.format_quote_rounded,
                      size: 42,
                      color: category.color.withOpacity(0.7),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Center(
                      child: Text(
                        currentAffirmation,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ],
                  ),
                  ),
                ),
                ),
              const SizedBox(height: 16),
              // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [                            
                            _buildActionButton(
                              icon: Icons.loop,
                              label: 'New',
                              color: Theme.of(context).colorScheme.onSurface,
                              onTap: _generateNewAffirmation,
                            ),
                            const SizedBox(width: 12),
                            _buildActionButton(
                              icon: favoriteAffirmations.contains(currentAffirmation)
                                ? Icons.favorite
                                : Icons.favorite_border,
                              label: 'Favorite',
                              color: Theme.of(context).colorScheme.tertiary,
                              onTap: _toggleFavorite,
                            ),
                            const SizedBox(width: 12),
                            _buildActionButton(
                              icon: Icons.share,
                              label: 'Share',
                              color: Theme.of(context).colorScheme.onSurface,
                              onTap: _shareAffirmation,
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFavorites() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Favorite Affirmations',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            if (favoriteAffirmations.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the heart icon to save affirmations',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: favoriteAffirmations.length,
                  itemBuilder: (context, index) {
                    final affirmation = favoriteAffirmations[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              affirmation,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                        
                        ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                favoriteAffirmations.remove(affirmation);
                              });
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AffirmationCategory {
  final String name;
  final Color color;
  final IconData icon;
  final List<String> affirmations;

  AffirmationCategory({
    required this.name,
    required this.color,
    required this.icon,
    required this.affirmations,
  });
}
