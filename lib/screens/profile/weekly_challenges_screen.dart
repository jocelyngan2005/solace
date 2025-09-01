import 'package:flutter/material.dart';
import '../../data/weekly_challenges.dart';
import '../../data/weekly_challenge_service.dart';
import '../../widgets/dashboard_card.dart';
import '../../theme/app_theme.dart';
import 'challenge_detail_screen.dart';

class WeeklyChallengesScreen extends StatefulWidget {
  const WeeklyChallengesScreen({super.key});

  @override
  State<WeeklyChallengesScreen> createState() => _WeeklyChallengesScreenState();
}

class _WeeklyChallengesScreenState extends State<WeeklyChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late WeeklyChallengeService _challengeService;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _challengeService = WeeklyChallengeService();
    _challengeService.initialize();
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
        title: const Text('Weekly Challenges'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppTheme.darkGray,
              unselectedLabelColor: AppTheme.mediumGray,
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Available'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveChallenges(),
          _buildAvailableChallenges(),
          _buildCompletedChallenges(),
        ],
      ),
    );
  }

  Widget _buildActiveChallenges() {
    final activeChallenges = _challengeService.getActiveChallenges();

    if (activeChallenges.isEmpty) {
      return _buildEmptyState(
        icon: Icons.play_arrow,
        title: 'No Active Challenges',
        subtitle: 'Start a challenge from the Available tab to begin your wellness journey!',
        actionText: 'Browse Challenges',
        onAction: () => _tabController.animateTo(1),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeChallenges.length,
      itemBuilder: (context, index) {
        final challenge = activeChallenges[index];
        return _buildActiveChallengeCard(challenge);
      },
    );
  }

  Widget _buildAvailableChallenges() {
    final allAvailableChallenges = _challengeService.getAvailableChallenges();
    final featuredChallenge = _challengeService.getFeaturedChallenge();
    
    // Filter challenges based on selected category
    final filteredChallenges = _selectedCategory == null 
        ? allAvailableChallenges
        : allAvailableChallenges.where((challenge) => 
            _getCategoryName(challenge.type) == _selectedCategory
          ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Card
          _buildStatisticsCard(),
          
          const SizedBox(height: 16),

          // Featured Challenge
          if (featuredChallenge != null) ...[
            Text(
              '⭐ Featured This Week',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeaturedChallengeCard(featuredChallenge),
            const SizedBox(height: 24),
          ],

          // Filter Options
          Text(
            'Browse All Challenges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 12),

          // Category Filters
          _buildCategoryFilters(),
          
          const SizedBox(height: 16),

          // Available Challenges List
          ...filteredChallenges.map((challenge) => 
            _buildAvailableChallengeCard(challenge)),
        ],
      ),
    );
  }

  Widget _buildCompletedChallenges() {
    final completedChallenges = _challengeService.getCompletedChallenges();

    if (completedChallenges.isEmpty) {
      return _buildEmptyState(
        icon: Icons.emoji_events,
        title: 'No Completed Challenges',
        subtitle: 'Complete challenges to see your achievements here!',
        actionText: 'Start a Challenge',
        onAction: () => _tabController.animateTo(1),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedChallenges.length,
      itemBuilder: (context, index) {
        final challenge = completedChallenges[index];
        return _buildCompletedChallengeCard(challenge);
      },
    );
  }

  Widget _buildStatisticsCard() {
    final stats = _challengeService.getStatistics();
    
    return DashboardCard(
      title: '📊 Your Challenge Stats',
      child: Column(
        children: [
          // Challenge Stats Row - matching profile screen design
          Row(
            children: [
              Expanded(
                child: _buildChallengeStatCard(
                  'Active',
                  '${stats['activeChallenges']}',
                  Colors.blue,
                  Icons.play_arrow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChallengeStatCard(
                  'Completed',
                  '${stats['completedChallenges']}',
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildChallengeStatCard(
                  'XP Earned',
                  '${stats['totalXpEarned']}',
                  Colors.purple,
                  Icons.star,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: stats['completionRate'].toDouble(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.pastelBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completion Rate: ${(stats['completionRate'] * 100).toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.mediumGray,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeStatCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFeaturedChallengeCard(WeeklyChallenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.pastelBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                challenge.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.lightPeach,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 12, color: AppTheme.darkGray),
                              const SizedBox(width: 4),
                              Text(
                                'FEATURED',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${challenge.xpReward} XP',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      challenge.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        color: AppTheme.mediumGray,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _startChallenge(challenge),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.pastelBlue,
                    foregroundColor: AppTheme.darkGray,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Challenge'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _showChallengeDetails(challenge),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.pastelBlue),
                  foregroundColor: AppTheme.darkGray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Details'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = ChallengeType.values;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "All" filter option
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _selectedCategory == null 
                      ? AppTheme.pastelBlue 
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedCategory == null 
                        ? AppTheme.pastelBlue 
                        : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Text(
                  'All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _selectedCategory == null 
                        ? Colors.white 
                        : AppTheme.darkGray,
                  ),
                ),
              ),
            ),
            // Category filters
            ...categories.map((type) {
              final categoryName = _getCategoryName(type);
              final isSelected = _selectedCategory == categoryName;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = isSelected ? null : categoryName;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getCategoryColor(type) 
                        : _getCategoryColor(type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getCategoryColor(type).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                          ? Colors.white 
                          : AppTheme.darkGray,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveChallengeCard(WeeklyChallenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                challenge.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      challenge.description,
                      style: TextStyle(
                        color: AppTheme.mediumGray,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: challenge.daysRemaining <= 2 
                      ? AppTheme.paleRose.withOpacity(0.5) 
                      : AppTheme.lightGray.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${challenge.daysRemaining} days left',
                  style: TextStyle(
                    color: challenge.daysRemaining <= 2 
                        ? AppTheme.darkGray 
                        : AppTheme.mediumGray,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: ${challenge.currentProgress}/${challenge.targetCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        Text(
                          '${(challenge.progressPercentage * 100).toInt()}%',
                          style: TextStyle(
                            color: AppTheme.pastelBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: challenge.progressPercentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.pastelBlue,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showChallengeDetails(challenge),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.pastelBlue,
                    foregroundColor: AppTheme.darkGray,
                    elevation: 0,
                  ),
                  child: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => _updateProgress(challenge),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppTheme.pastelBlue),
                  foregroundColor: AppTheme.darkGray,
                ),
                child: const Text('Update Progress'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.darkGray),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableChallengeCard(WeeklyChallenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
        leading: Text(
          challenge.emoji, 
          style: const TextStyle(fontSize: 24)
        ),
        title: Text(
          challenge.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              challenge.description,
              style: TextStyle(color: AppTheme.mediumGray),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildInfoChip(
                  Icons.schedule,
                  '${challenge.durationDays} days',
                  AppTheme.pastelBlue,
                ),
                _buildInfoChip(
                  Icons.star_outline,
                  '${challenge.xpReward} XP',
                  Colors.amber,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(challenge.difficulty).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    challenge.difficultyLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _startChallenge(challenge),
          icon: Icon(
            Icons.arrow_forward_ios,
            color: AppTheme.pastelBlue,
            size: 20,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.pastelBlue.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onTap: () => _showChallengeDetails(challenge),
      ),
    );
  }

  Widget _buildCompletedChallengeCard(WeeklyChallenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppTheme.pastelBlue.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          Icons.check_circle_outline, 
          color: AppTheme.pastelBlue, 
          size: 28
        ),
        title: Text(
          challenge.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              challenge.description,
              style: TextStyle(color: AppTheme.mediumGray),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, size: 12, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'Completed • ${challenge.xpReward} XP earned',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.amber.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.pastelBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.check_circle, color: AppTheme.pastelBlue, size: 20),
        ),
        onTap: () => _showChallengeDetails(challenge),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.lightGray.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppTheme.mediumGray,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.mediumGray,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.pastelBlue,
                foregroundColor: AppTheme.darkGray,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryName(ChallengeType type) {
    switch (type) {
      case ChallengeType.habit:
        return 'Habits';
      case ChallengeType.wellbeing:
        return 'Wellbeing';
      case ChallengeType.mindfulness:
        return 'Mindfulness';
      case ChallengeType.social:
        return 'Social';
      case ChallengeType.academic:
        return 'Academic';
      case ChallengeType.creativity:
        return 'Creativity';
    }
  }

  Color _getCategoryColor(ChallengeType type) {
    switch (type) {
      case ChallengeType.habit:
        return AppTheme.pastelBlue;
      case ChallengeType.wellbeing:
        return AppTheme.softMint;
      case ChallengeType.mindfulness:
        return AppTheme.softLavender;
      case ChallengeType.social:
        return AppTheme.paleRose;
      case ChallengeType.academic:
        return AppTheme.lightPeach;
      case ChallengeType.creativity:
        return AppTheme.warmBeige;
    }
  }

  Color _getDifficultyColor(ChallengeDifficulty difficulty) {
    switch (difficulty) {
      case ChallengeDifficulty.beginner:
        return AppTheme.softMint;
      case ChallengeDifficulty.intermediate:
        return AppTheme.lightPeach;
      case ChallengeDifficulty.advanced:
        return AppTheme.paleRose;
    }
  }

  Future<void> _startChallenge(WeeklyChallenge challenge) async {
    final success = await _challengeService.startChallenge(challenge.id);
    
    if (success) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Started "${challenge.title}" challenge!', style: TextStyle(color: AppTheme.darkGray)),
          backgroundColor: AppTheme.pastelBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      _tabController.animateTo(0); // Switch to Active tab
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not start challenge. You may have too many active challenges.'),
          backgroundColor: AppTheme.paleRose,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showChallengeDetails(WeeklyChallenge challenge) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChallengeDetailScreen(
          challenge: challenge,
          challengeService: _challengeService,
          onUpdate: () => setState(() {}),
        ),
      ),
    );
  }

  Future<void> _updateProgress(WeeklyChallenge challenge) async {
    final result = await _challengeService.updateProgress(
      challenge.id,
      context: context,
    );
    
    if (result.success) {
      setState(() {});
      
      if (result.challengeCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '🎉 Challenge "${challenge.title}" completed!',
              style: TextStyle(color: AppTheme.darkGray),
            ),
            backgroundColor: AppTheme.pastelBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Progress updated!',
              style: TextStyle(color: AppTheme.darkGray),
            ),
            backgroundColor: AppTheme.pastelBlue,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}
