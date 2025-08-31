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
      color: const Color(0xFF8B5FBF),
    ),
    MeditationSession(
      title: 'Exam Confidence',
      duration: '3 min',
      category: 'Anxiety',
      description: 'Build confidence before tests',
      color: const Color(0xFF5FB3BF),
    ),
    MeditationSession(
      title: 'Peaceful Sleep',
      duration: '10 min',
      category: 'Sleep Aid',
      description: 'Gentle guidance to restful sleep',
      color: const Color(0xFF7FB35F),
    ),
    MeditationSession(
      title: 'Morning Motivation',
      duration: '4 min',
      category: 'Confidence Boost',
      description: 'Start your day with positive energy',
      color: const Color(0xFFBF7A5F),
    ),
    MeditationSession(
      title: 'Study Break Reset',
      duration: '2 min',
      category: 'Stress Relief',
      description: 'Quick mental refresh between studies',
      color: const Color(0xFF8B5FBF),
    ),
    MeditationSession(
      title: 'Pre-Presentation Calm',
      duration: '3 min',
      category: 'Anxiety',
      description: 'Steady your nerves before speaking',
      color: const Color(0xFF5FB3BF),
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
      backgroundColor: const Color(0xFFFCB1A6),
      appBar: AppBar(
        title: const Text('Mindfulness & Meditation'),
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
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFB6376).withOpacity(0.6),  // Soft pink
                      const Color(0xFFFB6376),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9EC).withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.self_improvement,
                        color: Color(0xFFFFF9EC),
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find Your Peace',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFFF9EC),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Guided meditations for every moment',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFFFFF9EC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Category Filter
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFFF0FFF1),
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
                        backgroundColor: const Color(0xFF5D2A42).withOpacity(0.4),
                        selectedColor: const Color(0xFFFB6376).withOpacity(0.4),
                        checkmarkColor: const Color(0xFFFB6376),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFFFB6376) : const Color(0xFF5D2A42),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFFB6376) : Colors.transparent,
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDCCC), 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(session.description),
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
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: session.color,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    session.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
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
