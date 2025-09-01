import 'package:flutter/material.dart';
import 'meditation_session.dart';

class MeditationPage extends StatefulWidget {
  const MeditationPage({super.key});

  @override
  State<MeditationPage> createState() => _MeditationPageState();
}

class _MeditationPageState extends State<MeditationPage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Stress Relief', 'Anxiety', 'Sleep Aid', 'Confidence Boost'];
  
  final List<MeditationSession> sessions = [
    MeditationSession(
      title: 'Deep Relaxation',
      duration: '5 min',
      category: 'Stress Relief',
      description: 'Release tension and find inner calm',
      color: Colors.purple,
    ),
    MeditationSession(
      title: 'Exam Confidence',
      duration: '3 min',
      category: 'Anxiety',
      description: 'Build confidence before tests',
      color: Colors.teal,
    ),
    MeditationSession(
      title: 'Peaceful Sleep',
      duration: '10 min',
      category: 'Sleep Aid',
      description: 'Gentle guidance to restful sleep',
      color: Colors.green,
    ),
    MeditationSession(
      title: 'Morning Motivation',
      duration: '4 min',
      category: 'Confidence Boost',
      description: 'Start your day with positive energy',
      color: Colors.amber,
    ),
    MeditationSession(
      title: 'Study Break Reset',
      duration: '2 min',
      category: 'Stress Relief',
      description: 'Quick mental refresh between studies',
      color: Colors.purple,
    ),
    MeditationSession(
      title: 'Pre-Presentation Calm',
      duration: '3 min',
      category: 'Anxiety',
      description: 'Steady your nerves before speaking',
      color: Colors.teal,
    ),
  ];

  List<MeditationSession> get filteredSessions {
    if (selectedCategory == 'All') {
      return sessions;
    }
    return sessions.where((session) => session.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness Library'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
            'Find Your Peace',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Guided meditations for every moment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
              
              const SizedBox(height: 24),
              
              // Category Filter
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Theme.of(context).colorScheme.primary,
                        checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                        labelStyle: TextStyle(
                          color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sessions List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSessions.length,
                  itemBuilder: (context, index) {
                    final session = filteredSessions[index];
                    return _buildSessionCard(session);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSessionCard(MeditationSession session) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: session.color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow,
            color: session.color,
            size: 24,
          ),
        ),
        title: Text(
          session.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              session.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: session.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: session.color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MeditationSessionPage(session: session),
            ),
          );
        },
      ),
    );
  }
}
