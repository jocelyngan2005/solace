import 'package:flutter/material.dart';
import '../../data/badges.dart';
import '../../widgets/dashboard_card.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AchievementCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildCategoriesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final unlockedAchievements = AchievementData.getUnlockedAchievements();
    final totalAchievements = AchievementData.getTotalAchievements();
    final completionPercentage = AchievementData.getCompletionPercentage();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Overview
          DashboardCard(
            title: '📊 Progress Overview',
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${unlockedAchievements.length} / $totalAchievements',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${completionPercentage.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: completionPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep going! You\'re doing great!',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Recent Achievements
          DashboardCard(
            title: '🆕 Recently Unlocked',
            child: unlockedAchievements.isEmpty
                ? const Text('Complete activities to unlock your first achievement!')
                : Column(
                    children: unlockedAchievements
                        .take(3)
                        .map((achievement) => _buildAchievementTile(achievement, true))
                        .toList(),
                  ),
          ),

          const SizedBox(height: 16),

          // Category Breakdown
          DashboardCard(
            title: '📈 Category Progress',
            child: Column(
              children: AchievementCategory.values.map((category) {
                final categoryAchievements = AchievementData.getAchievementsByCategory(category);
                final unlockedInCategory = categoryAchievements.where((a) => a.isUnlocked).length;
                final progress = unlockedInCategory / categoryAchievements.length;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _navigateToCategory(category),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              AchievementData.getCategoryEmoji(category),
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AchievementData.getCategoryName(category),
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '$unlockedInCategory/${categoryAchievements.length}',
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                            color: Colors.grey[400],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _getCategoryColor(category),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return Column(
      children: [
        // Category Filter
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AchievementCategory.values.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                );
              }

              final category = AchievementCategory.values[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text('${AchievementData.getCategoryEmoji(category)} ${AchievementData.getCategoryName(category)}'),
                  selected: _selectedCategory == category,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : null;
                    });
                  },
                ),
              );
            },
          ),
        ),

        // Achievements List
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: _getFilteredAchievements()
                .map((achievement) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildAchievementCard(achievement),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  List<Achievement> _getFilteredAchievements() {
    if (_selectedCategory == null) {
      return AchievementData.allAchievements;
    }
    return AchievementData.getAchievementsByCategory(_selectedCategory!);
  }

  Widget _buildAchievementTile(Achievement achievement, bool showDate) {
    return ListTile(
      onTap: achievement.isUnlocked ? () => _showAchievementDetails(achievement) : null,
      leading: CircleAvatar(
        backgroundColor: achievement.isUnlocked
            ? achievement.color.withOpacity(0.2)
            : Colors.grey[300],
        child: Text(
          achievement.emoji,
          style: TextStyle(
            fontSize: 20,
            color: achievement.isUnlocked ? null : Colors.grey,
          ),
        ),
      ),
      title: Text(
        achievement.title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: achievement.isUnlocked ? null : Colors.grey,
        ),
      ),
      subtitle: Text(
        achievement.description,
        style: TextStyle(
          color: achievement.isUnlocked ? Colors.grey[600] : Colors.grey[400],
        ),
      ),
      trailing: achievement.isUnlocked
          ? Icon(Icons.check_circle, color: achievement.color)
          : Icon(Icons.lock, color: Colors.grey[400]),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return GestureDetector(
      onTap: achievement.isUnlocked ? () => _showAchievementDetails(achievement) : null,
      child: Card(
        elevation: achievement.isUnlocked ? 2 : 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withOpacity(0.2)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: achievement.isUnlocked
                        ? achievement.color.withOpacity(0.5)
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    achievement.emoji,
                    style: TextStyle(
                      fontSize: 24,
                      color: achievement.isUnlocked ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            achievement.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: achievement.isUnlocked ? null : Colors.grey,
                            ),
                          ),
                        ),
                        if (achievement.isUnlocked)
                          Icon(
                            Icons.check_circle,
                            color: achievement.color,
                            size: 20,
                          )
                        else
                          Icon(
                            Icons.lock,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        color: achievement.isUnlocked ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                    if (!achievement.isUnlocked) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Required: ${achievement.requirement}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    if (achievement.isUnlocked && achievement.unlockedDate != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Unlocked: ${_formatDate(achievement.unlockedDate!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: achievement.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.streak:
        return Colors.orange;
      case AchievementCategory.mindfulness:
        return Colors.green;
      case AchievementCategory.wellness:
        return Colors.blue;
      case AchievementCategory.academic:
        return Colors.red;
      case AchievementCategory.personal:
        return Colors.purple;
      case AchievementCategory.milestone:
        return Colors.amber;
      case AchievementCategory.challenge:
        return Colors.teal;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToCategory(AchievementCategory category) {
    // Switch to the Categories tab
    _tabController.animateTo(1);
    
    // Set the selected category filter
    setState(() {
      _selectedCategory = category;
    });
  }

  void _showAchievementDetails(Achievement achievement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Text(
                achievement.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  achievement.title,
                  style: TextStyle(
                    color: achievement.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: achievement.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: achievement.color.withOpacity(0.3)),
                ),
                child: Text(
                  achievement.category.toString().split('.').last.toUpperCase(),
                  style: TextStyle(
                    color: achievement.color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                achievement.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
              if (achievement.unlockedDate != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Achievement Unlocked!',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Unlocked on ${_formatDate(achievement.unlockedDate!)}',
                              style: TextStyle(
                                color: Colors.green.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: achievement.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
